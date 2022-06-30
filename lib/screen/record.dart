import 'dart:async';

import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/local_storage.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordScreen extends StatefulWidget {
  final bool isConnected;
  final bool isMainOn;
  final bool isDebug;
  final bool isPourOpen;
  final bool isVaccumOn;
  final bool isGasAvaible;
  final bool isCentrifugeAvaible;
  final bool isSqueezeAvaible;
  final bool isVaccumAvaible;
  final int melt;
  final int powder;
  final int mould;
  final int stirrer;
  final int gasFlow;
  final int centrifuge;
  final int sqzPresure;
  RecordScreen({
    Key? key,
    required this.isConnected,
    required this.isMainOn,
    required this.isDebug,
    required this.isPourOpen,
    required this.isVaccumOn,
    required this.isGasAvaible,
    required this.isCentrifugeAvaible,
    required this.isSqueezeAvaible,
    required this.isVaccumAvaible,
    required this.melt,
    required this.powder,
    required this.mould,
    required this.stirrer,
    required this.gasFlow,
    required this.centrifuge,
    required this.sqzPresure,
  }) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final recordFile = RecordStorage();
  final ScrollController recordScrollController = ScrollController();
  List<TableRow> rxdList = [];

  late Timer recordTimerEvent;
  bool b_start_record = false;
  String? _tableTimer;
  int d_table_sino = 0;
  List<String> recordTimer = [
    '1 Sec',
    '3 Sec',
    '5 Sec',
    '10 Sec',
    '30 Sec',
    '1 Min',
    '5 Min',
    '10 Min'
  ];
  List excelFileContent = [
    [
      'Si_No',
      'Time',
      'Melt',
      'Powder',
      'Mould',
      'Stirrer',
      'Gas',
      'Pour',
      'Squeeze',
      'Vaccum'
    ]
  ];

  @override
  void dispose() {
    recordScrollController.dispose();
    super.dispose();
  }

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
              controller: recordScrollController,
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
                        if (b_start_record) _updateTimer(_tableTimer!);
                      }
                    : null,
                buttonLabel: b_start_record ? 'Stop Record' : 'Start Record',
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
                            onChanged: b_start_record
                                ? null
                                : _updateTimer as void Function(String?)?,
                          ),
                        ),
                      ),
                      _buildButton(
                        buttonLabel: 'CLEAN',
                        buttonColor: AppColors.blue,
                        onPressed: () {
                          setState(
                            () {
                              d_table_sino = 0;
                              rxdList = [];
                              excelFileContent = [
                                [
                                  'Si_No',
                                  'Time',
                                  'Melt',
                                  'Powder',
                                  'Mould',
                                  'Stirrer',
                                  'Gas',
                                  'Pour',
                                  'Squeeze',
                                  'Vaccum'
                                ]
                              ];
                            },
                          );
                        },
                      ),
                      _buildButton(
                        buttonLabel: 'EXPORT',
                        buttonColor: AppColors.blue,
                        onPressed: () {
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
                              recordFile.exportFile(content);
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text('Exported'),
                                );
                              },
                            );
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

  void _updateTimer(String value) {
    setState(() {
      _tableTimer = value;
      switch (_tableTimer) {
        case '1 Sec':
          recordTimerEvent.cancel();
          timerRestart(1000);
          break;
        case '3 Sec':
          recordTimerEvent.cancel();
          timerRestart(3000);
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
        case '10 Min':
          recordTimerEvent.cancel();
          timerRestart(1000000);
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
    if (widget.isDebug) {
      d_table_sino++;
      rxdList.add(
        TableRow(
          children: [
            _tableChildRow(d_table_sino.toString()),
            _tableChildRow(rxtime),
            _tableChildRow(widget.melt.toString()),
            _tableChildRow(widget.powder.toString()),
            _tableChildRow(widget.mould.toString()),
            _tableChildRow(widget.stirrer.toString()),
            _tableChildRow(widget.isPourOpen ? 'OPEN' : 'CLOSE'),
            if (widget.isGasAvaible) _tableChildRow(widget.gasFlow.toString()),
            if (widget.isVaccumAvaible)
              _tableChildRow(widget.isVaccumOn ? 'ON' : 'OFF'),
            if (widget.isCentrifugeAvaible)
              _tableChildRow(widget.centrifuge.toString()),
            if (widget.isSqueezeAvaible)
              _tableChildRow(widget.sqzPresure.toString()),
          ],
        ),
      );

      excelFileContent.add([
        d_table_sino,
        rxtime,
        widget.melt,
        widget.powder,
        widget.mould,
        widget.stirrer,
        widget.gasFlow,
        widget.isPourOpen ? 'ON' : 'OFF',
        widget.sqzPresure,
        widget.isVaccumOn ? 'ON' : 'OFF'
      ]);
    }
    recordScrollController
        .jumpTo(recordScrollController.position.maxScrollExtent);
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
        _buildTableHeaderCell('MELT'),
        _buildTableHeaderCell('POWDER'),
        _buildTableHeaderCell('MOULD'),
        _buildTableHeaderCell('STIR'),
        _buildTableHeaderCell('POUR'),
        if (widget.isGasAvaible) _buildTableHeaderCell('GAS'),
        if (widget.isVaccumAvaible) _buildTableHeaderCell('VAC'),
        if (widget.isCentrifugeAvaible) _buildTableHeaderCell('CENT'),
        if (widget.isSqueezeAvaible) _buildTableHeaderCell('SQZ'),
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
