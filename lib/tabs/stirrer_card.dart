import 'package:StirCastingMachine/calculation.dart';
import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/card_header.dart';
import 'package:StirCastingMachine/widget/controller_button.dart';
import 'package:StirCastingMachine/widget/precent_value_show.dart';
import 'package:StirCastingMachine/widget/row_header_label.dart';
import 'package:StirCastingMachine/widget/set_value_controller.dart';
import 'package:flutter/material.dart';

class StirrerCard extends StatelessWidget {
  final String stirrerButtonLabel;
  final String autoJogButtonLabel;
  final VoidCallback onStirrerPress;
  final VoidCallback onLiftUpPress;
  final VoidCallback onLiftDownPress;
  final VoidCallback onAutoJogPress;
  final Color stirrerButtonColor;
  final Color liftUpButtonColor;
  final Color liftDownButtonColor;
  final Color autoJogButtonColor;
  final String stirrerPrecentValue;
  final String liftPos;
  final String stirrerSetValue;
  final String autoJogSetValue;
  final VoidCallback onStirrerIncreament;
  final VoidCallback onAutoJogIncreament;
  final VoidCallback onStirrerDecreament;
  final VoidCallback onAutoJogDecreament;
  final Function(dynamic) onStirrerIncLongPressStart;
  final Function(dynamic) onAutoJogIncLongPressStart;
  final Function(dynamic) onStirrerDecLongPressStart;
  final Function(dynamic) onAutoJogDecLongPressStart;
  final Function(dynamic) onLiftUpLongPressStart;
  final Function(dynamic) onLiftDownLongPressStart;
  final Function(dynamic) onLongPressEnd;
  final Function(dynamic) onLiftUpLongPressEnd;
  final Function(dynamic) onLiftDownLongPressEnd;
  final Calculation calc;

  StirrerCard({
    Key key,
    @required this.stirrerButtonLabel,
    @required this.autoJogButtonLabel,
    @required this.stirrerPrecentValue,
    @required this.liftPos,
    @required this.stirrerSetValue,
    @required this.autoJogSetValue,
    @required this.onStirrerPress,
    @required this.onLiftUpPress,
    @required this.onLiftDownPress,
    @required this.onAutoJogPress,
    @required this.calc,
    @required this.stirrerButtonColor,
    @required this.liftUpButtonColor,
    @required this.liftDownButtonColor,
    @required this.autoJogButtonColor,
    this.onStirrerIncreament,
    this.onAutoJogIncreament,
    this.onStirrerDecreament,
    this.onAutoJogDecreament,
    this.onStirrerIncLongPressStart,
    this.onAutoJogIncLongPressStart,
    this.onStirrerDecLongPressStart,
    this.onAutoJogDecLongPressStart,
    this.onLiftUpLongPressStart,
    this.onLiftDownLongPressStart,
    this.onLongPressEnd,
    this.onLiftUpLongPressEnd,
    this.onLiftDownLongPressEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CardHeader(cardTitle: "STIRRER", subTitle: ""),
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
              TableRow(
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(left: 10.0),
                    margin: const EdgeInsets.all(5.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                            fontSize: SizeConfig.font_height * 2,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '1) SPEED\n',
                            ),
                            TextSpan(
                              text: '           (RPM)',
                              style: TextStyle(
                                fontSize: SizeConfig.font_height * 1.5, //13
                                fontWeight: FontWeight.normal,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  PrecentValueShow(precentValue: stirrerPrecentValue),
                  SetValueController(
                    setValue: stirrerSetValue,
                    onIncreament: onStirrerIncreament,
                    onDecreament: onStirrerDecreament,
                    onIncLongPressStart: onStirrerIncLongPressStart,
                    onDecLongPressStart: onStirrerDecLongPressStart,
                    onLongPressEnd: onLongPressEnd,
                  ),
                  ControllerButton(
                    buttonColor: stirrerButtonColor,
                    buttonLabel: stirrerButtonLabel,
                    onPress: onStirrerPress,
                  ),
                ],
              ),
              TableRow(
                children: [
                  RowHeaderLabel(rowTitle: "2) LIFT POS"),
                  PrecentValueShow(precentValue: liftPos),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: ControllerButton(
                      buttonLabel: "UP",
                      onPress: onLiftUpPress,
                      buttonColor: liftUpButtonColor,
                      onLongPressStart: onLiftUpLongPressStart,
                      onLongPressEnd: onLiftUpLongPressEnd,
                    ),
                  ),
                  ControllerButton(
                    buttonLabel: "DOWN",
                    buttonColor: liftDownButtonColor,
                    onPress: onLiftDownPress,
                    onLongPressStart: onLiftDownLongPressStart,
                    onLongPressEnd: onLiftDownLongPressEnd,
                  ),
                ],
              ),
              TableRow(
                children: [
                  RowHeaderLabel(rowTitle: "AUTO JOG"),
                  Text(""),
                  SetValueController(
                    setValue: autoJogSetValue,
                    onIncreament: onAutoJogIncreament,
                    onDecreament: onAutoJogDecreament,
                    onIncLongPressStart: onAutoJogIncLongPressStart,
                    onDecLongPressStart: onAutoJogDecLongPressStart,
                    onLongPressEnd: onLongPressEnd,
                  ),
                  ControllerButton(
                    buttonColor: autoJogButtonColor,
                    buttonLabel: autoJogButtonLabel,
                    onPress: onAutoJogPress,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
