import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final String cardTitle;
  final String subTitle;
  const CardHeader({
    Key? key,
    required this.cardTitle,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screen_width * 40, //530
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: AppColors.headbgColor,
            padding: EdgeInsets.all(5),
            child: Text(
              cardTitle,
              style: TextStyle(
                fontSize: SizeConfig.font_height * 2,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: SizeConfig.screen_width * 0.5),
            child: Text(
              subTitle,
              style: TextStyle(
                fontSize: SizeConfig.font_height * 2,
                fontStyle: FontStyle.italic,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
