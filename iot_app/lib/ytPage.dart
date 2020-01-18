import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:firebase_database/firebase_database.dart';

class YtPage extends StatefulWidget {
  final mqtt.MqttClient client;
  YtPage(this.client);
  @override
  _YtPageState createState() => _YtPageState(client);
}


class _YtPageState extends State<YtPage> {
  final mqtt.MqttClient clientParent;
  _YtPageState(this.clientParent);

  final formKey = GlobalKey<FormState>();
  String _ytUsername;
  String _ytChannelId;
  mqtt.MqttClient client;

  @override
  void initState() {
    client = clientParent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter youtuber channel",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._ytUsername = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                _sendYoutubeUsername();
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Or youtuber channel Id",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._ytChannelId = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                _sendYoutubeChannelId();
              }
            ),
          ),
        ],
      ),
      key: formKey,
    );
  }

  void _sendYoutubeUsername() async {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }

    String pubTopic = (await FirebaseDatabase.instance.reference().child("mqtt/ytusername").once()).value;
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(_ytUsername);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }

  void _sendYoutubeChannelId() async {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    
    String pubTopic = (await FirebaseDatabase.instance.reference().child("mqtt/ytchannelid").once()).value;
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(_ytChannelId);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }
}