import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


final databaseReference = FirebaseDatabase.instance.reference();


class SettingMqtt extends StatefulWidget {
  @override
  _SettingMqttState createState() => _SettingMqttState();
}


class _SettingMqttState extends State<SettingMqtt> {

  final formKey = GlobalKey<FormState>();
  String _routeMsg;

  @override
  void initState() {
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
                      labelText: "Change message route",
                    ),
                    validator: (input) =>
                        input.contains('@') ? 'Bad character' : null,
                      onSaved: (input) => this._routeMsg = input,
                  ),
          ),
          Center(
            child: RaisedButton(
              child: Icon(Icons.send),
              onPressed: () {
                updateMsgRoute(_routeMsg);
              }
            ),
          ),
        ],
      ),
      key: formKey,
    );
  }

  void updateMsgRoute(String newRoute){
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    databaseReference.child("mqtt").update({
      'message': newRoute,
    });
  }

  void updateWeatherRoute(String newRoute){
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    databaseReference.child("mqtt").update({
      'weather': newRoute,
    });
  }

  void updateYtUsernameRoute(String newRoute){
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    databaseReference.child("mqtt").update({
      'ytusername': newRoute,
    });
  }

  void updateYtChannelIdRoute(String newRoute){
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
    }
    databaseReference.child("mqtt").update({
      'ytchannelid': newRoute,
    });
  }
}

void getRouteMsg(){
  databaseReference.once().then((DataSnapshot snapshot) {
    print('Data : ${snapshot.value}');
  });
}