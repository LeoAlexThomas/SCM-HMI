import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:StirCastingMachine/widget/controller_button.dart';
import 'package:StirCastingMachine/widget/precent_value_show.dart';
import 'package:StirCastingMachine/widget/row_header_label.dart';
import 'package:flutter/material.dart';

class UltraSonicCard extends StatelessWidget {
  final String? powderVibButtonLabel;
  final Color? powderVibButtonColor;
  final String? uvEMVButtonLabel;
  final Color? uvEMVButtonColor;
  final String uvLiftPrecentValue;
  final VoidCallback? onPowderVibPress;
  final VoidCallback? onUVEMVPress;
  final VoidCallback? onUVLiftUpPress;
  final VoidCallback? onUVLiftDownPress;
  final Color? liftUpButtonColor;
  final Color? liftDownButtonColor;
  final Function(dynamic) uvLiftUpLongPressStart;
  final Function(dynamic) uvLiftUpLongPressEnd;
  final Function(dynamic) uvLiftDownLongPressStart;
  final Function(dynamic) uvLiftDownLongPressEnd;
  const UltraSonicCard({
    Key? key,
    required this.powderVibButtonLabel,
    required this.powderVibButtonColor,
    required this.uvEMVButtonLabel,
    required this.uvEMVButtonColor,
    required this.uvLiftPrecentValue,
    required this.onUVLiftUpPress,
    required this.onUVLiftDownPress,
    required this.uvLiftUpLongPressStart,
    required this.uvLiftUpLongPressEnd,
    required this.uvLiftDownLongPressStart,
    required this.uvLiftDownLongPressEnd,
    required this.onPowderVibPress,
    required this.onUVEMVPress,
    required this.liftUpButtonColor,
    required this.liftDownButtonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screen_height * 31,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CardHeader(cardTitle: "ULTRASONIC", subTitle: ""),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(SizeConfig.screen_width * 12),
              1: FixedColumnWidth(SizeConfig.screen_width * 8),
              2: FixedColumnWidth(SizeConfig.screen_width * 15),
              3: FixedColumnWidth(SizeConfig.screen_width * 8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Text(""),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "PRESENT",
                      style: TextStyle(
                        fontSize: SizeConfig.font_height * 2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.customRed,
                      ),
                    ),
                  ),
                  const SizedBox.shrink(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'CONTROLS',
                      style: TextStyle(
                        fontSize: SizeConfig.font_height * 2,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                ],
              ),
              DataContentShow.getRowContent(
                rowTitle: "1) POWDER VIB",
                isControllerOn: false,
                controllerColor: powderVibButtonColor,
                precentValue: "",
                setValue: "",
                buttonLabel: powderVibButtonLabel,
                onIncreament: () {},
                onDecreament: () {},
                onPress: onPowderVibPress,
                onIncLongPressStart: (_) {},
                onDecLongPressStart: (_) {},
                onLongPressEnd: (_) {},
              ),
              DataContentShow.getRowContent(
                rowTitle: "2) UV / EMV",
                isControllerOn: false,
                controllerColor: uvEMVButtonColor,
                precentValue: "",
                setValue: "",
                buttonLabel: uvEMVButtonLabel,
                onIncreament: () {},
                onDecreament: () {},
                onPress: onUVEMVPress,
                onIncLongPressStart: (_) {},
                onDecLongPressStart: (_) {},
                onLongPressEnd: (_) {},
              ),
              TableRow(
                children: [
                  RowHeaderLabel(rowTitle: "3) LIFT"),
                  PrecentValueShow(precentValue: uvLiftPrecentValue),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ControllerButton(
                      buttonLabel: "UP",
                      onPress: onUVLiftUpPress,
                      buttonColor: liftUpButtonColor,
                      onLongPressStart: uvLiftUpLongPressStart,
                      onLongPressEnd: uvLiftUpLongPressEnd,
                    ),
                  ),
                  ControllerButton(
                    buttonLabel: "DOWN",
                    buttonColor: liftDownButtonColor,
                    onPress: onUVLiftDownPress,
                    onLongPressStart: uvLiftDownLongPressStart,
                    onLongPressEnd: uvLiftDownLongPressEnd,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screen_height * 1),
        ],
      ),
    );
  }
}
