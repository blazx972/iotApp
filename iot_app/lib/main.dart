import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

void main() async => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iotek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Iotek'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  mqtt.MqttClient client;
  final formKey = GlobalKey<FormState>();
  String _msg;
  String _city;
  String _ytUsername;
  String _ytChannelId;

  @override
  void initState() {
    super.initState();
  }

  /// Index for the current page [bottomNavigationBar]
  int _selectedIndex = 0;

  ///Take index of the new page [bottomNavigationBar]
  // void _onItemTapped(int index) {
  //   setState(() {
  //     if (index == 1)
  //       Navigator.push(context, YtPage());
  //     else if (index == 2)
  //       Navigator.push(context, WeatherPage());
  //     else
  //       _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    initMqtt();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
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
                                labelText: "Enter youtuber channel Id",
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
              )
          ],
        ),
      ),

      // Navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.youtube_searched_for),
            title: Text('Youtube'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            title: Text('Meteo'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        //onTap: _onItemTapped,
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _sendMsg();
      //   },
      //   tooltip: 'Send',
      //   child: Icon(Icons.send),
      // ),
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

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == mqtt.MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }
}
