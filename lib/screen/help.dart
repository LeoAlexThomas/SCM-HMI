import 'dart:io';

import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HelpTab extends StatefulWidget {
  final String helpFilePath;
  HelpTab({Key key, @required this.helpFilePath}) : super(key: key);

  @override
  State<HelpTab> createState() => _HelpTabState();
}

class _HelpTabState extends State<HelpTab> {
  bool _b_software = false;
  bool _b_machine = false;
  int _helptabIndex = 0;

  bool b_helpWifiTab = false;
  bool b_helpBluetoothTab = false;
  bool b_helpSerialPortTab = false;

  Widget wifiConnectionPDF;
  Widget bluetoothConnectionPDF;
  Widget serialportConnectionPDF;

  Widget prequisitesPDF;
  Widget technicalPDF;
  Widget operationPDF;
  Widget attachmentsPDF;
  Widget safetyPDF;
  Widget faqsPDF;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                right: SizeConfig.screen_width * 2,
              ),
              height: SizeConfig.screen_height * 10, //60
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: SizeConfig.screen_height * 1,
                      bottom: SizeConfig.screen_height * 1,
                      left: SizeConfig.screen_width * 0.75,
                      right: SizeConfig.screen_width * 0.75,
                    ),
                    color: AppColors.headbgColor,
                    padding: EdgeInsets.only(
                      top: SizeConfig.screen_height * 1,
                      bottom: SizeConfig.screen_height * 1,
                      left: SizeConfig.screen_width * 1,
                      right: SizeConfig.screen_width * 1,
                    ),
                    child: Text(
                      'HELP',
                      style: TextStyle(
                        fontSize: SizeConfig.font_height * 2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Ver #1.0.0.0',
                    style: TextStyle(
                        fontSize: SizeConfig.font_height * 1.75,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    right: SizeConfig.screen_width * 0.75,
                    left: SizeConfig.screen_width * 0.75,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.screen_height * 1,
                    horizontal: SizeConfig.screen_width * 1,
                  ),
                  width: SizeConfig.screen_width * 16, //170
                  height: SizeConfig.screen_height * 75, //600
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.black,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    color: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedCrossFade(
                          firstChild: GestureDetector(
                            onTap: () {
                              setState(() {
                                _b_machine = false;
                                _b_software = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.screen_height * 1,
                                bottom: SizeConfig.screen_height * 1,
                              ),
                              width: double.infinity,
                              height: SizeConfig.screen_height * 4.5,
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.screen_height * 0.25,
                                horizontal: SizeConfig.screen_width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.black,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color:
                                    (_helptabIndex == 1) || (_helptabIndex == 2)
                                        ? Colors.blue[300]
                                        : AppColors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'Software',
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.font_height * 2.65, //20
                                  ),
                                ),
                              ),
                            ),
                          ),
                          secondChild: Container(
                            width: double.infinity,
                            // height: SizeConfig.screen_height * 20,
                            padding: EdgeInsets.only(
                              top: SizeConfig.screen_height * 0.25,
                              bottom: SizeConfig.screen_height * 0.25,
                              left: SizeConfig.screen_width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.black,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Software',
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.font_height * 2.65, //20
                                  ),
                                ),
                                ListTile(
                                  selected: _helptabIndex == 1,
                                  title: Text(
                                    'Connectivity',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () async {
                                    _b_software = false;
                                    setState(() {
                                      _helptabIndex = 1;
                                    });
                                    ;
                                  },
                                ),
                                ListTile(
                                  selected: _helptabIndex == 2,
                                  title: Text(
                                    'Interface',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () {
                                    _b_software = false;
                                    setState(() {
                                      _helptabIndex = 2;
                                    });
                                    ;
                                  },
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: _b_software
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 500),
                        ),
                        AnimatedCrossFade(
                          firstChild: GestureDetector(
                            onTap: () {
                              setState(() {
                                _b_software = false;
                                _b_machine = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                top: SizeConfig.screen_height * 1,
                                bottom: SizeConfig.screen_height * 1,
                              ),
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                top: SizeConfig.screen_height * 0.25,
                                bottom: SizeConfig.screen_height * 0.25,
                                left: SizeConfig.screen_width * 0.75,
                                right: SizeConfig.screen_width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.black,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                                color: (_helptabIndex == 3) ||
                                        (_helptabIndex == 4) ||
                                        (_helptabIndex == 5) ||
                                        (_helptabIndex == 6) ||
                                        (_helptabIndex == 7)
                                    ? Colors.blue[300]
                                    : AppColors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'Machine',
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.font_height * 2.65, //20
                                  ),
                                ),
                              ),
                            ),
                          ),
                          secondChild: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                              top: SizeConfig.screen_height * 0.25,
                              bottom: SizeConfig.screen_height * 0.25,
                              left: SizeConfig.screen_width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.black,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Machine',
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.font_height * 2.65, //20
                                  ),
                                ),
                                ListTile(
                                  selected: _helptabIndex == 3,
                                  title: Text(
                                    'Prequisites',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () async {
                                    if (!(_helptabIndex == 3)) {
                                      _b_machine = false;
                                      File pdfFile = File(
                                          '${widget.helpFilePath}/1_SCM_M_Prerequisites.pdf');
                                      prequisitesPDF =
                                          PDFView(filePath: pdfFile.path);
                                      setState(() {
                                        _helptabIndex = 3;
                                      });
                                    }
                                  },
                                ),
                                ListTile(
                                  selected: _helptabIndex == 4,
                                  title: Text(
                                    'Technical Details',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () async {
                                    _b_machine = false;
                                    File pdfFile = File(
                                        '${widget.helpFilePath}/2_SCM_M_TechnicalDetails.pdf');
                                    technicalPDF =
                                        PDFView(filePath: pdfFile.path);
                                    setState(() {
                                      _helptabIndex = 4;
                                    });
                                    ;
                                  },
                                ),
                                ListTile(
                                  selected: _helptabIndex == 5,
                                  title: Text(
                                    'Operation',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () async {
                                    _b_machine = false;
                                    File pdfFile = File(
                                        '${widget.helpFilePath}/3_SCM_M_OperatingInstruction.pdf');
                                    operationPDF =
                                        PDFView(filePath: pdfFile.path);
                                    setState(() {
                                      _helptabIndex = 5;
                                    });
                                    ;
                                  },
                                ),
                                ListTile(
                                  selected: _helptabIndex == 6,
                                  title: Text(
                                    'Attachments',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () async {
                                    _b_machine = false;

                                    File pdfFile = File(
                                        '${widget.helpFilePath}/4_SCM_M_Attachments.pdf');
                                    attachmentsPDF =
                                        PDFView(filePath: pdfFile.path);
                                    setState(() {
                                      _helptabIndex = 6;
                                    });
                                    ;
                                  },
                                ),
                                ListTile(
                                  selected: _helptabIndex == 7,
                                  title: Text(
                                    'Safety',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                    ),
                                  ),
                                  onTap: () async {
                                    _b_machine = false;
                                    File pdfFile = File(
                                        '${widget.helpFilePath}/5_SCM_M_Safety_Instructions.pdf');
                                    safetyPDF = PDFView(filePath: pdfFile.path);
                                    setState(() {
                                      _helptabIndex = 7;
                                    });
                                    ;
                                  },
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: _b_machine
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: Duration(milliseconds: 500),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.screen_height * 1,
                            bottom: SizeConfig.screen_height * 1,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: SizeConfig.screen_height * 8, //75
                            child: OutlineButton(
                              onPressed: () async {
                                File pdfFile = File(
                                    '${widget.helpFilePath}/6_SCM_M_FAQ.pdf');
                                faqsPDF = PDFView(filePath: pdfFile.path);
                                setState(() {
                                  _helptabIndex = 8;
                                });
                                ;
                              },
                              child: Text(
                                'FAQs',
                                style: TextStyle(
                                    fontSize: SizeConfig.font_height * 2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashColor: AppColors.customRed,
                            ),
                          ),
                        ),
                        Container(
                          child: SizedBox(
                            width: double.infinity,
                            height: SizeConfig.screen_height * 8, //75
                            child: OutlineButton(
                              onPressed: () => setState(() {
                                _helptabIndex = 9;
                              }),
                              child: Text(
                                'Support',
                                style: TextStyle(
                                    fontSize: SizeConfig.font_height * 2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              splashColor: AppColors.customRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: SizeConfig.screen_width * 65, //880
                  height: SizeConfig.screen_height * 75, //600
                  child: helpSwitchTabs(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget helpSwitchTabs() {
    if (_helptabIndex == 1)
      return helpConnectivityTab();
    else if (_helptabIndex == 2)
      return helpInterfaceTab();
    else if (_helptabIndex == 3)
      return helpPrequisitesTab();
    else if (_helptabIndex == 4)
      return helpTechnicalDetailsTab();
    else if (_helptabIndex == 5)
      return helpOperationTab();
    else if (_helptabIndex == 6)
      return helpAttachmentsTab();
    else if (_helptabIndex == 7)
      return helpSafetyTab();
    else if (_helptabIndex == 8)
      return helpFAQ();
    else
      return helpSupport();
  }

  Widget helpConnectivityTab() {
    return Container(
      margin: EdgeInsets.only(
        right: SizeConfig.screen_width * 0.5,
        left: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      width: SizeConfig.screen_width * 25, //780
      height: SizeConfig.screen_height * 28, //600
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TabBar(
              onTap: (value) async {
                if (value == 1) {
                  File pdfFile =
                      File('${widget.helpFilePath}/wifi_connection.pdf');
                  wifiConnectionPDF = PDFView(filePath: pdfFile.path);
                  // wifiConnectionPDF = await PDFView(
                  //     filePath: 'assets/docs/wifi_connection.pdf');
                } else {
                  File pdfFile =
                      File('${widget.helpFilePath}/bluetooth_connection.pdf');
                  bluetoothConnectionPDF = PDFView(filePath: pdfFile.path);
                  // bluetoothConnectionPDF = await PDFView(
                  //     filePath: 'assets/docs/bluetooth_connection.pdf');
                }
              },
              tabs: [
                Container(
                  color: b_helpWifiTab ? AppColors.blue : AppColors.white,
                  child: Text(
                    'WIFI Connectivity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2.2, //16
                      color: b_helpWifiTab ? AppColors.white : AppColors.black,
                    ),
                  ),
                ),
                Container(
                  color: b_helpBluetoothTab ? AppColors.blue : AppColors.white,
                  child: Text(
                    'Bluetooth Connectivity',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2.2, //16
                      color: b_helpBluetoothTab
                          ? AppColors.white
                          : AppColors.black,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  helpTabView(wifiConnectionPDF),
                  helpTabView(bluetoothConnectionPDF),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget helpTabView(Widget child) {
    return Container(
      // color: Red,
      width: SizeConfig.screen_width * 65, //780
      height: SizeConfig.screen_height * 68, //540
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.screen_height * 1,
        horizontal: SizeConfig.screen_width * 1,
      ),
      child: wifiConnectionPDF,
    );
  }

  Widget helpBluetoothTab() {
    return Container(
      // color: Red,
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      child: bluetoothConnectionPDF,
    );
  }

  Widget helpSerialPortTab() {
    return Container(
      // color: Red,
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      child: serialportConnectionPDF,
    );
  }

  Widget helpInterfaceTab() {
    return Container(
      margin: EdgeInsets.only(
        right: SizeConfig.screen_width * 0.5,
        left: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: SizeConfig.screen_height * 0.25,
              bottom: SizeConfig.screen_height * 0.25,
              left: SizeConfig.screen_width * 0.25,
              right: SizeConfig.screen_width * 0.25,
            ),
            decoration: BoxDecoration(
              color: AppColors.headbgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              'Interface',
              style: TextStyle(
                fontSize: SizeConfig.font_height * 2.65, //20
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Container(
            // color: Blue,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1,
                    bottom: SizeConfig.screen_height * 1,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 8,
                  ),
                  child: Text(
                    'Images',
                    style: TextStyle(
                        fontSize: SizeConfig.font_height * 2,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'Details',
                  style: TextStyle(
                      fontSize: SizeConfig.font_height * 2,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            // color: Red,
            width: SizeConfig.screen_width * 90, //860
            height: SizeConfig.screen_height * 64, //468
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: SizeConfig.screen_width * 90, //860
                  height: SizeConfig.screen_height * 64, //468
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Image.asset(
                            'assets/images/exit.jpg',
                            width: SizeConfig.screen_width * 8, //100
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text('To exit from Application.'),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/conection_interface.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'This is the Connection Interface. When Connection Lost between machine and application.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/main_off.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'Press this button to Turn OFF machine. When the machine is in OFF state application cannot be usable.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/main_on.jpeg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'Press this button to Turn On machine. Application only usable when the machine is ON.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/controller_disabled.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'When machine is in OFF State. Button Controllers are disabled.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/controller_enable.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'When the machine is in ON. Button Controllers are enabled.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/present_value.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'It represents the current values of the machine.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/set_value.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                              width: SizeConfig.screen_width * 51,
                              child:
                                  Text('This section for user to set values')))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_not_started.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'It represents the record is not started yet.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_started.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'This represents application starts recording.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Text(''),
                          ),
                          DataCell(Container(
                              width: SizeConfig.screen_width * 51,
                              child: Text(
                                  'Below Ecah Record Title are explained.')))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_time.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'In this record section will display the time of the data recorded.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_melt.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'In this record section will display the melting temprature of the metal.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_powder.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'In this record section will display the temprature of the powder.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_mould.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'In this record section will display the temprature of the mould.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_stir.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'In this record section will display the RPM speed of the Stirrer.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_pour.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'In this record section will display whether the pour valve is OPEN or CLOSE.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_clean.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'This button is use for clear the record section.'),
                          ))
                        ]),
                        DataRow(cells: [
                          DataCell(
                            Image.asset(
                              'assets/images/Record_Export.jpg',
                              width: SizeConfig.screen_width * 8, //100
                            ),
                          ),
                          DataCell(Container(
                            width: SizeConfig.screen_width * 51,
                            child: Text(
                                'When you press Export record will exported to "internalStorage/Android/data/com.android.StirCastingMachine/files/SCM-Export_Date_Time.xls".'),
                          ))
                        ]),
                      ],
                      dataRowHeight: SizeConfig.screen_height * 6, //40
                      headingRowHeight: SizeConfig.screen_height * 6, //40
                      columnSpacing: SizeConfig.screen_width * 4.5, //20
                      headingTextStyle: TextStyle(
                          fontSize: SizeConfig.font_height * 2,
                          fontWeight: FontWeight.normal,
                          color: AppColors.black),
                      dataTextStyle: TextStyle(
                          fontSize: SizeConfig.font_height * 2,
                          fontWeight: FontWeight.normal,
                          color: AppColors.black),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget helpPrequisitesTab() {
    return Container(
      child: Container(
        margin: EdgeInsets.only(
          right: SizeConfig.screen_width * 0.5,
          left: SizeConfig.screen_width * 0.5,
        ),
        padding: EdgeInsets.only(
          top: SizeConfig.screen_height * 1,
          bottom: SizeConfig.screen_height * 1,
          left: SizeConfig.screen_width * 1,
          right: SizeConfig.screen_width * 1,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.black,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: prequisitesPDF,
      ),
    );
  }

  Widget helpTechnicalDetailsTab() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          right: SizeConfig.screen_width * 0.5,
          left: SizeConfig.screen_width * 0.5,
        ),
        padding: EdgeInsets.only(
          top: SizeConfig.screen_height * 1,
          bottom: SizeConfig.screen_height * 1,
          left: SizeConfig.screen_width * 1,
          right: SizeConfig.screen_width * 1,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.black,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: technicalPDF,
      ),
    );
  }

  Widget helpOperationTab() {
    return Container(
      margin: EdgeInsets.only(
        right: SizeConfig.screen_width * 0.5,
        left: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Center(
        child: operationPDF,
      ),
    );
  }

  Widget helpAttachmentsTab() {
    return Container(
      margin: EdgeInsets.only(
        right: SizeConfig.screen_width * 0.5,
        left: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Container(
        child: attachmentsPDF,
      ),
    );
  }

  Widget helpSafetyTab() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: safetyPDF,
    );
  }

  Widget helpFAQ() {
    return Container(
      margin: EdgeInsets.only(
        right: SizeConfig.screen_width * 0.5,
        left: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      width: SizeConfig.screen_width * 1.45, //780
      height: SizeConfig.screen_height * 1.28, //600
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: SizeConfig.screen_height * 4,
            padding: EdgeInsets.only(
              top: SizeConfig.screen_height * 0.25,
              bottom: SizeConfig.screen_height * 0.25,
              left: SizeConfig.screen_width * 0.75,
              right: SizeConfig.screen_width * 0.75,
            ),
            decoration: BoxDecoration(
              color: AppColors.headbgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              'FAQs',
              style: TextStyle(
                fontSize: SizeConfig.font_height * 2.65, //20
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: SizeConfig.screen_height * 65,
            child: faqsPDF,
          ),
        ],
      ),
    );
  }

  Widget helpSupport() {
    return Container(
      margin: EdgeInsets.only(
        right: SizeConfig.screen_width * 0.5,
        left: SizeConfig.screen_width * 0.5,
      ),
      padding: EdgeInsets.only(
        top: SizeConfig.screen_height * 1,
        bottom: SizeConfig.screen_height * 1,
        left: SizeConfig.screen_width * 1,
        right: SizeConfig.screen_width * 1,
      ),
      width: SizeConfig.screen_width * 1.45, //780
      height: SizeConfig.screen_height * 1.28, //600
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: SizeConfig.screen_height * 0.25,
              bottom: SizeConfig.screen_height * 0.25,
              left: SizeConfig.screen_width * 0.75,
              right: SizeConfig.screen_width * 0.75,
            ),
            decoration: BoxDecoration(
              color: AppColors.headbgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: SizeConfig.font_height * 2.65, //20
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Container(
            width: SizeConfig.screen_width * 35,
            height: SizeConfig.screen_height * 17,
            margin: EdgeInsets.only(
              top: SizeConfig.screen_height * 2,
              bottom: SizeConfig.screen_height * 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown),
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  // color: Red,
                  margin: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.2,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 2,
                    bottom: SizeConfig.screen_height * 1.5,
                  ),
                  width: SizeConfig.screen_width * 30,
                  height: SizeConfig.screen_height * 3.5,
                  child: Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.2,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 2,
                    bottom: SizeConfig.screen_height * 1.5,
                  ),
                  width: SizeConfig.screen_width * 28,
                  height: SizeConfig.screen_height * 5,
                  child: Text(
                    'swamequipchennai@gmail.com',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.2,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 2,
                    bottom: SizeConfig.screen_height * 1.5,
                  ),
                  width: SizeConfig.screen_width * 28,
                  height: SizeConfig.screen_height * 5,
                  child: Text(
                    'info@swamequip.in',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: SizeConfig.screen_width * 35,
            height: SizeConfig.screen_height * 17,
            margin: EdgeInsets.only(
              top: SizeConfig.screen_height * 2,
              bottom: SizeConfig.screen_height * 2,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.brown),
              borderRadius: BorderRadius.circular(10.0),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  // color: Red,
                  margin: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.2,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 2,
                    bottom: SizeConfig.screen_height * 1.5,
                  ),
                  width: SizeConfig.screen_width * 30,
                  height: SizeConfig.screen_height * 3.5,
                  child: Text(
                    'Tel: ',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.2,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 2,
                    bottom: SizeConfig.screen_height * 1.5,
                  ),
                  width: SizeConfig.screen_width * 28,
                  height: SizeConfig.screen_height * 5,
                  child: Text(
                    '+91-9962063360 (whatsapp)',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.2,
                    left: SizeConfig.screen_width * 2,
                    right: SizeConfig.screen_width * 2,
                    bottom: SizeConfig.screen_height * 1.5,
                  ),
                  width: SizeConfig.screen_width * 28,
                  height: SizeConfig.screen_height * 5,
                  child: Text(
                    '+91-9176413604',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
