import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class InstructionTextView extends StatelessWidget {
  final String instruction;
  final Color textColor;
  const InstructionTextView({
    @required this.instruction,
    this.textColor,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u2713 ',
          style: TextStyle(
            fontSize: SizeConfig.font_height * 1.7, //12.5
            color: textColor ?? Colors.blue[900],
          ),
        ),
        Flexible(
          child: Text(
            instruction,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 1.7, //12.5
              color: textColor ?? Colors.blue[900],
            ),
          ),
        ),
      ],
    );
  }
}
