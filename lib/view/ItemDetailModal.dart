import 'package:flutter/material.dart';

class ItemDetailModal {
  static void show(BuildContext context, String title, String content, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Flexible 위젯을 사용하여 이미지 크기를 조절
                Align(
                  alignment: Alignment.center,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  )
                      : Container(),
                ),
                SizedBox(height: 10),
                Text(
                  content,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    child: Text('닫기'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



// class ItemDetailModal {
//   static void show(BuildContext context, String title, String content, String imageUrl) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           // AlertDialog 대신 Dialog를 사용하여 크기 조절이 쉽게 가능
//           backgroundColor: Colors.white, // 배경을 흰색으로 지정
//           insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24), // 여백 지정
//           child: Container(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 20, // Text 사이즈를 키움
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Image.network(
//                   imageUrl,
//                   height: 200, // 이미지 높이 조절
//                   width: double.infinity, // 이미지 너비를 최대로
//                   fit: BoxFit.cover, // 이미지를 가득 차게 표시
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   content,
//                   style: TextStyle(fontSize: 16), // Text 사이즈를 키움
//                 ),
//                 SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.center,
//                   child: TextButton(
//                     child: Text('닫기'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

