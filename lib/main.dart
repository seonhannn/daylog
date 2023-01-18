import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'my_page.dart';
import 'calendar.dart';
import 'upload.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;

// google 로그인
Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeDateFormatting().then(
    (value) {
      runApp(GetMaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
        initialBinding: BindingsBuilder(() {}),
      ));
    },
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var dataList;
  late DateTime createdDate;
  String formatDate = '';
  Color dayColor = Colors.black54;
  var focusDay = DateTime.now();
  var focusFormatDay;
  var afterOneDay;
  var pickedColor;
  late String uid;
  var userData;
  var userList;
  late StreamSubscription<User?> userCheck;
  bool _loginMode = true;

  // user id 가져오기
  void getUserId() {
    final User? user = auth.currentUser;
    uid = user!.uid;
    // here you write the codes to input the data into firestore
    print(uid);
    print("내놔");
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    userCheck = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // 이미 로그인
        _loginMode = false;
      } else {
        // 로그인 필요
        _loginMode = true;
      }
      setState(() {});
      userCheck.cancel();
    });
  }

  // 캘린더에서 선택한 날짜 가져오기
  getFocusedDay(day) {
    focusDay = day;
    afterOneDay = focusDay.add(Duration(days: 1));
    setState(() {});
  }

  // 선택한 날짜 format
  formatFocusedDate() {
    focusFormatDay = DateFormat('MM/dd').format(focusDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.white,
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        if (_loginMode == true) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content:
                                    Container(child: Text("로그인이 필요한 기능입니다.")),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("확인"))
                                ],
                              );
                            },
                          );
                        } else {
                          Get.to(MyPage(
                              uid: uid,
                              focusDay: focusDay,
                              afterOneDay: afterOneDay));
                        }
                      },
                      icon: Icon(
                        Icons.mail,
                        color: Colors.black54,
                      )),
                  IconButton(
                      onPressed: () {
                        if (_loginMode == true) {
                          // kakaoLogin();
                          signInWithGoogle();
                          getUserId();
                          setState(() {});
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text("로그아웃 하시겠습니까?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        GoogleSignIn().signOut();
                                        _loginMode = true;
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("예")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("아니오"))
                                ],
                              );
                            },
                          );
                        }
                      },
                      icon: Icon(
                        Icons.account_circle_rounded,
                        color: Colors.black54,
                      )),
                ],
              ),
            )
          ],
        ),
        resizeToAvoidBottomInset: false, // 키보드 render 에러 잡아줌
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.fromLTRB(55, 20, 55, 40),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Calendar(getFocusedDay: getFocusedDay),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: firestore
                      .collection('data')
                      .doc(uid)
                      .collection('userData')
                      .where("date",
                          isGreaterThan: focusDay, isLessThan: afterOneDay)
                      .orderBy('date', descending: true) // 날짜 최신순
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    userData = firestore
                        .collection('data')
                        .doc(uid)
                        .collection('userData');

                    dataList = snapshot.data?.docs;

                    if (userData != null) {
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                              child: ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              void getData() {
                                createdDate = dataList[index]['date'].toDate();
                                formatDate =
                                    DateFormat('MM/dd').format(createdDate);

                                pickedColor = Color(dataList[index]['color'])
                                    .withOpacity(0.4);
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
                                        Row(
                                          children: [
                                            Text(
                                              formatDate,
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: 'Lora',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            formatDate,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'NotoSerif',
                                                                color: Colors
                                                                    .grey[400],
                                                                fontSize: 12.0),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          Text(
                                                            "의 편지",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey[400],
                                                                fontFamily:
                                                                    'NotoSerif',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 14.0),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        dataList[index]
                                                            ['title'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'NotoSerif',
                                                            fontSize: 14.0,
                                                            color: Colors
                                                                .grey[500]),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        dataList[index]
                                                            ['content'],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'NotoSerif',
                                                            fontSize: 14.0,
                                                            color: Colors
                                                                .grey[600]),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "확인",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'NotoSerif',
                                                                fontSize: 14.0,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        177,
                                                                        177,
                                                                        177)),
                                                          ))
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            dataList[index]['title'],
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Skudy'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.circle,
                                      color: pickedColor,
                                      size: 14.0,
                                    )
                                  ],
                                ),
                              );
                            },
                          ))
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                    Get.to(Upload(uid: uid));
                  },
                  child: Text(
                    "기록하기",
                    style: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        fontFamily: 'NotoSerif'),
                  ))
            ],
          ),
        ));
  }
}
