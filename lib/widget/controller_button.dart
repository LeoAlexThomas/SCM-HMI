import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class ControllerButton extends StatelessWidget {
  final VoidCallback? onPress;
  final String? buttonLabel;
  final Function(dynamic)? onLongPressStart;
  final Function(dynamic)? onLongPressEnd;
  final Color? buttonColor;
  const ControllerButton({
    Key? key,
    required this.buttonLabel,
    required this.onPress,
    this.buttonColor = Colors.grey,
    this.onLongPressStart,
    this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screen_height * 5.5, //50
      margin: EdgeInsets.only(bottom: SizeConfig.screen_height * 0.5),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.screen_width * 0.5,
      ),
      child: GestureDetector(
        onLongPressStart: onLongPressStart,
        onLongPressEnd: onLongPressEnd,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            padding: EdgeInsets.symmetric(horizontal: 5.0),
          ),
          onPressed: onPress,
          child: Text(
            buttonLabel!,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.65, //20
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
