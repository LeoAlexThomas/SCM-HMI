import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:flutter/material.dart';

class OtherCard extends StatelessWidget {
  final String? centrifugeButtonLabel;
  final String? vaccumPumpButtonLabel;
  final Color? centrifugeButtonColor;
  final Color? vaccumButtonColor;
  final String centrifugePrecentValue;
  final String centrifugeSetValue;
  final VoidCallback? onCentrifugePress;
  final VoidCallback? onVaccumPumpPress;
  final VoidCallback onCentrifugeIncreamentPress;
  final VoidCallback onCentrifugeDecreamentPress;
  final Function(dynamic) onIncCentrifugeLongPressStart;
  final Function(dynamic) onDecCentrifugeLongPressStart;
  final Function(dynamic) onLongPressEnd;
  const OtherCard({
    Key? key,
    required this.centrifugeButtonLabel,
    required this.vaccumPumpButtonLabel,
    required this.centrifugeButtonColor,
    required this.vaccumButtonColor,
    required this.centrifugePrecentValue,
    required this.centrifugeSetValue,
    required this.onCentrifugePress,
    required this.onVaccumPumpPress,
    required this.onCentrifugeIncreamentPress,
    required this.onCentrifugeDecreamentPress,
    required this.onIncCentrifugeLongPressStart,
    required this.onDecCentrifugeLongPressStart,
    required this.onLongPressEnd,
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
          CardHeader(cardTitle: "OTHERS", subTitle: ""),
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
                rowTitle: "1) CENTRIFUGE",
                isControllerOn: false,
                controllerColor: centrifugeButtonColor,
                precentValue: centrifugePrecentValue,
                setValue: centrifugeSetValue,
                buttonLabel: centrifugeButtonLabel,
                onIncreament: onCentrifugeIncreamentPress,
                onDecreament: onCentrifugeDecreamentPress,
                onPress: onCentrifugePress,
                onIncLongPressStart: onIncCentrifugeLongPressStart,
                onDecLongPressStart: onDecCentrifugeLongPressStart,
                onLongPressEnd: onLongPressEnd,
              ),
              DataContentShow.getRowContent(
                rowTitle: "2) VACCUM PUMP",
                isControllerOn: false,
                controllerColor: vaccumButtonColor,
                precentValue: "",
                setValue: "",
                buttonLabel: vaccumPumpButtonLabel,
                onIncreament: () {},
                onDecreament: () {},
                onPress: onVaccumPumpPress,
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
