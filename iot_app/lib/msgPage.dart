import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:firebase_database/firebase_database.dart';

class MsgPage extends StatefulWidget {
  final mqtt.MqttClient client;
  MsgPage(this.client);
  @override
  _MsgPageState createState() => _MsgPageState(client);
}


class _MsgPageState extends State<MsgPage> {
  final mqtt.MqttClient clientParent;
  _MsgPageState(this.clientParent);

  final formKey = GlobalKey<FormState>();
  String _msg;
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
                      labelText: "Enter your message",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._msg = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send, color: Colors.blue),
              onPressed: () {
                _sendMsg();
              }
            ),
          ),
        ],
      ),
      key: formKey,
    );
  }

  void _sendMsg() async {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    
    String pubTopic = (await FirebaseDatabase.instance.reference().child("mqtt/message").once()).value;
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(this._msg);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }
}