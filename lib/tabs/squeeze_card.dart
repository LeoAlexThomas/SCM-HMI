import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:flutter/material.dart';

class SqueezeCard extends StatelessWidget {
  final String runwayButtonLabel;
  final Color runwayButtonColor;
  final bool isRunwayOn;
  final String squeezeButtonLabel;
  final Color squeezeButtonColor;
  final String runwayPrecentValue;
  final String runwaySetValue;
  final String squeezePrecentValue;
  final VoidCallback onRunwayPress;
  final VoidCallback onSqueezePress;
  final VoidCallback onRunwayIncreament;
  final VoidCallback onRunwayDecreament;
  final Function(dynamic) onRunwayIncLongPressStart;
  final Function(dynamic) onRunwayDecLongPressStart;
  final Function(dynamic) onLongPressEnd;
  const SqueezeCard({
    Key key,
    @required this.runwayButtonLabel,
    @required this.runwayButtonColor,
    @required this.isRunwayOn,
    @required this.squeezeButtonLabel,
    @required this.squeezeButtonColor,
    @required this.runwayPrecentValue,
    @required this.runwaySetValue,
    @required this.squeezePrecentValue,
    @required this.onRunwayPress,
    @required this.onSqueezePress,
    @required this.onRunwayIncreament,
    @required this.onRunwayDecreament,
    @required this.onRunwayIncLongPressStart,
    @required this.onRunwayDecLongPressStart,
    @required this.onLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screen_height * 25,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CardHeader(cardTitle: "SQUEEZE CASTING", subTitle: ""),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(SizeConfig.screen_width * 12),
              1: FixedColumnWidth(SizeConfig.screen_width * 8),
              2: FixedColumnWidth(SizeConfig.screen_width * 15),
              3: FixedColumnWidth(SizeConfig.screen_width * 8),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              DataContentShow.getTableHeader(),
              DataContentShow.getRowContent(
                rowTitle: "1) RUNWAY",
                isControllerOn: isRunwayOn,
                controllerColor: runwayButtonColor,
                precentValue: runwayPrecentValue,
                setValue: runwaySetValue,
                isPourContent: false,
                buttonLabel: runwayButtonLabel,
                onIncreament: onRunwayIncreament,
                onDecreament: onRunwayDecreament,
                onPress: onRunwayPress,
                onIncLongPressStart: onRunwayIncLongPressStart,
                onDecLongPressStart: onRunwayDecLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
              DataContentShow.getRowContent(
                rowTitle: "2) SQUEEZE PUMP",
                isControllerOn: false,
                controllerColor: squeezeButtonColor,
                precentValue: squeezePrecentValue,
                setValue: "",
                isPourContent: false,
                buttonLabel: squeezeButtonLabel,
                onIncreament: () {},
                onDecreament: () {},
                onPress: onSqueezePress,
                onIncLongPressStart: (_) {},
                onDecLongPressStart: (_) {},
                onLongPressEnd: (_) {},
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screen_height * 1),
        ],
      ),
    );
  }
}
