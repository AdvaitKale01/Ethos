import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethos Plane Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isIPChange = false;
  String tempIP;
  String _ip = '192.168.29.181';
  String _status = 'Toggle to get status';
  String rightMotorStatus = '--', leftMotorStatus = '--';
  String rangeStatus = 'In Range';
  @override
  void initState() {
    if (_ip == null) {
      _ip = '192.168.29.181';
    }
    super.initState();
  }

  sendResponse(String responseURL) async {
    try {
      if (_ip != null) {
        var url = 'http://$_ip/$responseURL';
        var response = await http.post(url);
        if (response.statusCode == 200) {
          print('Response status: ${response.statusCode} - Request Sent');

          print('Response body: ${response.body}');
          // setState(() {});
          _status =
              'Response status: ${response.statusCode} - Request Sent\nResponse body: ${response.body}\nResponse Status:\nleft motor $leftMotorStatus\nright motor $rightMotorStatus';
          if (responseURL == 'toggleBothMotor') {
            leftMotorStatus = response.body;
            rightMotorStatus = response.body;
            print('both text set');
          } else if (responseURL == 'toggleLeftMotor') {
            leftMotorStatus = response.body;
            print('left text set');
          } else if (responseURL == 'toggleRightMotor') {
            rightMotorStatus = response.body;
            print('right text set');
          }
          setState(() {});
        } else {
          setState(() {});
          _status =
              'Could not get Response. Possible issues:\n1. NodeMCU Power Down\nSol: Turn on Power of NodeMCU and Press Reset pin\n2. NodeMCU Not connected to WIFI\nSol: Re-start NodeMCU and press Hard Reset pin\n3. IP Address of NodeMCU is changed\nSol: Change the IP Address and add correct IP for NodeMCU';
        }
      } else {
        _status = 'IP Address is Empty!';
      }
    } catch (err) {
      setState(() {});
      _status =
          'Could not get Response. Possible issues:\n1. NodeMCU Power Down\nSol: Turn on Power of NodeMCU and Press Reset pin\n2. NodeMCU Not connected to WIFI\nSol: Re-start NodeMCU and press Hard Reset pin\n3. IP Address of NodeMCU is changed\nSol: Change the IP Address and add correct IP for NodeMCU\n\nDetails-\n$err';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Fetching IP - $_ip',
            style: TextStyle(color: Colors.blueAccent),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.blueAccent,
              ),
              onPressed: () {
                setState(() {
                  isIPChange = !isIPChange;
                });
              },
            )
          ],
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Column(
//              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isIPChange)
                  TextField(
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(30.0),
                        ),
                      ),
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: "Enter IP of NodeMCU (see COM Output)",
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _ip = tempIP;
                            isIPChange = false;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      tempIP = value;
                    },
                  )
                else
                  Container(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Text(
                              'Toggle Both Motors',
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            child: Text('Toggle'),
                            onPressed: () async {
                              await sendResponse('toggleBothMotor');
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            "Left Motor",
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            "$leftMotorStatus",
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Text(
                            'Toggle Left Motor',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          child: Text('Toggle'),
                          onPressed: () async {
                            await sendResponse('toggleLeftMotor');
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Right Motor",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "$leftMotorStatus",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Text(
                            'Toggle Right Motor',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          child: Text('Toggle'),
                          onPressed: () async {
                            await sendResponse('toggleRightMotor');
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "Range Status",
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          "$rangeStatus",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Color(0xff333333),
                      ),
                      color: Color(0xff333333),
                    ),
                    child: AutoSizeText(
                      '$_status',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      maxLines: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
