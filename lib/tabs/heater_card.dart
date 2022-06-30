import 'package:StirCastingMachine/calculation.dart';
import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:flutter/material.dart';

class HeaterCard extends StatelessWidget {
  final String? furnaceButtonLabel;
  final String? powderButtonLabel;
  final String? mouldButtonLabel;
  final bool isFurnaceOn;
  final bool isPowderOn;
  final bool isMouldOn;
  final Color? furnaceButtonColor;
  final Color? powderButtonColor;
  final Color? mouldButtonColor;
  final VoidCallback? onFurnacePress;
  final VoidCallback? onPowderPress;
  final VoidCallback? onMouldPress;
  final String furnacePrecentValue;
  final String meltPrecentValue;
  final String powderPrecentValue;
  final String mouldPrecentValue;
  final String furnaceSetValue;
  final String meltSetValue;
  final String powderSetValue;
  final String mouldSetValue;
  final Widget? subTitle;
  final VoidCallback? onFurnaceIncreament;
  final VoidCallback? onMeltIncreament;
  final VoidCallback? onPowderIncreament;
  final VoidCallback? onMouldIncreament;
  final VoidCallback? onFurnaceDecreament;
  final VoidCallback? onMeltDecreament;
  final VoidCallback? onPowderDecreament;
  final VoidCallback? onMouldDecreament;
  final Function(dynamic)? onFurnaceIncLongPressStart;
  final Function(dynamic)? onMeltIncLongPressStart;
  final Function(dynamic)? onPowderIncLongPressStart;
  final Function(dynamic)? onMouldIncLongPressStart;
  final Function(dynamic)? onFurnaceDecLongPressStart;
  final Function(dynamic)? onMeltDecLongPressStart;
  final Function(dynamic)? onPowderDecLongPressStart;
  final Function(dynamic)? onMouldDecLongPressStart;
  final Function(dynamic)? onLongPressEnd;
  final Calculation calc;

  HeaterCard({
    Key? key,
    required this.furnaceButtonLabel,
    required this.powderButtonLabel,
    required this.mouldButtonLabel,
    required this.isFurnaceOn,
    required this.isMouldOn,
    required this.isPowderOn,
    required this.furnaceButtonColor,
    required this.mouldButtonColor,
    required this.powderButtonColor,
    required this.furnacePrecentValue,
    required this.meltPrecentValue,
    required this.powderPrecentValue,
    required this.mouldPrecentValue,
    required this.furnaceSetValue,
    required this.meltSetValue,
    required this.powderSetValue,
    required this.mouldSetValue,
    required this.onFurnacePress,
    required this.onPowderPress,
    required this.onMouldPress,
    required this.calc,
    this.subTitle,
    this.onFurnaceIncreament,
    this.onMeltIncreament,
    this.onPowderIncreament,
    this.onMouldIncreament,
    this.onFurnaceDecreament,
    this.onMeltDecreament,
    this.onPowderDecreament,
    this.onMouldDecreament,
    this.onFurnaceIncLongPressStart,
    this.onMeltIncLongPressStart,
    this.onPowderIncLongPressStart,
    this.onMouldIncLongPressStart,
    this.onFurnaceDecLongPressStart,
    this.onMeltDecLongPressStart,
    this.onPowderDecLongPressStart,
    this.onMouldDecLongPressStart,
    this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CardHeader(cardTitle: "HEATERS", subTitle: "(deg. C)"),
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
                rowTitle: "1) FURNACE",
                isControllerOn: isFurnaceOn,
                controllerColor: furnaceButtonColor,
                precentValue: furnacePrecentValue,
                setValue: furnaceSetValue,
                isPourContent: false,
                buttonLabel: furnaceButtonLabel,
                onIncreament: onFurnaceIncreament,
                onDecreament: onFurnaceDecreament,
                onPress: onFurnacePress,
                onIncLongPressStart: onFurnaceIncLongPressStart,
                onDecLongPressStart: onFurnaceDecLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
              DataContentShow.getRowContent(
                rowTitle: "2) Melt",
                isControllerOn: false,
                controllerColor: furnaceButtonColor,
                precentValue: meltPrecentValue,
                setValue: meltSetValue,
                isPourContent: false,
                isControllerNeed: false,
                buttonLabel: furnaceButtonLabel,
                onIncreament: onMeltIncreament,
                onDecreament: onMeltDecreament,
                onPress: onFurnacePress,
                onIncLongPressStart: onMeltIncLongPressStart,
                onDecLongPressStart: onMeltDecLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
              DataContentShow.getRowContent(
                rowTitle: "3) Powder",
                isControllerOn: isPowderOn,
                precentValue: powderPrecentValue,
                controllerColor: powderButtonColor,
                setValue: powderSetValue,
                isPourContent: false,
                buttonLabel: powderButtonLabel,
                onIncreament: onPowderIncreament,
                onDecreament: onPowderDecreament,
                onPress: onPowderPress,
                onIncLongPressStart: onPowderIncLongPressStart,
                onDecLongPressStart: onPowderDecLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
              DataContentShow.getRowContent(
                rowTitle: "4) MOULD",
                isControllerOn: isMouldOn,
                controllerColor: mouldButtonColor,
                precentValue: mouldPrecentValue,
                setValue: mouldSetValue,
                isPourContent: false,
                buttonLabel: mouldButtonLabel,
                onIncreament: onMouldIncreament,
                onDecreament: onMouldDecreament,
                onPress: onMouldPress,
                onIncLongPressStart: onMouldIncLongPressStart,
                onDecLongPressStart: onMouldDecLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
