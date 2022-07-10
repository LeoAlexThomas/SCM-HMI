import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class PrecentValueShow extends StatelessWidget {
  final String precentValue;
  const PrecentValueShow({Key? key, required this.precentValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
        bottom: SizeConfig.screen_height * 1.25,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      alignment: Alignment.center,
      child: Text(
        precentValue,
        style: TextStyle(
          fontFamily: 'digital',
          color: AppColors.customRed,
          fontSize: SizeConfig.font_height * 3.4,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
