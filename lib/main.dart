import 'dart:convert';

import 'package:cloud_mobile/yearselection.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:cloud_mobile/common/global.dart';

import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:cloud_mobile/common/alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Equal On Mobile';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: Scaffold(
        appBar:
            AppBar(title: const Text(_title, style: TextStyle(fontSize: 25))),
        body: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String _username = '';
  String _password = '';
  bool _load = false;

  void executelogin(context) async {
    DialogBuilder(context).showLoadingIndicator('');

    var url = Uri.parse(
        'https://www.cloud.equalsoftlink.com/api/api_authuser?dbname=admin_sarika1&username=' +
            _username +
            '&password=' +
            _password);
    print(url);

    http.Response response = await http.get(url);

    ///print(response);

    var parsedJson = jsonDecode(response.body);
    if (!parsedJson['Success']) {
      _load = false;
      DialogBuilder(context).hideOpenDialog();
      alert(context, 'Validation error!!!', 'In-Valid Login !!!');
    } else {
      _load = false;
      DialogBuilder(context).hideOpenDialog();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => YearSelection(user: _username, pwd: _password)));

      /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                YearSelection(username: _username, password: _password)),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = _load
        ? new Container(
            color: Colors.grey[300],
            width: 70.0,
            height: 70.0,
            child: new Padding(
                padding: const EdgeInsets.all(5.0),
                child: new Center(child: new CircularProgressIndicator())),
          )
        : new Container();
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Equal',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                controller: passwordController,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                child: ElevatedButton(
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _username = nameController.text;
                    _password = passwordController.text;

                    if (_username == '') {
                      alert(context, 'Validation error!!!',
                          'User Can Not Be Blank !!!');
                      return;
                    }

                    if (_password == '') {
                      alert(context, 'Validation error!!!',
                          'Password Can Not Be Blank !!');
                      return;
                    }

                    executelogin(context);
                    //print(nameController.text);
                    //print(passwordController.text);

                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => YearSelection(
                              username: _username, password: _password)),
                    );*/
                  },
                )),
          ],
        ));
  }
}
