import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/main.dart';
import 'package:madcamp_week2/view/ItemDetailModal_notif.dart';
import 'package:madcamp_week2/view/PostModal.dart';
import 'package:madcamp_week2/view/control_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/board_model.dart';
import '../viewmodel/board_viewmodel.dart';
import 'ItemDetailModal.dart';

class ControlViewDS extends StatefulWidget {
  const ControlViewDS({Key? key}) : super(key: key);


  @override
  State<ControlViewDS> createState() => _ControlViewDSState();
}

class _ControlViewDSState extends State<ControlViewDS> {
  PostModal _postModal = PostModal();
  List<BoardModel> Boards = [];
  String currentUserEmail = '';

  @override
  void initState(){
    super.initState();
    _loadCurrentUserEmail();
    _loadBoards();
  }

  Future<void> _loadBoards() async {
    try {
      var fetchedBoards = await fetchBoards();
      setState(() {
        Boards = fetchedBoards;
      });
    } catch (e) {
      print('Error fetching boards: $e');
    }
  }

  Future<void> _loadCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('email') ?? '';
    });
  }

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
          onPressed: () async {
            try{
              _postModal.show(context, currentUserEmail);
              await _loadBoards();
            } catch (e){
              print('$e');
            }
          }, // 모달 띄우기
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
    return MediaQuery.of(context).size;
  }

  _getDraggableScrollableSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        minChildSize: 0.46,
        maxChildSize: 1,
        initialChildSize: 0.46,
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
                    color: Colors.white
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
                          itemCount: Boards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {
                                var isDeletable = false;
                                if (Boards[index].email == currentUserEmail){
                                  isDeletable = true;
                                }
                                int id = Boards[index].id;
                                String title = Boards[index].title;
                                String content = Boards[index].content;
                                String imageUrl = Boards[index].image; // 이미지 URL 가져오기
                                try{
                                  ItemDetailModalNotif.show(context, id, title, content, imageUrl, isDeletable);
                                  final itemDeleted = Provider.of<MyGlobalState>(context, listen: false).itemDeleted;
                                  print('itemDeleted: $itemDeleted');
                                  if(itemDeleted){
                                    setState(() {
                                      Boards.removeWhere((item) => item.id == id); // ID를 기준으로 항목 제거
                                    });
                                  }
                                  _loadBoards();
                                } catch (e){
                                  print('Error deleting item $e');
                                }
                              },

                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Boards[index].title,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          Boards[index].content,
                                          style: TextStyle(fontSize: 14, color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Divider를 사용하여 가로 선을 추가
                                  Divider(
                                    color: Colors.grey.withOpacity(0.5),
                                    thickness: 2, // 가로 선의 두께 조절
                                    indent: MediaQuery.of(context).size.width * 0.05, // 시작 위치 여백 (화면의 10%)
                                    endIndent: MediaQuery.of(context).size.width * 0.05, // 가로 선의 길이를 화면의 80%로 설정 (화면의 80%)
                                    ),
                                ],
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

          // return Stack(
          //   children: [
          //     Container(
          //       decoration: BoxDecoration(
          //         borderRadius: const BorderRadius.only(
          //           topRight: Radius.circular(30.0),
          //           topLeft: Radius.circular(30.0),
          //         ),
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius: 6.0,
          //             spreadRadius: 6.0,
          //             offset: const Offset(0.0, 5.0),
          //             color: Colors.black.withOpacity(0.1),
          //           ),
          //         ],
          //         color: Colors.white.withOpacity(0.5),
          //         gradient: LinearGradient(
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //           colors: [
          //             Colors.white.withOpacity(1),
          //             Colors.white.withOpacity(1)
          //             // Color(0x80FFFFFF), // 50% transparent white
          //             // Color(0x90FFFFFF), // 18% transparent white
          //           ],
          //         ),
          //       ),
          //       child: SingleChildScrollView(
          //         controller: scrollController,
          //         physics: ClampingScrollPhysics(),
          //         child: Container(
          //           margin: EdgeInsets.only(top: 0.05 * getSize(context).height),
          //           height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
          //           width: double.infinity,
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               SizedBox(height: 10),
          //               Row(
          //                 children: [
          //                   const Spacer(),
          //                   Column(
          //                     children: [
          //                       const Text(
          //                         '게시판',
          //                         style: TextStyle(
          //                           color: Colors.black,
          //                           fontSize: 16,
          //                           fontWeight: FontWeight.bold,
          //                         ),
          //                       ),
          //                       SizedBox(height: 5),
          //                       Container(
          //                         height: 4,
          //                         width: 60,
          //                         decoration: BoxDecoration(
          //                           borderRadius: BorderRadius.circular(15.0),
          //                           color: Colors.grey,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   const Spacer(),
          //                 ],
          //               ),
          //               Expanded(
          //                 child: ListView.builder(
          //                   itemCount: Boards.length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     return InkWell(
          //                       onTap: () async {
          //                         // Your existing onTap logic
          //                       },
          //                       child: Column(
          //                         children: [
          //                           ListTile(
          //                             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          //                             title: Column(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   Boards[index].title,
          //                                   style: TextStyle(fontSize: 18),
          //                                 ),
          //                                 SizedBox(height: 5),
          //                                 Text(
          //                                   Boards[index].content,
          //                                   style: TextStyle(fontSize: 14, color: Colors.grey),
          //                                   overflow: TextOverflow.ellipsis,
          //                                   maxLines: 2,
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           // Divider
          //                           Divider(
          //                             color: Colors.grey.withOpacity(0.5),
          //                             thickness: 2,
          //                             indent: MediaQuery.of(context).size.width * 0.05,
          //                             endIndent: MediaQuery.of(context).size.width * 0.05,
          //                           ),
          //                         ],
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // );

        },
      ),
    );
  }
}
