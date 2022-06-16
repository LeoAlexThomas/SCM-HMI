import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/widget/controller_button.dart';
import 'package:StirCastingMachine/widget/precent_value_show.dart';
import 'package:StirCastingMachine/widget/row_header_label.dart';
import 'package:StirCastingMachine/widget/set_value_controller.dart';
import 'package:flutter/material.dart';

class AppColors {
  static Color blue = Color.fromRGBO(7, 103, 192, 1);
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color darkBlue = Color.fromRGBO(0, 85, 165, 1);
  static Color customRed = Color.fromRGBO(158, 0, 0, 1);
  static Color red = Colors.redAccent[700];
  static Color orange = Colors.deepOrange;
  static Color grey = Colors.grey[300];
  static Color green = Colors.green;
  static Color headbgColor = Color.fromRGBO(32, 56, 100, 1);
  static Color text_sv_color = Color.fromRGBO(32, 56, 100, 1);
  static Color appBarColor = Color.fromRGBO(7, 103, 192, 1);
}

class DataContentShow {
  static TableRow getTableHeader() {
    return TableRow(
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
    );
  }

  static TableRow getRowContent({
    @required String rowTitle,
    @required bool isControllerOn,
    @required String precentValue,
    @required String setValue,
    bool isPourContent = false,
    bool isControllerNeed = true,
    Color controllerColor = Colors.grey,
    @required String buttonLabel,
    @required VoidCallback onIncreament,
    @required VoidCallback onDecreament,
    @required VoidCallback onPress,
    @required Function(dynamic) onIncLongPressStart,
    @required Function(dynamic) onDecLongPressStart,
    @required Function(dynamic) onLongPressEnd,
  }) {
    return TableRow(
      children: [
        RowHeaderLabel(
          rowTitle: rowTitle,
          isRunning: isControllerOn,
        ),
        precentValue.isEmpty
            ? const SizedBox.shrink()
            : PrecentValueShow(precentValue: precentValue),
        setValue.isEmpty
            ? const SizedBox.shrink()
            : isPourContent
                ? Container(
                    padding: EdgeInsets.only(
                      top: SizeConfig.screen_height * 1.2,
                      bottom: SizeConfig.screen_height * 1.75,
                      left: SizeConfig.screen_width * 1.2,
                      right: SizeConfig.screen_width * 1.2,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      buttonLabel,
                      style: TextStyle(
                        fontFamily: 'digital',
                        color: AppColors.headbgColor,
                        fontSize: SizeConfig.font_height * 3.4,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                : SetValueController(
                    setValue: setValue,
                    onIncreament: onIncreament,
                    onDecreament: onDecreament,
                    onIncLongPressStart: onIncLongPressStart,
                    onDecLongPressStart: onDecLongPressStart,
                    onLongPressEnd: onLongPressEnd,
                  ),
        isControllerNeed
            ? ControllerButton(
                buttonColor: controllerColor,
                buttonLabel: buttonLabel,
                onPress: onPress,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}

class CustomTextStyle {
  static TextStyle textStyleHd() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: SizeConfig.font_height * 2,
    );
  }

  static TextStyle textStyleNr() {
    return TextStyle(
      fontSize: SizeConfig.font_height * 2,
    );
  }
}

class SnackbarService {
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}
