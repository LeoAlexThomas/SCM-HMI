import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class DebugConsole extends StatelessWidget {
  final List<Widget> rxDebugList;
  final List<Widget> txDebugList;
  final ScrollController rxScrollController;
  final ScrollController txScrollController;

  DebugConsole({
    Key? key,
    required this.rxDebugList,
    required this.txDebugList,
    required this.rxScrollController,
    required this.txScrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screen_width * 78,
      // height: SizeConfig.screen_height * 25,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.screen_height * 1.25,
                bottom: SizeConfig.screen_height * 1.25),
            child: Text(
              'DebugConsole',
              style: TextStyle(
                fontSize: SizeConfig.font_height * 3.4,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1,
                    bottom: SizeConfig.screen_height * 1,
                    left: SizeConfig.screen_width * 1,
                    right: SizeConfig.screen_width * 1,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  width: SizeConfig.screen_width * 42, //500
                  height: SizeConfig.screen_height * 75, //600
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RxData:',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.65, //20
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: rxScrollController,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.screen_height * 1,
                              bottom: SizeConfig.screen_height * 1,
                              left: SizeConfig.screen_width * 1,
                              right: SizeConfig.screen_width * 1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: rxDebugList,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1,
                    bottom: SizeConfig.screen_height * 1,
                    left: SizeConfig.screen_width * 1,
                    right: SizeConfig.screen_width * 1,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black),
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  width: SizeConfig.screen_width * 42, //500
                  height: SizeConfig.screen_height * 75, //600
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TxData:',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.65, //20
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: txScrollController,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: SizeConfig.screen_height * 1,
                              bottom: SizeConfig.screen_height * 1,
                              left: SizeConfig.screen_width * 1,
                              right: SizeConfig.screen_width * 1,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: txDebugList,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
