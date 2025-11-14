import 'dart:convert';
import 'package:flutter/material.dart';
import 'common/global.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_mobile/common/alert.dart';
import 'package:cloud_mobile/common/global.dart';
import 'package:cloud_mobile/yearselection.dart';
import 'package:cloud_mobile/common/eqappbar.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Equal On Mobile';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: /*SplashScreen(
          seconds: 5,
          navigateAfterSeconds: new MyHomePage(),
          backgroundColor: Colors.yellow,
          title: new Text(
            'Flutter Javatpoint',
            textScaleFactor: 2,
          ),
          image: new Image.network(
              'https://static.javatpoint.com/tutorial/flutter/images/flutter-creating-android-platform-specific-code3.png'),
          loadingText: Text("Loading"),
          photoSize: 150.0,
          loaderColor: Colors.red,
        )*/
          Scaffold(
        appBar: EqAppBar(
          AppBarTitle: _title,
          // title: Text(_title,
          //     style: TextStyle(
          //         fontSize: 25.0, fontWeight: FontWeight.normal))
        ),
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
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final dbController = TextEditingController();

  String _username = '';
  String _password = '';
  String _db = '';
  // bool _load = false;

  @override
  void initState() {
    super.initState();
    getDbDetails();
  }

  @override
  Widget build(BuildContext context) {
    // Widget loadingIndicator = _load
    //     ? new Container(
    //         color: Colors.grey[300],
    //         width: 70.0,
    //         height: 70.0,
    //         child: new Padding(
    //             padding: const EdgeInsets.all(5.0),
    //             child: new Center(child: new CircularProgressIndicator())),
    //       )
    //     : new Container();
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Equal',
                  style: TextStyle(
                      fontFamily: 'verdana',
                      fontSize:
                          20) /*TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold)*/
                  ,
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                controller: nameController,
                style: TextStyle(
                  fontFamily: 'verdana',
                ),
                //style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'verdana',
                    )),
                onChanged: (value) {
                  nameController.value = TextEditingValue(
                      text: value.toUpperCase(),
                      selection: nameController.selection);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                style: TextStyle(
                  fontFamily: 'verdana',
                ),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.lightGreen),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(0),
                      ))),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'verdana',
                    ),
                  ),
                  onPressed: () {
                    _username = nameController.text;
                    _password = passwordController.text;
                    _db = dbController.text;

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

                    if (_db == '') {
                      alert(context, 'Validation error!!!',
                          'DB Can Not Be Blank !!');
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
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                autofocus: true,
                controller: dbController,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'verdana',
                ),
                //style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: 'DB',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'verdana',
                    )),
              ),
            ),
          ],
        ));
  }

  void getDbDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _db = prefs.getString('cloud_db').toString();
    _username = prefs.getString('cloud_username').toString();
    _password = prefs.getString('cloud_password').toString();

    //dbController = TextEditingController(text: _db);
    setState(() {
      //showAlertDialog(context, _username);
      if ((_username != '') && (_username != 'null')) {
        nameController.text = _username;
        passwordController.text = _password;
      }
      dbController.text = _db;
    });
    //alert(context, _db, _db);
  }

  void executelogin(context) async {
    DialogBuilder(context).showLoadingIndicator('');

    var api =
        "${globals.cdomain2}/api/api_authuser?dbname=$_db&username=$_username&password=$_password";

    print(api);
    //cdomain2

    // alert(
    //     context,
    //     'https://www.cloud.equalsoftlink.com/api/api_authuser?dbname=admin_sarika1&username=' +
    //         _username +
    //         '&password=' +
    //         _password,
    //     '');

    var response = await http.get(Uri.parse(api));

    ///print(response);

    var parsedJson = jsonDecode(response.body);

    if (!parsedJson['Success']) {
      // _load = false;
      DialogBuilder(context).hideOpenDialog();
      alert(context, 'Validation error!!!', 'In-Valid Login !!!');
    } else {
      // print('1');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // print('2');
      prefs.setString('cloud_db', _db);
      // print('3');
      prefs.setString('cloud_username', _username);
      // print('4');
      prefs.setString('cloud_password', _password);
      // print('5');
      globals.dbname = _db;
      globals.username = _username;

      // _load = false;
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
}
