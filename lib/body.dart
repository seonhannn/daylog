// Container(
//           width: double.infinity,
//           height: double.infinity,
//           padding: EdgeInsets.fromLTRB(55, 20, 55, 40),
//           decoration: BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Calendar(getFocusedDay: getFocusedDay),
//               SizedBox(
//                 height: 50,
//               ),
//               Expanded(
//                 child: StreamBuilder(
//                   stream: firestore
//                       .collection('data')
//                       .where("date",
//                           isGreaterThan: focuseDay, isLessThan: afterOneDay)
//                       .orderBy('date', descending: true) // 날짜 최신순
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return CircularProgressIndicator();
//                     }
//                     if (firestore.collection('data').doc() == uid) {
//                       print("user id 찾았당");
//                       print(snapshot.data?.docs);
//                     } else {}
//                     if (!snapshot.hasData) {
//                       return Container();
//                     } else {
//                       dataList = snapshot.data!.docs;
//                       return Column(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Expanded(
//                             child: ListView.builder(
//                               itemCount: dataList.length,
//                               itemBuilder: (context, index) {
//                                 void getData() {
//                                   createdDate =
//                                       dataList[index]['date'].toDate();
//                                   formatDate =
//                                       DateFormat('MM/dd').format(createdDate);

//                                   pickedColor = Color(dataList[index]['color'])
//                                       .withOpacity(0.4);

//                                   userList = dataList[index];
//                                 }

//                                 void checkUser() {
//                                   userList = dataList[index];
//                                   if (userList == uid) {
//                                     hasUser = true;
//                                   } else {
//                                     hasUser = false;
//                                   }
//                                 }

//                                 if ((dataList[index].data())
//                                     .containsKey('content')) {
//                                   getData();

//                                   return Container(
//                                     height: 36,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   formatDate,
//                                                   style: TextStyle(
//                                                       color: Colors.grey[400],
//                                                       fontFamily: 'Lora',
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                       fontSize: 14.0),
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               width: 40,
//                                             ),
//                                             GestureDetector(
//                                               onTap: () {
//                                                 showDialog(
//                                                   context: context,
//                                                   builder: (context) {
//                                                     return AlertDialog(
//                                                       content: Column(
//                                                         mainAxisSize:
//                                                             MainAxisSize.min,
//                                                         children: [
//                                                           Row(
//                                                             children: [
//                                                               Text(
//                                                                 formatDate,
//                                                                 style: TextStyle(
//                                                                     fontFamily:
//                                                                         'NotoSerif',
//                                                                     color: Colors
//                                                                             .grey[
//                                                                         400],
//                                                                     fontSize:
//                                                                         12.0),
//                                                               ),
//                                                               SizedBox(
//                                                                 width: 2,
//                                                               ),
//                                                               Text(
//                                                                 "의 편지",
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                             .grey[
//                                                                         400],
//                                                                     fontFamily:
//                                                                         'NotoSerif',
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w600,
//                                                                     fontSize:
//                                                                         14.0),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                           Text(
//                                                             dataList[index]
//                                                                 ['title'],
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'NotoSerif',
//                                                                 fontSize: 14.0,
//                                                                 color: Colors
//                                                                     .grey[500]),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 10,
//                                                           ),
//                                                           Text(
//                                                             dataList[index]
//                                                                 ['content'],
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'NotoSerif',
//                                                                 fontSize: 14.0,
//                                                                 color: Colors
//                                                                     .grey[600]),
//                                                           ),
//                                                           TextButton(
//                                                               onPressed: () {
//                                                                 Navigator.of(
//                                                                         context)
//                                                                     .pop();
//                                                               },
//                                                               child: Text(
//                                                                 "확인",
//                                                                 style: TextStyle(
//                                                                     fontFamily:
//                                                                         'NotoSerif',
//                                                                     fontSize:
//                                                                         14.0,
//                                                                     color: Color
//                                                                         .fromARGB(
//                                                                             255,
//                                                                             177,
//                                                                             177,
//                                                                             177)),
//                                                               ))
//                                                         ],
//                                                       ),
//                                                     );
//                                                   },
//                                                 );
//                                               },
//                                               child: Text(
//                                                 dataList[index]['title'],
//                                                 style: TextStyle(
//                                                     fontSize: 18.0,
//                                                     color: Colors.grey[500],
//                                                     fontWeight: FontWeight.w400,
//                                                     fontFamily: 'Skudy'),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Icon(
//                                           Icons.circle,
//                                           color: pickedColor,
//                                           size: 14.0,
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 } else {
//                                   return Container();
//                                 }
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           TextButton(
//                               onPressed: () {
//                                 Get.to(Upload());
//                               },
//                               child: Text(
//                                 "기록하기",
//                                 style: TextStyle(
//                                     color: Colors.grey[400],
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 16.0,
//                                     fontFamily: 'NotoSerif'),
//                               ))
//                         ],
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         )