import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Groupdelivery_model.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';

import '../notification.dart';
import '../viewmodel/groupdelivery_viewmodel.dart';

class GroupDelivery extends StatefulWidget {
  @override
  _GroupDeliveryState createState() => _GroupDeliveryState();
}

class _GroupDeliveryState extends State<GroupDelivery> {
  List<GroupDeliveryModel> GroupDeliverys = [];
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUserEmail();
    _loadGroupDeliverys();
  }

  Future<void> _loadGroupDeliverys() async {
    try {
      var fetchedGroupDeliverys = await fetchGroupDeliverys();
      setState(() {
        GroupDeliverys = fetchedGroupDeliverys;
      });
    } catch (e) {
      print('Error fetching group buyings: $e');
    }
  }

  Future<void> _loadCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('email') ?? '';
    });
  }

  final _formKey = GlobalKey<FormState>();
  String email = '';
  String title = '';
  String content = '';
  String image = 'tmp';
  int member = 0;
  DateTime duetime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpeg'), // 이미지 경로 설정
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              CustomAppBar(), // 사용자 정의 앱 바
              Expanded(
                // 스크롤 가능한 리스트 뷰
                child: ListView.builder(
                  itemCount: GroupDeliverys.length, // 생성할 카드의 수 (실제 데이터로 조정하세요)
                  itemBuilder: (context, index) {
                    return _buildGroupDeliveryCard(index);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20), // 하단에 패딩 추가
        child: FloatingActionButton.extended(
          onPressed: () => _showPostModal(context), // 모달 띄우기
          icon: Icon(Icons.create, size: 16, color: Colors.black), // 아이콘 크기 조절
          label: Text('글쓰기', style: TextStyle(color: Colors.black, fontSize: 14)), // 텍스트 크기 조절
          backgroundColor: Colors.white, // 버튼 배경 색상 변경
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)), // 더 둥근 모서리
          ),
          elevation: 4, // 띄워진 느낌을 위한 그림자
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget? _buildGroupDeliveryCard(int index) {
    if (index < GroupDeliverys.length) {
      GroupDeliveryModel GroupDelivery = GroupDeliverys[index];
      // GroupDeliverypost 작성자가 본인이며 신청하기 대신 삭제하기로 변경
      Widget actionButton;

      if (GroupDelivery.email == currentUserEmail) {
        actionButton = ElevatedButton(
          onPressed: () async {
            try {
              await deleteGroupDelivery(GroupDelivery.id);
              // 성공적으로 삭제 후 UI 업데이트
              setState(() {
                GroupDeliverys.removeWhere((item) => item.id == GroupDelivery.id); // ID를 기준으로 항목 제거
              });
              _loadGroupDeliverys();
            } catch (e) {
              // 오류 처리
              print('Error deleting group buying: $e');
            }
          },
          child: const Text(
            '삭제하기',
            style: TextStyle(
              color: Colors.red, // 빨간색으로 변경
              fontSize: 14, // 원하는 글자 크기로 조절
              // fontWeight: FontWeight.bold, // 원하는 폰트 두께로 조절
            ),
          ),
        );
      } else {
        DateTime dueTime = GroupDelivery.duetime;
        DateTime now = DateTime.now();

        // 기간 마감 여부 확인
        bool isDeadlinePassed = dueTime.isBefore(now);

        String buttonText = isDeadlinePassed ? '기간마감' : (GroupDelivery.member > 0 ? '신청하기' : '모집완료');
        TextStyle buttonStyle = TextStyle(
          fontSize: 14,
          color: isDeadlinePassed ? Colors.white : null,
          fontWeight: isDeadlinePassed ? FontWeight.bold : FontWeight.normal,
        );
        bool isButtonEnabled = GroupDelivery.member > 0 && !isDeadlinePassed;


        actionButton = ElevatedButton(
          onPressed: isButtonEnabled ? () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (GroupDelivery.member == 1) {
              FlutterLocalNotification.showDeliveryNotification();
            }
            setState(() {
              GroupDelivery.member -= 1;
            });
            await updateGroupDelivery(GroupDelivery);

            // 신청 후 알림 표시
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('알림'),
                  content: Text('신청되었습니다'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('확인'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } : null,
          child: Text(buttonText, style: buttonStyle),
        );
      }


      return Container(
        height: 160, // Card의 높이를 조절하려면 height 값을 조정하세요
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.5)
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: <Widget>[
              Expanded(
                // 카드의 좌측 섹션: 이미지, 제목, 내용
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.lunch_dining, // 음식 아이콘
                          size: 60, // 아이콘 크기 조절
                          color: Colors.black, // 아이콘 색상 조절
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${GroupDelivery.title}',
                                style: TextStyle(
                                fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                color: Colors.black,
                                ),
                            ),
                            SizedBox(height: 8),
                            Text('${GroupDelivery.content}',
                                style: TextStyle(fontSize: 16, color: Colors.black)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    // Image.network(
                    //   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwPo0rstrV0xYw_ej43GNHALxIKhBIp4yD8Q&usqp=CAU',
                    //   // 실제 이미지 URL로 변경
                    //   height: 80,
                    //   width: 80,
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              // 카드의 우측 섹션: 남은 인원, 신청하기 버튼
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('남은 인원: ${GroupDelivery.member}명'),
                  SizedBox(height: 8),
                  Text(
                    '${DateFormat('마감시간: ').format(GroupDelivery.duetime)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.end, // 왼쪽 정렬
                  ),
                  SizedBox(height: 3,),
                  Text('${DateFormat('yyyy.M.d HH시 mm분').format(GroupDelivery.duetime)}'),
                  SizedBox(height: 8),
                  actionButton,
                ],
              ),
            ],
          ),
        )
        // margin: EdgeInsets.all(10),
        // child: Padding(
        //   padding: EdgeInsets.all(8),
          // child: Row(
          //   children: <Widget>[
          //     Expanded(
          //       // 카드의 좌측 섹션: 이미지, 제목, 내용
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: <Widget>[
          //           Text('${GroupDelivery.title}', style: TextStyle(
          //               fontWeight: FontWeight.bold, fontSize: 18)),
          //           SizedBox(height: 8),
          //           Text('${GroupDelivery.content}', style: TextStyle(fontSize: 16)),
          //           SizedBox(height: 8),
          //           Image.network(
          //             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwPo0rstrV0xYw_ej43GNHALxIKhBIp4yD8Q&usqp=CAU',
          //             // 실제 이미지 URL로 변경
          //             height: 80,
          //             width: 80,
          //             fit: BoxFit.cover,
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(width: 8),
          //     // 카드의 우측 섹션: 남은 인원, 신청하기 버튼
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.end,
          //       children: <Widget>[
          //         Text('남은 인원: ${GroupDelivery.member}명'),
          //         SizedBox(height: 8),
          //         Text('마감 시간: ${DateFormat('yyyy년 M월 d일').format(GroupDelivery.duetime)}'),
          //         SizedBox(height: 8),
          //         Text('${DateFormat('HH시 mm분').format(GroupDelivery.duetime)}'),
          //         SizedBox(height: 8),
          //         actionButton,
          //       ],
          //     ),
          //   ],
          // ),
        // ),
      );
    }
  }
  void _showCupertinoTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 220,
          child: Column(
            children: <Widget>[
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: duetime,
                  onDateTimeChanged: (DateTime newTime) {
                    duetime = newTime; // 임시로 시간 업데이트
                  },
                ),
              ),
              CupertinoButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 시간 선택기 닫기
                  setState(() {
                    // 상태 업데이트하여 화면 재구성
                  });
                  _showSelectedTimeAlert(context); // 선택된 시간 알림 표시
                },
              ),
              SizedBox(height: 8.0), // 여백 추가
            ],
          ),
        );
      },
    );
  }
  void _showSelectedTimeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${DateFormat('HH:mm').format(duetime)}이 선택되었습니다.'),
                SizedBox(height: 16),
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ),
        );
      },
    );
  }

  void _showPostModal(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '글 작성하기',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 0),
              ],
            ),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (val) => title = val!,
                      decoration: const InputDecoration(
                        labelText: '제목',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      onSaved: (val) => content = val!,
                      decoration: const InputDecoration(
                        hintText: '내용을 입력해주세요',
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      onSaved: (val) => member = int.tryParse(val ?? '0') ?? 0,
                      decoration: const InputDecoration(
                        labelText: '참여 인원',
                        labelStyle: TextStyle(
                          fontSize: 12, // 원하는 글자 크기로 조절
                          color: Colors.black, // 원하는 색상으로 조절
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => _showCupertinoTimePicker(context),
                      child: Text('시간 선택'),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('작성하기'),
                onPressed: ()  async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    email = prefs.getString('email') ?? '기본값';


                    // GroupDeliveryModel 객체 생성
                    GroupDeliveryModel newGroupDelivery = GroupDeliveryModel(
                      id: -1, // ID는 서버에서 자동으로 할당될 수 있습니다.
                      email: email,
                      title: title,
                      content: content,
                      image: image,
                      member: member,
                      duetime: duetime,
                    );

                    // 서버에 데이터 추가
                    try {
                      await addGroupDelivery(newGroupDelivery);
                      // 성공 메시지 또는 후속 처리
                    } catch (e) {
                      // 에러 처리
                      print(e);
                    }
                  }
                  Navigator.pop(context);
                  _loadGroupDeliverys();
                },
              ),
            ],
          );
        },
      );
  }
}