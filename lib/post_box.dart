import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class PostBox extends StatefulWidget {
  const PostBox({super.key});

  @override
  State<PostBox> createState() => _PostBoxState();
}

class _PostBoxState extends State<PostBox> {
  final boardController = TextEditingController();
  String today = DateFormat('MM-dd').format(DateTime.now());
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
            TextButton(
                onPressed: () async {
                  // 날짜 선택
                  DateTime? newDate = await showDatePicker(
                      builder: (context, child) {
                        return Theme(
                          child: child!,
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                                primary: Color.fromARGB(255, 168, 168, 168)),
                          ),
                        );
                      },
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023, 1, 1),
                      lastDate: DateTime(2023, 12, 31));

                  if (newDate == null) return;
                  targetDate = newDate;
                  setState(() {});
                },
                child: Text("전송할 날짜 선택"))
          ],
        ),
      ),
    );
  }
}
