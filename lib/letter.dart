import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class Letter extends StatefulWidget {
  const Letter({super.key, required this.focusDay, required this.uid});
  final focusDay, uid;

  @override
  State<Letter> createState() => _LetterState();
}

class _LetterState extends State<Letter> {
  final letterController = TextEditingController();
  String today = DateFormat('MM-dd').format(DateTime.now());

  // 내용 데이터베이스에 저장
  addLetter() {
    try {
      String inputText = letterController.text.toString();
      firestore.collection('data').doc(widget.uid).collection('letter').add({
        'content': inputText,
        'date': Timestamp.now(),
        'targetDate': widget.focusDay
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.grey[400],
        elevation: 0.0,
        title: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "daylog",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 24.0,
                fontFamily: 'PlayfairDisplay'),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(55, 20, 55, 40),
          decoration: BoxDecoration(color: Colors.grey[400]),
          child: Column(
            children: [
              Text(
                "미래의 나에게 편지를 보내보세요.",
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                    fontFamily: 'NotoSerif'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat(
                      'MM월 dd일',
                    ).format(widget.focusDay),
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                        fontFamily: 'NotoSerif'),
                  ),
                  Text(
                    "의 당신에게 편지가 전송됩니다.",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                        fontFamily: 'NotoSerif'),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: TextField(
                  controller: letterController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 26,
                  style: TextStyle(fontFamily: 'Skudy', color: Colors.black54),
                  decoration: InputDecoration(
                      hintText: "편지의 내용을 작성해주세요.",
                      hintStyle: TextStyle(color: Colors.black26),
                      contentPadding: EdgeInsets.all(24),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey))),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextButton(
                  onPressed: () {
                    String inputText = letterController.text.toString();
                    if (inputText.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Container(
                              child: Text(
                                "편지를 전송하시겠습니까?",
                                style: TextStyle(
                                    fontFamily: 'NotoSerif',
                                    color: Color.fromARGB(255, 146, 146, 146)),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    addLetter();
                                    Navigator.of(context).pop();
                                    Get.back();
                                  },
                                  child: const Text(
                                    "예",
                                    style: TextStyle(
                                        fontFamily: 'NotoSerif',
                                        color:
                                            Color.fromARGB(255, 146, 146, 146)),
                                  )),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "아니오",
                                    style: TextStyle(
                                        fontFamily: 'NotoSerif',
                                        color:
                                            Color.fromARGB(255, 146, 146, 146)),
                                  ))
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                child: Text(
                                  "편지를 작성해주세요.",
                                  style: TextStyle(
                                      fontFamily: 'NotoSerif',
                                      color:
                                          Color.fromARGB(255, 146, 146, 146)),
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "확인",
                                      style: TextStyle(
                                          fontFamily: 'NotoSerif',
                                          color:
                                              Color.fromARGB(255, 89, 89, 89)),
                                    )),
                              ],
                            );
                          });
                    }
                  },
                  child: Text(
                    "전송하기",
                    style: TextStyle(
                        fontFamily: 'NotoSerif',
                        color: Colors.black54,
                        fontSize: 16.0),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
