import 'package:flutter/material.dart';
import 'package:iot_app/settingsMqtt.dart';
import 'package:iot_app/weatherPage.dart';
import 'package:iot_app/ytPage.dart';
import 'package:iot_app/msgPage.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;


void main() async => runApp(MyApp());

class MyApp extends StatelessWidget {
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

  @override
  void initState() {
    super.initState();
  }

  /// Index for the current page [bottomNavigationBar]
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    initMqtt();
    List<Widget> _widgetOptions = <Widget>[
      MsgPage(client),
      YtPage(client),
      WeatherPage(client),
      SettingMqtt(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text(widget.title, textAlign: TextAlign.center)),
      ),
      body: SingleChildScrollView(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
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

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == mqtt.MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
  }
}
