import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:madcamp_week2/viewmodel/board_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/board_model.dart';
import 'control_view_ds.dart';

class PostModal {
  void show(BuildContext context, String email) {
    File? selectedImage;
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
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
              backgroundColor: Colors.white,
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: titleController,
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
                    const SizedBox(height: 10),
                    TextField(
                      controller: contentController,
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
                      maxLines: 5,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        // 이미지 첨부 기능 구현
                        selectedImage = await _getImageFromGallery();
                        // TODO: 선택된 이미지를 사용하거나 업로드하는 로직 추가
                        if (selectedImage != null) {
                          _showImageAttachedAlert(context);
                        }
                      },
                      child: const Text(
                          '이미지 첨부',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('작성하기'),
                  onPressed: () async {
                    // 글 작성 로직 구현
                    if (!_isContentEmpty(
                        titleController.text, contentController.text)) {
                      // TODO: 제목이나 내용 중 하나 이상이 입력되었을 때의 로직 추가
                      String? imagePath = selectedImage?.path;
                      String _imagePath = imagePath ?? '';
                      BoardModel newBoardModel = BoardModel(
                        id: -1,
                        email: email,
                        title: titleController.text,
                        content: contentController.text,
                        image: _imagePath,
                      );

                      try {
                        await addBoard(newBoardModel);
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ControlViewDS(),
                        ),
                      );
                    } else {
                      // 둘 중 하나라도 작성되지 않았을 때 에러 메시지 표시
                      showErrorDialog(context, "제목과 내용을 입력해주세요.");
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
  static bool _isContentEmpty(String title, String content) {
    return title.isEmpty || content.isEmpty;
  }

  static Future<File?> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }


  static void _showImageAttachedAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 크기를 최소화
              children: [
                Text('이미지가 첨부되었습니다.'),
                SizedBox(height: 16),
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 크기를 최소화
              children: [
                Text(message),
                SizedBox(height: 16),
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}