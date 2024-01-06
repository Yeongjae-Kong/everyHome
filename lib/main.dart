import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter 기본 앱 디자인'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '여기에 텍스트를 추가하세요.',
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업
                },
                child: Text('버튼'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}