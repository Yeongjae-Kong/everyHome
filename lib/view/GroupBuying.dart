import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/groupbuying_model.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';
import '../notification.dart';
import '../viewmodel/groupbuying_viewmodel.dart';

class GroupBuying extends StatefulWidget {
  @override
  _GroupBuyingState createState() => _GroupBuyingState();
}

class _GroupBuyingState extends State<GroupBuying> {
  List<GroupBuyingModel> groupBuyings = [];
  String currentUserEmail = '';

  @override
  void initState() {
    _loadCurrentUserEmail();
    _loadGroupBuyings();
    FlutterLocalNotification.init();
    FlutterLocalNotification.requestNotificationPermission();
    super.initState();
  }

  Future<void> _loadGroupBuyings() async {
    try {
      var fetchedGroupBuyings = await fetchGroupBuyings();
      setState(() {
        groupBuyings = fetchedGroupBuyings;
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
                  itemCount: groupBuyings.length, // 생성할 카드의 수 (실제 데이터로 조정하세요)
                  itemBuilder: (context, index) {
                    return _buildGroupBuyingCard(index);
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

  Widget? _buildGroupBuyingCard(int index) {
    if (index < groupBuyings.length) {
      GroupBuyingModel groupBuying = groupBuyings[index];
      // groupbuyingpost 작성자가 본인이며 신청하기 대신 삭제하기로 변경
      Widget actionButton;

      if (groupBuying.email == currentUserEmail) {
        actionButton = ElevatedButton(
          onPressed: () async {
            try {
              await deleteGroupBuying(groupBuying.id);
              // 성공적으로 삭제 후 UI 업데이트
              setState(() {
                groupBuyings.removeWhere((item) => item.id == groupBuying.id); // ID를 기준으로 항목 제거
              });
              _loadGroupBuyings();
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
        String buttonText = groupBuying.member > 0 ? '신청하기' : '모집완료';
        TextStyle buttonStyle = groupBuying.member > 0
            ? TextStyle(fontSize: 14)
            : TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
        bool isButtonEnabled = groupBuying.member > 0;

        actionButton = ElevatedButton(
          onPressed: isButtonEnabled ? () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (groupBuying.member == 1) {
              FlutterLocalNotification.showBuyingNotification();
            }
            setState(() {
              groupBuying.member -= 1;
            });
            await updateGroupBuying(groupBuying);

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
        height: 100, // Card의 높이를 조절하려면 height 값을 조정하세요
        margin: EdgeInsets.all(10),
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
                        const Icon(
                          Icons.shopping_cart, // 물품 아이콘
                          size: 60, // 아이콘 크기 조절
                          color: Colors.black, // 아이콘 색상 조절
                        ),
                        SizedBox(width: 40),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${groupBuying.title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${groupBuying.content}',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
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
              // 우측 섹션: 남은 인원, 신청하기 버튼
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '남은 인원: ${groupBuying.member}명',
                    style: TextStyle(color: Colors.black),
                  ),
                  actionButton,
                ],
              ),
            ],
          ),
        ),
      );
    }
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
                    // decoration: InputDecoration(labelText: '제목'),
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
                  SizedBox(height: 10),
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
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
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
                  // SizedBox(height: 8),
                  // TextButton(
                  //   onPressed: () {
                  //     // 이미지 첨부 기능 구현
                  //   },
                  //   child: const Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: <Widget>[
                  //       Icon(Icons.image, size: 24),
                  //       SizedBox(width: 8),
                  //       Text('이미지 첨부'),
                  //     ],
                  //   ),
                  // ),
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


                  // GroupBuyingModel 객체 생성
                  GroupBuyingModel newGroupBuying = GroupBuyingModel(
                    id: -1, // ID는 서버에서 자동으로 할당될 수 있습니다.
                    email: email,
                    title: title,
                    content: content,
                    image: image,
                    member: member,
                  );

                  // 서버에 데이터 추가
                  try {
                    await addGroupBuying(newGroupBuying);
                    // 성공 메시지 또는 후속 처리
                  } catch (e) {
                    // 에러 처리
                    print(e);
                  }
                }
                Navigator.pop(context);
                _loadGroupBuyings();
              },
            ),
          ],
        );
      },
    );
  }
}