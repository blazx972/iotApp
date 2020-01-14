import 'package:flutter/material.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class WeatherPage extends StatefulWidget {
  final mqtt.MqttClient client;
  WeatherPage(this.client);
  @override
  _WeatherPageState createState() => _WeatherPageState(client);
}


class _WeatherPageState extends State<WeatherPage> {
  final mqtt.MqttClient clientParent;
  _WeatherPageState(this.clientParent);

  final formKey = GlobalKey<FormState>();
  String _city;
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
                      labelText: "Enter the city",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._city = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send),
              onPressed: () {
                _sendCity();
              }
            ),
          ),
        ],
      ),
      key: formKey,
    );
  }

  void _sendCity() {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    const String pubTopic = 'home/vsullivan/meteo';
    final mqtt.MqttClientPayloadBuilder builder = mqtt.MqttClientPayloadBuilder();
    builder.addString(_city);
    client.publishMessage(pubTopic, mqtt.MqttQos.exactlyOnce, builder.payload);
  }
}