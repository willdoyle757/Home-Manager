import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({Key? key}) : super(key: key);

  @override
  State<settingsPage> createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Settings',
          style: TextStyle(
            color: Colors.white
          ),
        )
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'Home Code: {}'
            )
          )
        ],
      ),
    );
  }
}
