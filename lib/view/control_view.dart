import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madcamp_week2/view/CustomAppBar.dart';

class ControlView extends StatefulWidget {
  const ControlView({Key? key}) : super(key: key);

  @override
  State<ControlView> createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> {
  @override
  Widget build(BuildContext context) {
    Widget _notification(){
      Widget _item(String image, String title){
        return Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0x7FADCFF8),
              borderRadius: BorderRadius.circular(10)),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                //TODO 여기에 공지 내용 추가
                Image.network(
                  image,
                  width: 60,
                  height: 40,
                )
              ]
            ),
          ),
          ),

        );
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              CustomAppBar(),
            ],
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // children: [
            // ],
          ),
        )
      )
    );
  }
}

