import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class Upload extends StatefulWidget {
  const Upload({super.key, required this.uid, required this.focusDay});
  final uid, focusDay;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final boardController = TextEditingController();
  final titleController = TextEditingController();
  String today = DateFormat('MM-dd').format(DateTime.now());
  Color pickColor = Color(0xff7B8FA1);
  int formatColor = 4286156448;

  // 내용 추가
  addContent() {
    try {
      String inputText = boardController.text.toString();
      String inputTitle = titleController.text.toString();
      firestore.collection('data').doc(widget.uid).collection('userData').add({
        'title': inputTitle,
        'content': inputText,
        'date': widget.focusDay,
        'color': formatColor
      });
    } catch (e) {
      print(e);
    }
  }

  // color picker
  Widget buildColorPicker() => ColorPicker(
        pickerColor: pickColor,
        enableAlpha: false,
        showLabel: false,
        onColorChanged: (value) {
          pickColor = value;
          formatColor = pickColor.value;
          print(pickColor.toString());
          setState(() {});
        },
      );

  void showColor(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "오늘의 색을 선택해주세요.",
              style: TextStyle(
                  fontFamily: 'Skudy',
                  fontSize: 18.0,
                  color: Color.fromARGB(255, 94, 94, 94)),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildColorPicker(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("선택"))
              ],
            ),
          );
        },
      );

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
            )),
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.fromLTRB(40, 20, 40, 40),
            decoration: BoxDecoration(color: Colors.grey[400]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "오늘도 수고한 나에게, 편지를 작성해주세요.",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black54,
                      fontFamily: 'NotoSerif'),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MM-dd').format(widget.focusDay),
                      style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Lora',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0),
                    ),
                    Row(
                      children: [
                        Text(
                          "오늘의 색",
                          style: TextStyle(
                              fontFamily: 'NotoSerif',
                              color: Colors.black54,
                              fontSize: 11.0),
                        ),
                        IconButton(
                            onPressed: (() {
                              showColor(context);
                            }),
                            icon: Icon(
                              Icons.circle,
                              size: 18.0,
                              color: pickColor,
                            )),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: TextField(
                    controller: titleController,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style:
                        TextStyle(fontFamily: 'Skudy', color: Colors.black54),
                    decoration: InputDecoration(
                        hintText: "편지의 제목을 알려주세요.",
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
                  height: 10,
                ),
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: TextField(
                      controller: boardController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 22,
                      style:
                          TextStyle(fontFamily: 'Skudy', color: Colors.black54),
                      decoration: InputDecoration(
                          hintText: "편지의 내용을 작성해주세요.",
                          hintStyle: TextStyle(color: Colors.black26),
                          contentPadding: EdgeInsets.all(24),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey))),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        String text = boardController.text.trim().toString();
                        String title = titleController.text.trim().toString();
                        if (title.isNotEmpty && text.isNotEmpty) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const SingleChildScrollView(
                                    child: Text(
                                      "편지를 전송하시겠습니까?",
                                      style: TextStyle(
                                          fontFamily: 'NotoSerif',
                                          color: Color.fromARGB(
                                              255, 146, 146, 146)),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          addContent();
                                          Navigator.of(context).pop();
                                          Get.back();
                                        },
                                        child: const Text(
                                          "예",
                                          style: TextStyle(
                                              fontFamily: 'NotoSerif',
                                              color: Color.fromARGB(
                                                  255, 146, 146, 146)),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "아니오",
                                          style: TextStyle(
                                              fontFamily: 'NotoSerif',
                                              color: Color.fromARGB(
                                                  255, 146, 146, 146)),
                                        ))
                                  ],
                                );
                              });
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
                                          color: Color.fromARGB(
                                              255, 146, 146, 146)),
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
                                              color: Color.fromARGB(
                                                  255, 89, 89, 89)),
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
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
