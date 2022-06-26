import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class SetValueController extends StatelessWidget {
  final VoidCallback onIncreament;
  final VoidCallback onDecreament;
  final Function(dynamic) onIncLongPressStart;
  final Function(dynamic) onDecLongPressStart;
  final Function(dynamic) onLongPressEnd;
  final String setValue;
  const SetValueController({
    Key key,
    @required this.setValue,
    @required this.onIncreament,
    @required this.onDecreament,
    @required this.onIncLongPressStart,
    @required this.onDecLongPressStart,
    @required this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.screen_height * 0.5,
        horizontal: SizeConfig.screen_height * 1.5,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.screen_width * 1.5,
        vertical: SizeConfig.screen_height * 0.5,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: onDecreament,
            onLongPressStart: onDecLongPressStart,
            onLongPressEnd: onLongPressEnd,
            child: Icon(
              Icons.remove,
              size: SizeConfig.font_height * 3.75,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: SizeConfig.screen_height * 1),
            child: Text(
              setValue,
              style: TextStyle(
                fontFamily: 'digital',
                fontSize: SizeConfig.font_height * 3.4,
                fontWeight: FontWeight.w900,
                color: AppColors.text_sv_color,
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncreament,
            onLongPressStart: onIncLongPressStart,
            onLongPressEnd: onLongPressEnd,
            child: Icon(
              Icons.add_rounded,
              size: SizeConfig.font_height * 3.75,
            ),
          ),
        ],
      ),
    );
  }
}
