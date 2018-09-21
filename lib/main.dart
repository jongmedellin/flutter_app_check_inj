import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:simple_sms/simple_sms.dart';
import 'package:sms/sms.dart';
import 'member.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;
  double Clat = 0.00;
  double Clog = 0.00;
  String Floc = '';

  SmsSender sender = new SmsSender();

  final SimpleSms simpleSms = SimpleSms();

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  Image image1;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;

    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    widgets = new List();

    if (_currentLocation == null) {
      widgets = new List();
    } else {
      widgets = [
        new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=${_currentLocation["latitude"]},${_currentLocation["longitude"]}&zoom=18&size=640x400&key=AIzaSyCKt3OsyLmsQPye3qPhjisz7BUL93Q6TyE")
    //https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap

      ];

    }

    widgets.add(new Center(
        child: new Text(_startLocation != null
            ? 'Start location: $_startLocation\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(_currentLocation != null
            ? 'Continuous location: $_currentLocation\n'
            : 'Error: $error\n')));

    widgets.add(new Center(
        child: new Text(
            _permission ? 'Has permission : Yes' : "Has permission : No")));

    new SizedBox(height: 5.00,);
    
    widgets.add(
      new Column(
        children: <Widget>[
          new SizedBox(height: 5.00,),
          new Center(
            child: (RaisedButton(
              onPressed: onUp,child: Text('Check In'),
            )),
          ),
          new SizedBox(height: 5.00,),
          new Center(
            child: Text('$Clat,$Clog'),
          ),

        ],
      )
    );
    new SizedBox(height: 5.00,);
    



    widgets.add(new Container(
      child: Text('OK'),
    ),
      
    
    );

    new SizedBox(
      height: 5.00,
    );

    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        title: new Text('Location plugin example app'),
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: widgets,
      ),
    ));
  }

  void onUp() {
    Clat = (_currentLocation['latitude']);
    Clog = (_currentLocation['longitude']);
    Floc = 'http://maps.google.com/maps?z=18&q=$Clat,$Clog';

    //'https://www.google.com/maps/@$Clat,$Clog,20z';//'$Clat,$Clog';
    //simpleSms.sendSms(['09088744960','09778143699'],Floc );
    sender.sendSms(new SmsMessage('09778143699', Floc));
    print(Floc);
    setState(() {});
  }
}
