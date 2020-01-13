import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class MsgPage extends StatefulWidget {
  @override
  _MsgPageState createState() => _MsgPageState();
}


class _MsgPageState extends State<MsgPage> {
  final formKey = GlobalKey<FormState>();
  String _msg;
  mqtt.MqttClient client;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initMqtt();
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter your message",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._msg = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send),
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

  Future<void> initMqtt() async {
    client = mqtt.MqttClient('broker.hivemq.com','iotUserApp');
    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.secure = false;
    client.logging(on: true);

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
      .withClientIdentifier('iotUserApp')
      .withWillTopic('initTopic')
      .withWillMessage('init')
      .startClean()
      .withWillQos(mqtt.MqttQos.atLeastOnce);
    client.connectionMessage = connMess;

    await client.connect();
  }

  void _sendMsg() {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    const String pubTopic = 'home/vsullivan/testI';
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(this._msg);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == mqtt.MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }
}