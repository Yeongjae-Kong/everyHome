// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'ItemDetailModal.dart';
//
// class NoticeView extends StatelessWidget {
//   final List<Map<String, String>> noticeItems = [
//     {'title': '몰입캠프', 'content': '몰입캠프 1분반 화이팅\n안녕\n하세요\n반가워요', 'image': 'https://raw.githubusercontent.com/Yeongjae-Kong/madcamp_week2/main/assets/images/madcamp_first.jpeg'},
//     {'title': '플러터', 'content': '예쁘다', 'image': ''},
//     // Add more items as needed
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               '공지사항',
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: noticeItems.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     // 아이템이 클릭되었을 때의 동작을 정의합니다.
//                     String title = noticeItems[index]['title']!;
//                     String content = noticeItems[index]['content']!;
//                     String imageUrl = noticeItems[index]['image']!;
//                     ItemDetailModal.show(context, 0, title, content, imageUrl, false);
//                   },
//                   child: Card(
//                     margin: EdgeInsets.symmetric(horizontal: 8),
//                     child: Container(
//                       width: 350,
//                       padding: EdgeInsets.all(16),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Title and Content
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   noticeItems[index]['title']!,
//                                   style: TextStyle(fontSize: 16),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   noticeItems[index]['content']!,
//                                   style: TextStyle(fontSize: 14, color: Colors.grey),
//                                   maxLines: 4,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           SizedBox(width: 16),
//                           if (noticeItems[index]['image']!='')
//                             Icon(Icons.photo, size: 40)
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'ItemDetailModal.dart';

class NoticeView extends StatelessWidget {
  final List<Map<String, String>> noticeItems = [
    {
      'title': '몰입캠프',
      'content': '몰입캠프 1분반 화이팅\n안녕\n하세요\n반가워요',
      'image':
      'https://raw.githubusercontent.com/Yeongjae-Kong/madcamp_week2/main/assets/images/madcamp_first.jpeg'
    },
    {'title': '플러터', 'content': '예쁘다', 'image': ''},
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '공지사항',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: noticeItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    String title = noticeItems[index]['title']!;
                    String content = noticeItems[index]['content']!;
                    String imageUrl = noticeItems[index]['image']!;
                    ItemDetailModal.show(context, 0, title, content, imageUrl, false);
                  },
                  child: GlassmorphicCard(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      width: 350,
                      height: 200,
                      padding: EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  noticeItems[index]['title']!,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  noticeItems[index]['content']!,
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          if (noticeItems[index]['image'] != '') Icon(Icons.photo, size: 40)
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  GlassmorphicCard({required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            Colors.transparent,
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(16),
            color: Colors.white.withOpacity(0.3),
            child: child,
          ),
        ),
      ),
    );
  }
}
