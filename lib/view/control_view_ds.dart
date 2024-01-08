import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/PostModal.dart';
import 'package:madcamp_week2/view/control_view.dart';

import 'ItemDetailModal.dart';

class ControlViewDS extends StatefulWidget {
  const ControlViewDS({Key? key}) : super(key: key);

  @override
  State<ControlViewDS> createState() => _ControlViewDSState();
}

class _ControlViewDSState extends State<ControlViewDS> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: ControlView(),
            ),
            Positioned.fill(
              child: _getDraggableScrollableSheet(),
            )
          ],
        ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20), // 하단에 패딩 추가
        child: FloatingActionButton.extended(
          onPressed: () => PostModal.show(context), // 모달 띄우기
          icon: Icon(Icons.create, size: 20, color: Colors.black), // 아이콘 크기 조절
          label: Text(
            '글쓰기',
            style: TextStyle(color: Colors.black, fontSize: 16), // 텍스트 크기 조절
          ),
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

  Size getSize(BuildContext context) {
    return MediaQuery
        .of(context)
        .size;
  }

  _getDraggableScrollableSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        minChildSize: 0.42,
        maxChildSize: 1,
        initialChildSize: 0.42,
        builder: (BuildContext context, ScrollController scrollController) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                physics: ClampingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.only(top: 0.05 * getSize(context).height),
                  height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6.0,
                        spreadRadius: 6.0,
                        offset: const Offset(0.0, 5.0),
                        color: Colors.black.withOpacity(0.1),
                      )
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                          children: [
                            const Spacer(),
                            Column(
                              children: [
                                const Text(
                                  '게시판',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  height: 4,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                          ]
                      ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            // 클릭한 아이템의 인덱스를 이용하여 모달을 띄우는 로직 추가
                            String noticeContent = '아이템 ${index+1}의 내용입니다.';
                            ItemDetailModal.show(context, noticeContent);
                          },
                          child: Container(
                            height: 80,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            color: Color(0x7FADCFF8),
                            child: ListTile(
                              title: Text(
                                '아이템 $index',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
