import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class PostBox extends StatefulWidget {
  const PostBox({super.key, required this.focusDay});

  final focusDay;

  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  final boardController = TextEditingController();
  String today = DateFormat('MM-dd').format(DateTime.now());
  DateTime afterOneDay = DateTime.now().subtract(Duration(days: 1));
  late DateTime targetDate;

  // 내용 추가
  addContent() {
    try {
      String inputText = boardController.text.toString();
      firestore.collection('letter').add({
        'content': inputText,
        'date': Timestamp.now(),
        'targetDate': targetDate
      });
    } catch (e) {
      print(e);
    }
  }

  // // 편지 데이터 저장
  // addLetter() {
  //   try {
  //     String inputText = boardController.text.toString();
  //   }
  // }

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
      body: Container(
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
            Text(
              "설정한 날짜로 편지가 전송됩니다.",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontFamily: 'NotoSerif'),
            ),
            Container(
              width: double.infinity,
              child: TextField(
                controller: boardController,
                keyboardType: TextInputType.multiline,
                maxLines: 18,
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
            TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [Text("진짜 보낸당~~")],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: () {}, child: Text("확인")),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("취소"))
                        ],
                      );
                    },
                  );
                },
                child: Text("전송하기"))
          ],
        ),
      ),
    );
  }
}
