import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:StirCastingMachine/widget/controller_button.dart';
import 'package:StirCastingMachine/widget/precent_value_show.dart';
import 'package:StirCastingMachine/widget/row_header_label.dart';
import 'package:StirCastingMachine/widget/set_value_controller.dart';
import 'package:flutter/material.dart';

class InertAtmosphere extends StatelessWidget {
  final String gasFlowPrescentValue;
  final String gasFlowSetValue;
  final String gas1SetValue;
  final String gas2SetValue;
  final bool isPourShieldOpen;
  final VoidCallback onGasFlowIncreasePress;
  final VoidCallback onGasFlowDecreasePress;
  final VoidCallback onGas1IncreasePress;
  final VoidCallback onGas1DecreasePress;
  final VoidCallback onGas2IncreasePress;
  final VoidCallback onGas2DecreasePress;
  final VoidCallback? inertGasPress;
  final String? buttonLabel;
  final Color? buttonColor;
  const InertAtmosphere({
    Key? key,
    required this.gasFlowPrescentValue,
    required this.gasFlowSetValue,
    required this.gas1SetValue,
    required this.gas2SetValue,
    required this.isPourShieldOpen,
    required this.onGasFlowIncreasePress,
    required this.onGasFlowDecreasePress,
    required this.onGas1IncreasePress,
    required this.onGas1DecreasePress,
    required this.onGas2IncreasePress,
    required this.onGas2DecreasePress,
    required this.inertGasPress,
    required this.buttonLabel,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: SizeConfig.screen_height * 1),
      margin: EdgeInsets.symmetric(vertical: SizeConfig.screen_height * 1),
      child: Column(
        children: [
          CardHeader(cardTitle: "INERT ATMOSPHERE", subTitle: ''),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FixedColumnWidth(SizeConfig.screen_width * 12),
              1: FixedColumnWidth(SizeConfig.screen_width * 6),
              2: FixedColumnWidth(SizeConfig.screen_width * 15),
              3: FixedColumnWidth(SizeConfig.screen_width * 4),
            },
            defaultColumnWidth: FixedColumnWidth(2),
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
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'SET',
                      style: TextStyle(
                        fontSize: SizeConfig.font_height * 2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.headbgColor,
                      ),
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RowHeaderLabel(rowTitle: "1) GAS FLOW"),
                  ),
                  PrecentValueShow(precentValue: gasFlowPrescentValue),
                  SetValueController(
                    setValue: gasFlowSetValue,
                    onIncreament: onGasFlowIncreasePress,
                    onDecreament: onGasFlowDecreasePress,
                    onIncLongPressStart: (_) {},
                    onDecLongPressStart: (_) {},
                    onLongPressEnd: (_) {},
                  ),
                  Text(
                    "LPM",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RowHeaderLabel(rowTitle: "2) GAS-1: AR"),
                  ),
                  const SizedBox.shrink(),
                  SetValueController(
                    setValue: gas1SetValue,
                    onIncreament: onGas1IncreasePress,
                    onDecreament: onGas1DecreasePress,
                    onIncLongPressStart: (_) {},
                    onDecLongPressStart: (_) {},
                    onLongPressEnd: (_) {},
                  ),
                  Text(
                    "(%)",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RowHeaderLabel(rowTitle: "3) GAS2: SF6"),
                  ),
                  const SizedBox.shrink(),
                  SetValueController(
                    setValue: gas2SetValue,
                    onIncreament: onGas2IncreasePress,
                    onDecreament: onGas2DecreasePress,
                    onIncLongPressStart: (_) {},
                    onDecLongPressStart: (_) {},
                    onLongPressEnd: (_) {},
                  ),
                  Text(
                    "(%)",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: RowHeaderLabel(rowTitle: "4) POUR SHIELD"),
                  ),
                  const SizedBox.shrink(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screen_width * 1.75),
                    child: Container(
                      color: isPourShieldOpen ? AppColors.red : AppColors.green,
                      height: SizeConfig.screen_height * 5, //50
                    ),
                  ),
                  const SizedBox.shrink(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: SizeConfig.screen_width * 20,
            child: ControllerButton(
              buttonLabel: buttonLabel,
              onPress: inertGasPress,
              buttonColor: buttonColor,
            ),
          ),
          const SizedBox(height: 5),
          // Center(
          //   child: Container(
          //     width: SizeConfig.screen_width * 20, //300
          //     height: SizeConfig.screen_height * 6, //50
          //     child: RaisedButton(
          //       color: btns['btnGasFlow']['btnColor'],
          //       onPressed: inertGasPress,
          //       child: Text(
          //         buttonLabel,
          //         style: TextStyle(
          //           fontSize: SizeConfig.font_height * 2.65, //20
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
