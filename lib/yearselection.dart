import 'package:flutter/material.dart';

import 'package:cloud_mobile/dashboard.dart';

class YearSelection extends StatelessWidget {
  final String username;
  final String password;

  //const YearSelection({super.key});
  const YearSelection(
      {super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Year Selection'),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(10)),
          SizedBox(
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
                // Navigate back to first route when tapped.
              },
              child: const Text(
                'Select Year',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Text(this.username),
          Text(this.password),
        ],
      )),
    );
  }
}
