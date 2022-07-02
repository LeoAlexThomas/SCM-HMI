import 'dart:async';

import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/local_storage.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataLogger extends StatefulWidget {
  final bool isConnected;
  final bool isMainOn;
  final int tempA;
  final int tempB;
  final int tempC;
  final int tempD;
  final Function(bool) onDataLoggerStart;
  DataLogger({
    Key? key,
    required this.isConnected,
    required this.isMainOn,
    required this.tempA,
    required this.tempB,
    required this.tempC,
    required this.tempD,
    required this.onDataLoggerStart,
  }) : super(key: key);

  @override
  State<DataLogger> createState() => _DataLoggerState();
}

class _DataLoggerState extends State<DataLogger> {
  final dataLoggerFile = DataLoggerStorage();
  final ScrollController dataLogScrollController = ScrollController();
  List<TableRow> rxdList = [];

  @override
  void dispose() {
    dataLogScrollController.dispose();
    super.dispose();
  }

  late Timer recordTimerEvent;
  bool b_start_record = false;
  String? _tableTimer;
  int d_table_sino = 0;
  List<String> recordTimer = [
    '1 Sec',
    '5 Sec',
    '10 Sec',
    '30 Sec',
    '1 Min',
    '5 Min',
  ];
  List excelFileContent = [
    [
      'Si_No',
      'Temp A',
      'Temp B',
      'Temp C',
      'Temp D',
    ],
  ];

  Widget _buildButton({
    required String buttonLabel,
    required Color buttonColor,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        buttonLabel,
        style: TextStyle(
          fontSize: SizeConfig.font_height * 2,
          color: AppColors.white,
        ),
      ),
    );
  }

  void onResetData() {
    setState(() {
      d_table_sino = 0;
      rxdList = [];
      excelFileContent = [
        [
          'Si_No',
          'Temp A',
          'Temp B',
          'Temp C',
          'Temp D',
        ]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Table(
          children: [
            tableHeader(),
          ],
          border: TableBorder.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView(
              controller: dataLogScrollController,
              children: [
                Table(
                  border: TableBorder.all(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  children: rxdList,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: SizeConfig.screen_width * 14,
              height: SizeConfig.screen_height * 5,
              margin: EdgeInsets.only(left: SizeConfig.screen_width * 1),
              child: _buildButton(
                buttonColor: b_start_record ? AppColors.red! : AppColors.green,
                onPressed: widget.isMainOn
                    ? () {
                        setState(() {
                          b_start_record = !b_start_record;
                        });
                        if (b_start_record) _updateTimer(_tableTimer);

                        widget.onDataLoggerStart(b_start_record);
                      }
                    : null,
                buttonLabel:
                    b_start_record ? 'Stop Data Log' : 'Start Data Log',
              ),
            ),
            Stack(
              children: [
                Container(
                  width: SizeConfig.screen_width * 32.0,
                  height: SizeConfig.screen_height * 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: SizeConfig.screen_width * 7,
                        // height: SizeConfig.screen_height * 5,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: SizeConfig.font_height * 2,
                              color: AppColors.black,
                            ),
                            value: _tableTimer,
                            items: recordTimer
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: SizeConfig.font_height * 2,
                                    color: AppColors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            hint: Text('10 Sec'),
                            onChanged: _updateTimer,
                          ),
                        ),
                      ),
                      _buildButton(
                        buttonLabel: 'CLEAN',
                        buttonColor: AppColors.blue,
                        onPressed: onResetData,
                      ),
                      _buildButton(
                        buttonLabel: 'EXPORT',
                        buttonColor: AppColors.blue,
                        onPressed: () async {
                          if (excelFileContent.length == 1) {
                            SnackbarService.showMessage(
                                context, "Record is Empty");
                          } else {
                            String content = '';
                            excelFileContent.forEach((element) {
                              element.forEach((ele) {
                                content += '${ele.toString()}\t';
                              });
                              content += '\n';
                              dataLoggerFile
                                  .exportFile(content)
                                  .then((exportedFilePath) {
                                onResetData();
                                SnackbarService.showMessage(
                                  context,
                                  exportedFilePath == null
                                      ? "Data Logger File exported"
                                      : "Data Logger file exported here: $exportedFilePath",
                                );
                              });
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (b_start_record)
                  Container(
                    color: Colors.grey.shade200,
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _updateTimer(String? value) {
    setState(() {
      _tableTimer = value;
      switch (_tableTimer) {
        case '1 Sec':
          recordTimerEvent.cancel();
          timerRestart(1000);
          break;
        case '5 Sec':
          recordTimerEvent.cancel();
          timerRestart(5000);
          break;
        case '10 Sec':
          recordTimerEvent.cancel();
          timerRestart(10000);
          break;
        case '30 Sec':
          recordTimerEvent.cancel();
          timerRestart(30000);
          break;
        case '1 Min':
          recordTimerEvent.cancel();
          timerRestart(100000);
          break;
        case '5 Min':
          recordTimerEvent.cancel();
          timerRestart(500000);
          break;
        default:
          timerRestart(10000);
          break;
      }
    });
  }

  Widget _tableChildRow(String childValue) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 0.5,
        bottom: SizeConfig.screen_height * 0.5,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        childValue,
        style: TextStyle(
          fontSize: SizeConfig.font_height * 2,
        ),
      ),
    );
  }

  addToRecord() {
    String rxtime = DateFormat('kk:mm:ss').format(DateTime.now());
    d_table_sino++;
    rxdList.add(
      TableRow(
        children: [
          _tableChildRow(d_table_sino.toString()),
          _tableChildRow(rxtime),
          _tableChildRow(widget.tempA.toString()),
          _tableChildRow(widget.tempB.toString()),
          _tableChildRow(widget.tempC.toString()),
          _tableChildRow(widget.tempD.toString()),
        ],
      ),
    );

    excelFileContent.add([
      d_table_sino,
      rxtime,
      widget.tempA,
      widget.tempB,
      widget.tempC,
      widget.tempD,
    ]);

    dataLogScrollController
        .jumpTo(dataLogScrollController.position.maxScrollExtent);
  }

  Widget _buildTableHeaderCell(String title) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 0.5,
        bottom: SizeConfig.screen_height * 0.5,
      ),
      width: double.infinity,
      color: Colors.blue,
      child: Text(
        title,
        style: TextStyle(
          fontSize: SizeConfig.font_height * 2,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  TableRow tableHeader() {
    return TableRow(
      children: [
        _buildTableHeaderCell('#'),
        _buildTableHeaderCell('TIME'),
        _buildTableHeaderCell('TEMP A'),
        _buildTableHeaderCell('TEMP B'),
        _buildTableHeaderCell('TEMP C'),
        _buildTableHeaderCell('TEMP D'),
      ],
    );
  }

  void timerRestart(int _timer) {
    recordTimerEvent = Timer.periodic(Duration(milliseconds: _timer), (t) {
      if (widget.isConnected) {
        if (excelFileContent.length == 0) {
          excelFileContent.add(tableHeader());
        }
        if (b_start_record) {
          addToRecord();
        }
      }
    });
  }
}
