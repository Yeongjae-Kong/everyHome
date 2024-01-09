import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Groupdelivery_model.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';

import '../viewmodel/Groupdelivery_viewmodel.dart';

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
      body: Column(
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
          child: Text('삭제하기', style: TextStyle(color: Colors.red),),
        );
      } else {
        actionButton = ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('applycheck', GroupDelivery.title);
            setState(() {
              if (GroupDelivery.member > 0) {
                GroupDelivery.member -= 1;
                prefs.setString('applycheck', GroupDelivery.title);
              }
            });
          },
          child: Text('신청하기'),
        );
      }

      return Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                // 카드의 좌측 섹션: 이미지, 제목, 내용
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('${GroupDelivery.title}', style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 8),
                    Text('${GroupDelivery.content}', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSwPo0rstrV0xYw_ej43GNHALxIKhBIp4yD8Q&usqp=CAU',
                      // 실제 이미지 URL로 변경
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
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
                  Text('마감 시간: ${DateFormat('yyyy년 M월 d일').format(GroupDelivery.duetime)}'),
                  SizedBox(height: 8),
                  Text('${DateFormat('HH시 mm분').format(GroupDelivery.duetime)}'),
                  SizedBox(height: 8),
                  actionButton,
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
  void _showCupertinoTimePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 150,
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
              )
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
        return AlertDialog(
          title: Text(''),
          content: Text('마감 시간이 ${DateFormat('HH:mm').format(duetime)}으로 설정되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // Alert 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  void _showPostModal(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('글 작성하기'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      onSaved: (val) => title = val!,
                      decoration: InputDecoration(labelText: '제목'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      onSaved: (val) => content = val!,
                      decoration: InputDecoration(labelText: '설명'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      onSaved: (val) => member = int.tryParse(val ?? '0') ?? 0,
                      decoration: InputDecoration(labelText: '참여 인원'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        // 이미지 첨부 기능 구현
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.image, size: 24),
                          SizedBox(width: 8),
                          Text('이미지 첨부'),
                        ],
                      ),
                    ),
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