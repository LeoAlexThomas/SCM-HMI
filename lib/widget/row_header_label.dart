import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class RowHeaderLabel extends StatelessWidget {
  final String rowTitle;
  final bool isRunning;
  const RowHeaderLabel({
    Key key,
    @required this.rowTitle,
    this.isRunning = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRunning ? AppColors.red : Colors.transparent,
      padding: EdgeInsets.only(left: SizeConfig.screen_width * 1.5),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.screen_width * 0.5,
        vertical: SizeConfig.screen_height * 0.5,
      ),
      child: Text(
        rowTitle,
        style: TextStyle(
          fontSize: SizeConfig.font_height * 2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
