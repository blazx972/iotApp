import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

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
                      labelText: "Enter youtuber channel",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._ytUsername = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send),
              onPressed: () {
                _sendYoutubeUsername();
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Or youtuber channel Id",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._ytChannelId = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send),
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

  void _sendYoutubeUsername() {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    const String pubTopic = 'home/vsullivan/youtube/usersame';
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(_ytUsername);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }

  void _sendYoutubeChannelId() {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    const String pubTopic = 'home/vsullivan/youtube/channel_id';
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(_ytChannelId);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }
}