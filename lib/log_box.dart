import 'main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LogBox extends StatefulWidget {
  const LogBox({super.key});

  @override
  State<LogBox> createState() => _LogBoxState();
}

class _LogBoxState extends State<LogBox> {
  late QuerySnapshot<Map<String, dynamic>> logData;

  String logColor = '';

  getLogs() async {
    logData = await firestore
        .collection('data')
        .orderBy('date', descending: true)
        .get();
  }

  getColor(index) {
    logColor = logData.docs[index].data()['color'];
  }

  @override
  Widget build(BuildContext context) {
    getLogs();

    return Container(
      height: 300,
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 8),
          itemCount: 8,
          itemBuilder: ((context, index) {
            if (logData.docs[index].data()['content'] != null) {
              getColor(index);
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: Colors.blueGrey),
              );
            } else {
              return Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: Colors.grey[50]),
              );
            }
          })),
    );
  }
}
