import 'package:StirCastingMachine/calculation.dart';
import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:flutter/material.dart';

class PouringCard extends StatelessWidget {
  final String? buttonLabel;
  final Color? buttonColor;
  final String operationName;
  final VoidCallback? onPress;
  final String precentValue;
  final String? setValue;
  final Widget? subTitle;
  final VoidCallback? onIncreament;
  final VoidCallback? ondecreament;
  final Function(dynamic)? onIncLongPressStart;
  final Function(dynamic)? onDecLongPressStart;
  final Function(dynamic)? onLongPressEnd;
  final Calculation calc;

  PouringCard({
    Key? key,
    required this.buttonLabel,
    required this.buttonColor,
    required this.operationName,
    required this.precentValue,
    required this.setValue,
    required this.onPress,
    required this.calc,
    this.subTitle,
    this.onIncreament,
    this.ondecreament,
    this.onIncLongPressStart,
    this.onDecLongPressStart,
    this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      // padding: EdgeInsets.symmetric(vertical: SizeConfig.screen_height * 1),
      margin: EdgeInsets.symmetric(vertical: SizeConfig.screen_height * 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CardHeader(cardTitle: "POURING", subTitle: ""),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(SizeConfig.screen_width * 9),
              1: FixedColumnWidth(SizeConfig.screen_width * 8),
              2: FixedColumnWidth(SizeConfig.screen_width * 15),
              3: FixedColumnWidth(SizeConfig.screen_width * 8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              DataContentShow.getTableHeader(),
              DataContentShow.getRowContent(
                rowTitle: operationName,
                isControllerOn: false,
                controllerColor: buttonColor,
                precentValue: precentValue,
                setValue: setValue!,
                isPourContent: true,
                buttonLabel: buttonLabel,
                onIncreament: onIncreament,
                onDecreament: ondecreament,
                onPress: onPress,
                onIncLongPressStart: onIncLongPressStart,
                onDecLongPressStart: onDecLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
