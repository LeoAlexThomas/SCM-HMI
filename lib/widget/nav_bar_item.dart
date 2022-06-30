import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSeleted;
  final bool isAvaiable;
  const NavBarItem({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isSeleted,
    this.isAvaiable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: SizeConfig.screen_height * 3.5,
          bottom: SizeConfig.screen_height * 3.5,
          right: SizeConfig.screen_width * 1.5,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.black,
          ),
          color: isAvaiable
              ? isSeleted
                  ? Colors.blue[300]
                  : AppColors.blue
              : AppColors.grey,
        ),
        child: Text(
          title,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: isAvaiable
                ? isSeleted
                    ? AppColors.white
                    : AppColors.black
                : AppColors.black,
            fontSize: SizeConfig.font_height * 2.65, //20
          ),
        ),
      ),
    );
  }
}
