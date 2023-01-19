import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'main.dart';
import 'post_box.dart';

class MyPage extends StatefulWidget {
  const MyPage(
      {super.key,
      required this.uid,
      required this.focusDay,
      required this.afterOneDay});
  final uid, focusDay, afterOneDay;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var myData;
  var formatDate;
  var pickedColor;
  var userData;
  var dataList;

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
        decoration: BoxDecoration(
          color: Colors.grey[400],
        ),
        child: Column(
          children: [
            Text(
              "당신이 전송한 소중한 편지를 모아두었어요.",
              style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontFamily: 'NotoSerif'),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 600,
              child: StreamBuilder(
                stream: firestore
                    .collection('data')
                    .doc(widget.uid)
                    .collection('userData')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  userData = firestore
                      .collection('data')
                      .doc(widget.uid)
                      .collection('userData');

                  myData = snapshot.data?.docs;

                  if (userData != null) {
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: myData.length,
                          itemBuilder: (context, index) {
                            void getData() {
                              var createdDate = myData[index]['date'].toDate();
                              formatDate =
                                  DateFormat('MM/dd').format(createdDate);

                              pickedColor = Color(int.parse(
                                  myData[index]['color'].toString(),
                                  radix: 16));
                            }

                            getData();

                            return Container(
                              height: 36,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: pickedColor,
                                        size: 14.0,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formatDate,
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontFamily: 'Lora',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  Text(
                                    myData[index]['content'],
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Skudy'),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
