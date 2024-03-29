import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/screen/help.dart';
import 'package:StirCastingMachine/screen/settings.dart';
import 'package:StirCastingMachine/tabs/heater_card.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:StirCastingMachine/tabs/inert_atmosphere.dart';
import 'package:StirCastingMachine/tabs/others_card.dart';
import 'package:StirCastingMachine/tabs/pour_card.dart';
import 'package:StirCastingMachine/tabs/squeeze_card.dart';
import 'package:StirCastingMachine/tabs/stirrer_card.dart';
import 'package:StirCastingMachine/tabs/ultrasonic_card.dart';
import 'package:StirCastingMachine/widget/debug_console.dart';
import 'package:StirCastingMachine/widget/instruction_text_view.dart';
import 'package:StirCastingMachine/widget/nav_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
// for audio
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
// for local file storage
import 'package:StirCastingMachine/local_storage.dart';
// Connection package
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// Calculation
import 'package:StirCastingMachine/calculation.dart';
import 'package:marquee_text/marquee_text.dart';
// To prevent screen to go sleep mode
import 'package:wakelock/wakelock.dart';

enum SendIncreamentActionEnums {
  T1By1("T1=T1+1"),
  T1By2("T1=T1+2"),
  T1By4("T1=T1+4"),
  T1By8("T1=T1+8"),
  T2By1("T2=T2+1"),
  T2By2("T2=T2+2"),
  T2By4("T2=T2+4"),
  T2By8("T2=T2+8"),
  T3By1("T3=T3+1"),
  T3By2("T3=T3+2"),
  T3By4("T3=T3+4"),
  T3By8("T3=T3+8"),
  T4By1("T4=T4+1"),
  T4By2("T4=T4+2"),
  T4By4("T4=T4+4"),
  T4By8("T4=T4+8"),
  H1By1("H1=H1+1"),
  H1By2("H1=H1+2"),
  H1By4("H1=H1+4"),
  H1By8("H1=H1+8"),
  R1By2("R1=R1+2"),
  R1By4("R1=R1+4");

  const SendIncreamentActionEnums(this.value);
  final String value;
}

const List<SendIncreamentActionEnums> txEventsList = [
  SendIncreamentActionEnums.T1By1,
  SendIncreamentActionEnums.T1By2,
  SendIncreamentActionEnums.T1By4,
  SendIncreamentActionEnums.T1By8,
  SendIncreamentActionEnums.T2By1,
  SendIncreamentActionEnums.T2By2,
  SendIncreamentActionEnums.T2By4,
  SendIncreamentActionEnums.T2By8,
  SendIncreamentActionEnums.T3By1,
  SendIncreamentActionEnums.T3By2,
  SendIncreamentActionEnums.T3By4,
  SendIncreamentActionEnums.T3By8,
  SendIncreamentActionEnums.T4By1,
  SendIncreamentActionEnums.T4By2,
  SendIncreamentActionEnums.T4By4,
  SendIncreamentActionEnums.T4By8,
  SendIncreamentActionEnums.H1By1,
  SendIncreamentActionEnums.H1By2,
  SendIncreamentActionEnums.H1By4,
  SendIncreamentActionEnums.H1By8,
  SendIncreamentActionEnums.R1By2,
  SendIncreamentActionEnums.R1By4,
];

void main() {
  try {
    WidgetsFlutterBinding
        .ensureInitialized(); // for ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
    runApp(
      MaterialApp(
        title: 'STIR CASTING MACHINE (HMI)',
        theme: ThemeData(fontFamily: 'digital-7'),
        home: MainAppSample(),
      ),
    );
  } catch (e) {
    LogEntryStorage().writeLogfile('Exception in void main: $e');
  }
}

class MainAppSample extends StatefulWidget {
  @override
  _MainAppSampleState createState() => _MainAppSampleState();
}

class _MainAppSampleState extends State<MainAppSample> {
  //Storage objects
  var appConfigFile = AppConfigStorage();
  var recordFile = RecordStorage();
  var logFile = LogEntryStorage();
  var connectionFile = ConnectionStorage();

  bool b_wifiConnection = false;
  bool b_bluetoothConnection = false;

  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  BluetoothConnection? connection;
  var calc = Calculation();
  late Timer timer, masterTimer;
  int d_record_table_sino = 0;
  String xlsContent = '';
  List<TableRow> rxdList = [];
  List recordExcelFileContent = [
    [
      'Si_No',
      'Time',
      'Melt',
      'Powder',
      'Mould',
      'Stirrer',
      'Pour',
    ]
  ];
  String wholemsg = '';
  // DataLogger
  bool b_data_logger_start_record = false;
  List<TableRow> rxdDataLoggerList = [];
  List dataloggerExcelContent = [
    [
      'Si_No',
      'Temp A',
      'Temp B',
      'Temp C',
      'Temp D',
    ],
  ];

  // Debug scrollController
  final ScrollController rxDebugScrollController = ScrollController();
  final ScrollController txDebugScrollController = ScrollController();
  String warningText = "";

  bool b_admin_login = false;
// btn State for sending
  bool b_btn_Mains = false,
      b_btn_Furance = false,
      b_btn_Powder = false,
      b_btn_Mould = false,
      b_btn_Runway = false;
  bool b_btn_Stirrer = false,
      b_btn_Pour_Open = false,
      b_btn_Inert_Gas = false,
      b_btn_Vacuum_Pump = false,
      b_btn_PowderEMV = false,
      b_btn_EM_Vibrator = false,
      b_btn_Auto_Jog = false;

  bool b_jog_timer = false;

  bool b_btn_Sqz_Pump = false, b_btn_Centrifugal = false;
  bool b_btn_Data_Logger = false;
  bool bDataReceived = false;
  bool b_Ar = false, b_SF6 = false, b_gas_out = false;
  bool b_Show_GUI_Err_Msg = false;
  bool b_stirrer_down = false;
  //bool b_B_Gas_Out = false;
  //For pouring gas
  bool b_Start_B_Gas_Counter = false;
  int d_shield_max_time = 15;
  int d_B_Gas_idx = 0;
  bool b_B_Gas_Out = false;
  // For Heater label color
  bool b_lbl_furnace = false,
      b_lbl_powder = false,
      b_lbl_mould = false,
      b_lbl_runway = false;
  // For lift signal
  bool b_lift_pos_up = false;
  bool b_lift_pos_down = false;
  bool b_uv_lift_pos_up = false;
  bool b_uv_lift_pos_down = false;
  bool b_auto_jog_timer = false;
  // For Error
  bool errMsgMasterTimer = false;
  bool errMsgDisplaytext = false;
  bool errMsgMainScreen = false;
  bool errMsgMainlayout = false;
  bool errMsgStirrer = false;
  bool errMsgInert = false;
  bool errMsgOptional = false;
  bool errMsgRecord = false;
  bool errMsgSettings = false;
  bool errMsgHelp = false;
  bool errMsgShowDialoge = false;
  bool errMsgChangingState = false;
  bool errMsgBtnState = false;
  bool errMsgValueDecLg = false;
  bool errMsgValueIecLg = false;
  bool errMsgValueInc = false;
  bool errMsgValueDec = false;
  bool errMsgWifiCon = false;
  bool errMsgWifiTx = false;
  bool errMsgWifiRx = false;
  bool errMsgBluetoothCon = false;
  bool errMsgBluetoothPlatformCon = false;
  bool errMsgSendMsg = false;
  bool errMsgReceiveMsg = false;
  bool errMsgtransX = false;
  bool errMsgRxMsgSerial = false;
  bool errMsgStxMsgSerial = false;

  // controllers
  final _iptxtcontroller = TextEditingController();

  //Int for PV & SV
  int d_lift_jog_idx = 0;
  int d_pv_furnace = 30,
      d_pv_melt = 30,
      d_pv_powder = 30,
      d_pv_mould = 30,
      d_pv_runway = 30,
      d_pv_data_logger_temp_a = 0,
      d_pv_data_logger_temp_b = 0,
      d_pv_data_logger_temp_c = 0,
      d_pv_data_logger_temp_d = 0,
      d_pv_stirrer = 0,
      d_pv_lift_pos = 0,
      d_pv_UV_lift_pos = 0;
  int? d_pv_pour_pos;
  int d_pv_gas_flow = 0, d_pv_sqz_prsr = 0, d_pv_centrifuge = 0;
  int d_sv_furnace = 800,
      d_sv_melt = 750,
      d_sv_powder = 200,
      d_sv_mould = 200,
      d_sv_runway = 750,
      d_sv_stirrer = 450,
      d_sv_lift_pos = 0,
      d_sv_UV_lift_pos = 0;
  int d_sv_gas_flow = 2,
      d_sv_sqz_prsr = 0,
      d_sv_centrifuge = 1000,
      d_sv_gas_ar = 100,
      d_sv_gas_sf6 = 0;
  int d_rec_idx = 0;
  int dDataReceivedIndex = 0;
  int? d_stirrer_out = 1, d_centrifuge_out = 1;
  int d_stirrer_start_idx = 0;
  int d_cen_start_idx = 0;
  int? d_stirrer_min_val;
  int? d_stirrer_max_val;
  late int d_cen_min_val;
  int? d_cen_max_val;
  int? d_gas_delay;
  int? d_vacuum_delay;
  String? debugging;

  int d_sampling_rate = 2000;

  //For FURNACE
  int dFurnaceOut = 0,
      dFurnaceCounter = 0,
      dFurnaceONTime = 0,
      dFurnaceOFFTime = 0,
      dFurnaceMaxTime = 10;
  bool bFurnaceHeatOUT = false;

  //For Powder
  int dPowderOut = 0,
      dPowderCounter = 0,
      dPowderONTime = 0,
      dPowderOFFTime = 0,
      dPowderMaxTime = 6;
  bool bPowderHeatOUT = false;

  //For Mould
  int dMouldOut = 0,
      dMouldCounter = 0,
      dMouldONTime = 0,
      dMouldOFFTime = 0,
      dMouldMaxTime = 6;
  bool bMouldHeatOUT = false;

  //For Runway
  int dRunwayOut = 0,
      dRunwayCounter = 0,
      dRunwayONTime = 0,
      dRunwayOFFTime = 0,
      dRunwayMaxTime = 6;
  bool bRunwayHeatOUT = false;

  //For Gas
  int d_GAS_IDX = 1;

  // For autojog timer
  int d_sv_autojog = 2;

  // timer for long event
  late Timer t_lift_up;
  late Timer t_lift_down;
  late Timer t_uv_lift_up;
  late Timer t_uv_lift_down;

  // Buttons
  var btns = {
    'btnMain': {'btnState': 'DisConnected'},
    'btnFurnace': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnPowder': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnMold': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnRunway': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnPour': {'btnState': 'CLOSE', 'btnColor': Colors.grey[300]},
    'btnStir': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnStirUp': {'btnState': 'UP', 'btnColor': Colors.grey[300]},
    'btnStirDown': {'btnState': 'DOWN', 'btnColor': Colors.grey[300]},
    'btnAutojog': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnGasFlow': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnVaccumPump': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnCentrifuge': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnSqueezePump': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnPowderEMV': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnUV/EMV': {'btnState': 'OFF', 'btnColor': Colors.grey[300]},
    'btnUV_UP': {'btnState': 'UP', 'btnColor': Colors.grey[300]},
    'btnUV_DOWN': {'btnState': 'DOWN', 'btnColor': Colors.grey[300]},
  };

  late Socket socket;
  var sRxData = '';
  var sRxDataStart = '';
  var sRxDataMiddle = '';
  var sRxDataEnd = '';
  var txd = '';
  var rxd = '';
  bool rxcheckboxfalse = false;
  bool txcheckboxfalse = false;

  String sRxData1 = "";
  bool bDataStart = false;
  bool bDataStop = false;

  // bool isConnected = false;
  bool isConnected = true;
  int selectedIndex = 0;

  bool b_start_record = false;
  bool b_recordTimerChange = false;
  int d_ringtone_counter = 0;
  bool b_ringtone = false;
  bool b_start_autoConnect = false;

// Checkbox values
  bool b_inert_available = false;
  bool b_powder_vib_available = false;
  bool b_centrifugal_available = false;
  bool b_vacuum_available = false;
  bool b_squeeze_available = false;
  bool b_uv_vib_available = false;
  bool b_data_logger_available = false;
  bool b_data_logger_screen_available = false;

  List<Widget> rxDebugList = [];
  List<Widget> txDebugList = [];

// Configration Lists
  List? clientInfo = [];
  List? appconfig = [];
  List? gasCalValues = [];
  List? sqzCalValues = [];
  Map<String, SendIncreamentActionEnums> ioFormat = {};
  String helpFilePath = '';
  String alerm = '';

  // static const intromusic = "alert_sound/beep-13.mp3";

  // Record Info
  late Timer recordTimerEvent;
  final ScrollController recordScrollController = ScrollController();
  String? _recordTableTimer;
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

  // Receive Data Structure
  Map<String, String> rxDataStructure = {
    "furnace": "T1",
    "melt": "T2",
    "powder": "T3",
    "mould": "T4",
    "runway": "T5",
    "stirrer": "R1",
    "rotary": "R2",
    "gas": "G1",
    "squeeze": "G2",
  };

  Map<String, List<int>> rxDataPlacement = {
    "T1": [0, 1],
    "T2": [2, 3],
    "T3": [4, 5],
    "T4": [6, 7],
    "T5": [8, 9],
    "T6": [10, 11],
    "R1": [12, 13],
    "R2": [14, 15],
    "G1": [16, 17],
    "G2": [18, 19],
  };

  // Data logger Info
  final dataLoggerFile = DataLoggerStorage();
  late Timer dataLoggerTimerEvent;
  final ScrollController dataLogScrollController = ScrollController();
  String? _dataLoggerTableTimer;
  int d_data_logger_table_sino = 0;
  List<String> dataLoggerTimer = [
    '1 Sec',
    '5 Sec',
    '10 Sec',
    '30 Sec',
    '1 Min',
    '5 Min',
  ];

  @override
  void dispose() {
    Wakelock.disable();
    _iptxtcontroller.dispose();
    connection?.close();
    connection?.dispose();
    connection = null;
    rxDebugScrollController.dispose();
    txDebugScrollController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Timer.periodic(Duration(seconds: 1), (t) {
      masterTimer_Event();
    });

    recordTimerEvent = Timer.periodic(Duration(seconds: 10), (t) {
      if (isConnected) {
        if (recordExcelFileContent.length == 0) {
          addRecordToExcel([recordTableHeader()]);
        }
        if (b_start_record) {
          addToRecord();
        }
      }
    });

    dataLoggerTimerEvent = Timer.periodic(Duration(seconds: 10), (t) {
      if (isConnected) {
        if (dataloggerExcelContent.length == 0) {
          addDataLoggerToExcel([dataLoggerTableHeader()]);
        }
        if (b_data_logger_start_record) {
          DateTime now = DateTime.now();
          String rxtime = DateFormat('kk:mm:ss').format(now);
          print("Received time: $rxtime - $now");
          addToDataLogger(rxtime);
        }
      }
    });

    appConfigFile.readIOInputs().then((value) {
      if (value == null) {
        return;
      }
      ioFormat = value["txData"];
      rxDataStructure = value["rxData"];
    });

    appConfigFile.readExcelFile().then((value) {
      try {
        if ((value != null) && (value.length != 0)) {
          clientInfo = value[0];
          appconfig = value[1];
          gasCalValues = value[2];
          sqzCalValues = value[3];
          helpFilePath = value[4];
          debugging = appconfig![9];
          var model = appconfig![0].toString().padLeft(7, '0');
          if (model.substring(0, 1) == '1') {
            b_inert_available = true;
          } else {
            b_inert_available = false;
          }
          if (model.substring(1, 2) == '1') {
            b_vacuum_available = true;
          } else {
            b_vacuum_available = false;
          }
          if (model.substring(2, 3) == '1') {
            b_squeeze_available = true;
          } else {
            b_squeeze_available = false;
          }
          if (model.substring(3, 4) == '1') {
            b_centrifugal_available = true;
          } else {
            b_centrifugal_available = false;
          }
          if (model.substring(4, 5) == '1') {
            b_uv_vib_available = true;
          } else {
            b_uv_vib_available = false;
          }
          if (model.substring(5, 6) == '1') {
            b_powder_vib_available = true;
          } else {
            b_powder_vib_available = false;
          }
          if (model.substring(6, 7) == '1') {
            b_data_logger_available = true;
          } else {
            b_data_logger_available = false;
          }
          if (b_inert_available) recordExcelFileContent[0].add("Gas");
          if (b_vacuum_available) recordExcelFileContent[0].add("Vaccum");
          if (b_centrifugal_available)
            recordExcelFileContent[0].add("Centrifugal");
          if (b_squeeze_available) recordExcelFileContent[0].add("Squeeze");
          alerm = appconfig!.last.toString().toUpperCase();
          appConfigTextAssign();
        }
      } catch (e) {
        logFile.writeLogfile('Exception in reading excel: $e');
      }
    });

    // appConfigFile.result([0, 10, 20, 30, 40, 50], 25);
    // connection = null;
    connectionFile.readConnectionFile().then((value) async {
      if (value != null) {
        b_start_autoConnect = true;
        if (value[0] == '1') {
          b_wifiConnection = true;
          b_bluetoothConnection = false;
          wifiConnection(value[1]);
        } else if (value[0] == '2') {
          b_wifiConnection = false;
          b_bluetoothConnection = true;
          bluetoothConnectionWithAddress(value[1]);
        } else if (value[0] == '3') {
          b_wifiConnection = false;
          b_bluetoothConnection = false;
        }
      }
    });

    // Dummy data for record checking purpose

    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   displayText(
    //       'ccc@${new String.fromCharCodes(('03030303030000010011111111111111111111').codeUnits)}eeee');
    // });

    // Dummy data transfer for checking purpose

    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   transX();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.initSizeConfig(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SafeArea(
        child: new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.screen_height * 7),
            child: new AppBar(
              backgroundColor: AppColors.appBarColor,
              title: new Text(
                'STIR CASTING MACHINE (HMI)',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: SizeConfig.font_height * 4, //22
                ),
              ),
              actions: <Widget>[
                Container(
                  width: SizeConfig.screen_width * 10.5,
                  margin: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.5,
                    bottom: SizeConfig.screen_height * 1.5,
                    left: SizeConfig.screen_width * 0.5,
                    right: SizeConfig.screen_width * 0.5,
                  ),
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1.1,
                    bottom: SizeConfig.screen_height * 0.5,
                    left: SizeConfig.screen_width * 0.5,
                    right: SizeConfig.screen_width * 0.5,
                  ),
                  color: Colors.grey[300],
                  child: Text(
                    btns['btnMain']!['btnState'] as String,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2.65, //20
                      fontWeight: FontWeight.bold,
                      fontFamily: 'digital',
                      color: btns['btnMain']!['btnState'] == 'Connected'
                          ? AppColors.green
                          : AppColors.red,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: SizeConfig.screen_width * 9,
                    margin: EdgeInsets.only(
                      top: SizeConfig.screen_height * 1.5,
                      bottom: SizeConfig.screen_height * 1.5,
                      left: SizeConfig.screen_width * 1.0,
                      right: SizeConfig.screen_width * 1.0,
                    ),
                    padding: EdgeInsets.only(
                        right: SizeConfig.screen_width * 0.65,
                        left: SizeConfig.screen_width * 0.45),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.white),
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColors.green,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'MAINS',
                          style: TextStyle(
                            fontSize: SizeConfig.font_height * 1.8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: Container(
                            width: SizeConfig.screen_width * 3.4,
                            color: b_btn_Mains
                                ? AppColors.customRed
                                : Colors.grey[700],
                            padding: EdgeInsets.only(
                                right: SizeConfig.screen_width * 0.5,
                                left: SizeConfig.screen_width * 0.5),
                            child: Text(
                              b_btn_Mains ? 'ON' : 'OFF',
                              style: TextStyle(
                                fontSize: SizeConfig.font_height * 1.75,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (b_btn_Mains) {
                      setState(() {
                        b_btn_Mains = false;
                      });
                    } else {
                      setState(() {
                        b_btn_Mains = true;
                      });
                    }
                  },
                ),
                Container(
                  width: SizeConfig.screen_width * 8.5,
                  height: SizeConfig.screen_height * 5,
                  margin: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1,
                    bottom: SizeConfig.screen_height * 1,
                    right: SizeConfig.screen_width * 0.5,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.customRed,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        fontSize: SizeConfig.font_height * 2, //15
                        color: AppColors.white,
                      ),
                    ),
                    onPressed: () async {
                      exit(0);
                    },
                  ),
                ),
              ],
            ),
          ),
          body: mainLayout(),
        ),
      ),
    );
  }

  mainLayout() {
    try {
      return Row(
        children: [
          Container(
            //menu container
            height: SizeConfig.screen_height * 90,
            width: SizeConfig.screen_width * 15,
            color: AppColors.blue,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                NavBarItem(
                  title: 'STIR CASTING MACHINE',
                  onTap: () => setState(() {
                    selectedIndex = 0;
                  }),
                  isSeleted: selectedIndex == 0,
                ),
                NavBarItem(
                  title: 'INERT ATMOSPHERE',
                  onTap: () => b_inert_available
                      ? setState(() {
                          selectedIndex = 1;
                        })
                      : null,
                  isAvaiable: b_inert_available,
                  isSeleted: selectedIndex == 1,
                ),
                NavBarItem(
                  title: 'OPTIONAL ATTACHMENTS',
                  onTap: () => (b_squeeze_available) ||
                          (b_centrifugal_available) ||
                          (b_vacuum_available) ||
                          (b_powder_vib_available) ||
                          (b_uv_vib_available)
                      ? setState(() {
                          selectedIndex = 2;
                        })
                      : null,
                  isAvaiable: (b_squeeze_available) ||
                      (b_centrifugal_available) ||
                      (b_vacuum_available) ||
                      (b_powder_vib_available) ||
                      (b_uv_vib_available),
                  isSeleted: selectedIndex == 2,
                ),
                NavBarItem(
                  title: 'DATA LOGGER',
                  onTap: () => setState(() {
                    selectedIndex = 7;
                  }),
                  isSeleted: selectedIndex == 7,
                  isAvaiable: b_data_logger_screen_available,
                ),
                NavBarItem(
                  title: 'RECORD',
                  onTap: () => setState(() {
                    selectedIndex = 3;
                  }),
                  isSeleted: selectedIndex == 3,
                ),
                NavBarItem(
                  title: 'SETTINGS',
                  onTap: () => setState(() {
                    selectedIndex = 4;
                  }),
                  isSeleted: selectedIndex == 4,
                ),
                NavBarItem(
                  title: "HELP",
                  onTap: () => setState(() {
                    selectedIndex = 5;
                  }),
                  isSeleted: selectedIndex == 5,
                ),
                NavBarItem(
                  title: 'CLIENT DETAILS',
                  onTap: () => setState(() {
                    selectedIndex = 6;
                  }),
                  isSeleted: selectedIndex == 6,
                ),
              ],
            ),
          ),
          Expanded(
            child: mainScreen(),
          ),
        ],
      );
    } catch (e) {
      if (!errMsgMainlayout) {
        logFile.writeLogfile('Exception in main screen: $e');
        setState(() {
          errMsgMainlayout = true;
        });
      }
    }
  }

  stirCasting() {
    try {
      return Container(
        //Stir Casting Tab
        color: AppColors.white,
        child: Container(
          color: AppColors.grey,
          child: Row(
            children: [
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.screen_height * 38,
                    child: HeaterCard(
                      furnaceButtonLabel:
                          btns['btnFurnace']!['btnState'] as String?,
                      isFurnaceOn: b_lbl_furnace,
                      furnaceButtonColor:
                          btns['btnFurnace']!['btnColor'] as Color?,
                      powderButtonLabel:
                          btns['btnPowder']!['btnState'] as String?,
                      isPowderOn: b_lbl_powder,
                      powderButtonColor:
                          btns['btnPowder']!['btnColor'] as Color?,
                      mouldButtonLabel: btns['btnMold']!['btnState'] as String?,
                      isMouldOn: b_lbl_mould,
                      mouldButtonColor: btns['btnMold']!['btnColor'] as Color?,
                      furnacePrecentValue:
                          d_pv_furnace.toString().padLeft(4, '0'),
                      meltPrecentValue: d_pv_melt.toString().padLeft(4, '0'),
                      powderPrecentValue:
                          d_pv_powder.toString().padLeft(4, '0'),
                      mouldPrecentValue: d_pv_mould.toString().padLeft(4, '0'),
                      furnaceSetValue: d_sv_furnace.toString().padLeft(4, '0'),
                      meltSetValue: d_sv_melt.toString().padLeft(4, '0'),
                      powderSetValue: d_sv_powder.toString().padLeft(4, '0'),
                      mouldSetValue: d_sv_mould.toString().padLeft(4, '0'),
                      onFurnacePress: b_btn_Mains
                          ? () {
                              setState(() {
                                b_btn_Furance = btnState('heater',
                                    btns['btnFurnace'], b_btn_Furance);
                                if (!b_btn_Furance) {
                                  bFurnaceHeatOUT = false;
                                }
                              });
                            }
                          : null,
                      onPowderPress: b_btn_Mains
                          ? () {
                              setState(() {
                                b_btn_Powder = btnState(
                                    'heater', btns['btnPowder'], b_btn_Powder);
                                if (!b_btn_Powder) bPowderHeatOUT = false;
                              });
                            }
                          : null,
                      onMouldPress: b_btn_Mains
                          ? () {
                              setState(() {
                                b_btn_Mould = btnState(
                                    'heater', btns['btnMold'], b_btn_Mould);
                                if (!b_btn_Mould) bMouldHeatOUT = false;
                              });
                            }
                          : null,
                      calc: calc,
                      onFurnaceDecLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          valuedecrementLongPress('furnace');
                        }
                      },
                      onFurnaceDecreament: () {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          setState(() {
                            d_sv_furnace =
                                calc.valuedecrement('furnace', d_sv_furnace);
                          });
                        }
                      },
                      onFurnaceIncLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          valueincrementLongPress('furnace');
                        }
                      },
                      onFurnaceIncreament: () {
                        if ((b_btn_Mains) &&
                            (!b_btn_Furance)) if (!b_btn_Furance) {
                          setState(() {
                            d_sv_furnace =
                                calc.valueincrement('furnace', d_sv_furnace);
                          });
                        }
                      },
                      onMeltDecLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          valuedecrementLongPress('melt');
                        }
                      },
                      onMeltDecreament: () {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          d_sv_melt = calc.valuedecrement('melt', d_sv_melt);
                        }
                      },
                      onMeltIncLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          valueincrementLongPress('melt');
                        }
                      },
                      onMeltIncreament: () {
                        if ((b_btn_Mains) && (!b_btn_Furance)) {
                          d_sv_melt = calc.valueincrement('melt', d_sv_melt);
                        }
                      },
                      onPowderDecLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Powder)) {
                          valuedecrementLongPress('powder');
                        }
                      },
                      onPowderDecreament: () {
                        if ((b_btn_Mains) && (!b_btn_Powder)) {
                          d_sv_powder =
                              calc.valuedecrement('powder', d_sv_powder);
                        }
                      },
                      onPowderIncLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Powder)) {
                          valueincrementLongPress('powder');
                        }
                      },
                      onPowderIncreament: () {
                        if ((b_btn_Mains) && (!b_btn_Powder)) {
                          d_sv_powder =
                              calc.valueincrement('powder', d_sv_powder);
                        }
                      },
                      onMouldDecLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          valuedecrementLongPress('mold');
                        }
                      },
                      onMouldDecreament: () {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          d_sv_mould = calc.valuedecrement('mold', d_sv_mould);
                        }
                      },
                      onMouldIncLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          valueincrementLongPress('mold');
                        }
                      },
                      onMouldIncreament: () {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          d_sv_mould = calc.valueincrement('mold', d_sv_mould);
                        }
                      },
                      onLongPressEnd: (_) => longPressRelease(),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screen_height * 31,
                    child: StirrerCard(
                      stirrerButtonLabel:
                          btns['btnStir']!['btnState'] as String?,
                      stirrerButtonColor:
                          btns['btnStir']!['btnColor'] as Color?,
                      stirrerPrecentValue:
                          d_pv_stirrer.toString().padLeft(4, '0'),
                      stirrerSetValue: d_sv_stirrer.toString().padLeft(4, '0'),
                      onStirrerPress: b_btn_Mains
                          ? () {
                              setState(() {
                                if (!b_btn_Stirrer) {
                                  b_btn_Stirrer = btnState(
                                      'stir', btns['btnStir'], b_btn_Stirrer);
                                  d_stirrer_out = d_stirrer_min_val;
                                } else {
                                  setState(() {
                                    d_pv_stirrer = 0;
                                  });
                                  b_btn_Stirrer = btnState(
                                      'stir', btns['btnStir'], b_btn_Stirrer);
                                  d_stirrer_out = 1;
                                  d_stirrer_start_idx = 0;
                                }
                              });
                            }
                          : null,
                      onStirrerDecLongPressStart: (_) {
                        if (b_btn_Mains) {
                          valuedecrementLongPress('speed');
                        }
                      },
                      onStirrerDecreament: () {
                        if (b_btn_Mains) {
                          setState(() {
                            d_sv_stirrer =
                                calc.valuedecrement('speed', d_sv_stirrer);
                          });
                        }
                      },
                      onStirrerIncLongPressStart: (_) {
                        if (b_btn_Mains) {
                          valueincrementLongPress('speed');
                        }
                      },
                      onStirrerIncreament: () {
                        if (b_btn_Mains) {
                          setState(() {
                            d_sv_stirrer =
                                calc.valueincrement('speed', d_sv_stirrer);
                          });
                        }
                      },
                      autoJogButtonLabel:
                          btns['btnAutojog']!['btnState'] as String?,
                      autoJogButtonColor:
                          btns['btnAutojog']!['btnColor'] as Color?,
                      liftDownButtonColor:
                          btns['btnStirDown']!['btnColor'] as Color?,
                      liftUpButtonColor:
                          btns['btnStirUp']!['btnColor'] as Color?,
                      liftPos: calc.liftPosition(d_pv_lift_pos),
                      autoJogSetValue: d_sv_autojog.toString(),
                      onLiftUpPress: b_btn_Mains ? () {} : null,
                      onLiftDownPress: b_btn_Mains ? () {} : null,
                      onAutoJogPress: b_btn_Mains
                          ? () {
                              setState(() {
                                b_btn_Auto_Jog = btnState('autojog',
                                    btns['btnAutojog'], b_btn_Auto_Jog);
                                if (b_btn_Auto_Jog) {
                                  b_auto_jog_timer = true;
                                  // autojogStartFn();
                                } else {
                                  b_auto_jog_timer = false;
                                }
                              });
                            }
                          : null,
                      onAutoJogDecLongPressStart: (LongPressStartDetails) {
                        if (b_btn_Mains) {
                          valuedecrementLongPress('autojog');
                        }
                      },
                      onAutoJogDecreament: () {
                        if (b_btn_Mains) {
                          setState(() {
                            d_sv_autojog =
                                calc.valuedecrement('autojog', d_sv_autojog);
                          });
                        }
                      },
                      onAutoJogIncLongPressStart: (LongPressStartDetails) {
                        if (b_btn_Mains) {
                          valueincrementLongPress('autojog');
                        }
                      },
                      onAutoJogIncreament: () {
                        if (b_btn_Mains) {
                          setState(() {
                            d_sv_autojog =
                                calc.valueincrement('autojog', d_sv_autojog);
                          });
                        }
                      },
                      onLiftDownLongPressStart: (_) {
                        if (b_btn_Mains) {
                          setState(
                            () {
                              b_lift_pos_down = true;
                              t_lift_down = Timer.periodic(
                                  Duration(microseconds: 300), (timer) {
                                btns['btnStirDown']!['btnColor'] =
                                    AppColors.red;
                                d_sv_lift_pos = 1;
                              });
                            },
                          );
                        }
                      },
                      onLiftDownLongPressEnd: (_) {
                        setState(
                          () {
                            if (b_btn_Mains) {
                              b_lift_pos_down = false;
                              t_lift_down.cancel();
                              d_sv_lift_pos = 0;
                              btns['btnStirDown']!['btnColor'] = AppColors.grey;
                            }
                          },
                        );
                      },
                      onLiftUpLongPressEnd: (_) {
                        if (b_btn_Mains) {
                          setState(() {
                            b_lift_pos_up = false;
                            t_lift_up.cancel();
                            d_sv_lift_pos = 0;
                            btns['btnStirUp']!['btnColor'] = AppColors.grey;
                          });
                        }
                      },
                      onLiftUpLongPressStart: (_) {
                        if (b_btn_Mains) {
                          setState(() {
                            b_lift_pos_up = true;
                            t_lift_up = Timer.periodic(
                                Duration(microseconds: 300), (t) {
                              btns['btnStirUp']!['btnColor'] = AppColors.red;
                              d_sv_lift_pos = 2;
                            });
                          });
                        }
                      },
                      onLongPressEnd: (_) => longPressRelease(),
                      calc: calc,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screen_height * 18,
                    child: PouringCard(
                      buttonLabel: btns['btnPour']!['btnState'] as String?,
                      calc: calc,
                      buttonColor: btns['btnPour']!['btnColor'] as Color?,
                      operationName: '1) VALVE',
                      precentValue: calc.pourCondition(d_pv_pour_pos),
                      setValue: btns['btnPour']!['btnState'] as String?,
                      onIncreament: () {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          d_sv_mould = calc.valueincrement('mold', d_sv_mould);
                        }
                      },
                      ondecreament: () {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          d_sv_mould = calc.valuedecrement('mold', d_sv_mould);
                        }
                      },
                      onIncLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          valueincrementLongPress('mold');
                        }
                      },
                      onDecLongPressStart: (_) {
                        if ((b_btn_Mains) && (!b_btn_Mould)) {
                          valuedecrementLongPress('mold');
                        }
                      },
                      onLongPressEnd: (_) => longPressRelease(),
                      onPress: b_btn_Mains
                          ? () {
                              if (b_btn_Mains) {
                                setState(() {
                                  if (!b_btn_Pour_Open) {
                                    showAlertMessageOKCANCEL(
                                      'Please click OK to open the pour valve!',
                                    );
                                  } else {
                                    b_btn_Pour_Open = btnState('pouring',
                                        btns['btnPour'], b_btn_Pour_Open);
                                    b_Start_B_Gas_Counter = false;
                                    d_B_Gas_idx = 0;
                                  }
                                  // if (b_btn_Pour_Open) {
                                  //   b_Start_B_Gas_Counter = true;
                                  // } else {
                                  //   d_B_Gas_idx = 0;
                                  //   b_Start_B_Gas_Counter = false;
                                  // }
                                });
                              }
                            }
                          : null,
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.screen_height * 1,
                      left: SizeConfig.screen_width * 0.5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            //   Operation INSTRUCTION
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.screen_width * 0.5),
                            color: Colors.white,
                            width: SizeConfig.screen_width * 42, //530
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  color: AppColors.headbgColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.screen_height * 0.25,
                                    horizontal: SizeConfig.screen_width * 0.25,
                                  ),
                                  child: Text(
                                    'Operating Instructions',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(flex: 3),
                                Text(
                                  'Before HEATING (@COLD Conditions)',
                                  style: TextStyle(
                                    fontSize: SizeConfig.font_height * 1.65,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[900],
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screen_height * 1),
                                InstructionTextView(
                                    instruction:
                                        'Clean the RETORT, BLADE, MELT TEMP. SENSOR  & MOLD with WET cloth and allow it to dry for 5 mins.'),
                                SizedBox(height: SizeConfig.screen_height * 1),
                                InstructionTextView(
                                    instruction:
                                        'Apply THIN layer of HIGH TEMPERATURE NON STICK COATING to the above parts'),
                                SizedBox(height: SizeConfig.screen_height * 1),
                                InstructionTextView(
                                    instruction:
                                        'When the FURNACE is heated, bring down the stirrer blade inside the retort to allow the non-stick coating to dry.'),
                                const Spacer(flex: 4),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: SizeConfig.screen_height * 0.5),
                                  child: Text(
                                    'After HEATING (@HOT Conditions > 700 C)',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 1.65,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.screen_height * 1),
                                InstructionTextView(
                                  instruction: 'Lift the STIRRER UP.',
                                ),
                                InstructionTextView(
                                  instruction: 'OPEN the pouring valve',
                                ),
                                InstructionTextView(
                                  instruction:
                                      'CLEAN the retort with the scoop provided',
                                ),
                                InstructionTextView(
                                  instruction:
                                      'CLEAN the WALL of the POUR HOLE with the pinch rod provided',
                                ),
                                InstructionTextView(
                                  instruction: 'CLOSE the pouring valve',
                                ),
                                InstructionTextView(
                                  instruction:
                                      'CLEAN the pouring tube with the T- type tool',
                                ),
                                InstructionTextView(
                                  instruction:
                                      'LOAD the materials in the RETORT',
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Container(
                            // Safety Instruction
                            margin: EdgeInsets.only(
                                top: SizeConfig.screen_height * 1),
                            color: Colors.white,
                            width: SizeConfig.screen_width * 42, //530
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  color: AppColors.headbgColor,
                                  margin: EdgeInsets.only(
                                      bottom: SizeConfig.screen_width * 1.25),
                                  padding: EdgeInsets.only(
                                    top: SizeConfig.screen_height * 0.25,
                                    bottom: SizeConfig.screen_height * 0.25,
                                    left: SizeConfig.screen_width * 0.25,
                                    right: SizeConfig.screen_width * 0.25,
                                  ),
                                  child: Text(
                                    'Safety Instructions',
                                    style: TextStyle(
                                      fontSize: SizeConfig.font_height * 2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: SizeConfig.screen_height * 2.5,
                                    left: SizeConfig.screen_width * 0.25,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'DO’s',
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.font_height * 1.65,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.green,
                                        ),
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'Always wear safety accessories such as mask, gloves, googles, apron and shoes',
                                        textColor: Colors.green,
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'Always calculate the volume of mold & load the required quantity of metal/reinforcements in the retort to avoid overflow of melt while pouring into the mould.',
                                        textColor: Colors.green,
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'Align the mold feeder hole and the pouring tube in a straight line.',
                                        textColor: Colors.green,
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'Clean the equipment after each use.',
                                        textColor: Colors.green,
                                      ),
                                      SizedBox(
                                          height:
                                              SizeConfig.screen_height * 3.25),
                                      Text(
                                        'DON’Ts',
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.font_height * 1.65,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.red,
                                        ),
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'DO NOT LOAD THE RETORT FULLY. This will obstruct the movement of stirrer blade into the retort.',
                                        textColor: Colors.red,
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'DO NOT KEEP THE MELT TEMP. SENSOR INSIDE THE RETORT WHILE STIRRING.This will damage the sensor and the stirrer blade.',
                                        textColor: Colors.red,
                                      ),
                                      InstructionTextView(
                                        instruction:
                                            'DO NOT USE THE MACHINE WITHOUT PROPER TRAINING.',
                                        textColor: Colors.red,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: SizeConfig.screen_height * 1,
                          ),
                          color: Colors.white,
                          width: SizeConfig.screen_width * 42,
                          height: SizeConfig.screen_height * 5,
                          alignment: Alignment.center,
                          child: MarqueeText(
                            text: TextSpan(
                                text: warningText.isEmpty
                                    ? "No Worry!"
                                    : "Check: " + warningText),
                            speed: 10,
                            alwaysScroll: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color:
                          AppColors.grey!.withOpacity(b_btn_Mains ? 0.0 : 0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!errMsgStirrer) {
        logFile.writeLogfile('Exception in Stir casting tab: $e');
        setState(() {
          errMsgStirrer = true;
        });
      }
    }
  }

  autojogStartFn() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (b_stirrer_down) {
        b_auto_jog_timer = true;
        timer.cancel();
      }
    });
  }

  inertAtmosphere() {
    try {
      return Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InertAtmosphere(
                  gasFlowPrescentValue:
                      d_pv_gas_flow.toString().padLeft(2, '0'),
                  gasFlowSetValue: d_sv_gas_flow.toString(),
                  gas1SetValue: d_sv_gas_ar.toString(),
                  gas2SetValue: d_sv_gas_sf6.toString(),
                  buttonColor: btns['btnGasFlow']!['btnColor'] as Color?,
                  isPourShieldOpen: b_btn_Inert_Gas && d_pv_pour_pos == 2,
                  onGasFlowIncreasePress: () {
                    if ((b_btn_Mains) &&
                        (!b_btn_Inert_Gas) &&
                        (b_inert_available)) {
                      d_sv_gas_flow =
                          calc.valueincrement('gasFlow', d_sv_gas_flow);
                    }
                  },
                  onGasFlowDecreasePress: () {
                    if ((b_btn_Mains) &&
                        (!b_btn_Inert_Gas) &&
                        (b_inert_available)) {
                      d_sv_gas_flow =
                          calc.valuedecrement('gasFlow', d_sv_gas_flow);
                    }
                  },
                  onGas1IncreasePress: () {
                    if ((b_btn_Mains) && (!b_btn_Inert_Gas)) {
                      List ls;
                      ls = calc.gasFlowControlInc(
                          'gas1', d_sv_gas_ar, d_sv_gas_sf6);
                      setState(() {
                        d_sv_gas_ar = ls[0];
                        d_sv_gas_sf6 = ls[1];
                      });
                    }
                  },
                  onGas1DecreasePress: () {
                    if ((b_btn_Mains) && (!b_btn_Inert_Gas)) {
                      List ls;
                      ls = calc.gasFlowControlDec(
                          'gas1', d_sv_gas_ar, d_sv_gas_sf6);
                      setState(() {
                        d_sv_gas_ar = ls[0];
                        d_sv_gas_sf6 = ls[1];
                      });
                    }
                  },
                  onGas2IncreasePress: () {
                    if ((b_btn_Mains) && (!b_btn_Inert_Gas)) {
                      List ls;
                      ls = calc.gasFlowControlInc(
                          'gas2', d_sv_gas_ar, d_sv_gas_sf6);
                      setState(() {
                        d_sv_gas_ar = ls[0];
                        d_sv_gas_sf6 = ls[1];
                      });
                    }
                  },
                  onGas2DecreasePress: () {
                    if ((b_btn_Mains) && (!b_btn_Inert_Gas)) {
                      List ls;
                      ls = calc.gasFlowControlDec(
                          'gas2', d_sv_gas_ar, d_sv_gas_sf6);
                      setState(() {
                        d_sv_gas_ar = ls[0];
                        d_sv_gas_sf6 = ls[1];
                      });
                    }
                  },
                  buttonLabel: btns['btnGasFlow']!['btnState'] as String?,
                  inertGasPress: b_btn_Mains
                      ? () {
                          setState(() {
                            b_btn_Inert_Gas = btnState(
                                'gasflow', btns['btnGasFlow'], b_btn_Inert_Gas);
                            if (b_btn_Inert_Gas) {
                              d_GAS_IDX = 1;
                            }
                          });
                        }
                      : null,
                ),
                Container(
                  // INSTRUCTION
                  margin: EdgeInsets.only(top: SizeConfig.screen_height * 1),
                  // color: Colors.white,
                  height: SizeConfig.screen_height * 50, //355
                  width: SizeConfig.screen_width * 42, //530
                ),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      if (!errMsgInert) {
        logFile.writeLogfile('Exception in inertAtmosphere: $e');
        setState(() {
          errMsgInert = true;
        });
      }
    }
  }

  optionalAttachments() {
    try {
      return Container(
        //OPTIONAL ATTACHMENTS TAB
        color: Colors.white,
        child: Container(
          color: Colors.grey[300],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.screen_height * 1.5),
                  SqueezeCard(
                    runwayButtonLabel:
                        btns['btnRunway']!['btnState'] as String?,
                    runwayButtonColor: btns['btnRunway']!['btnColor'] as Color?,
                    isRunwayOn: b_lbl_runway,
                    squeezeButtonLabel:
                        btns['btnSqueezePump']!['btnState'] as String?,
                    squeezeButtonColor:
                        btns['btnSqueezePump']!['btnColor'] as Color?,
                    runwayPrecentValue: d_pv_runway.toString().padLeft(4, '0'),
                    runwaySetValue: d_sv_runway.toString().padLeft(4, '0'),
                    squeezePrecentValue: d_pv_sqz_prsr.toString(),
                    onRunwayPress: b_btn_Mains && b_squeeze_available
                        ? () {
                            setState(() {
                              b_btn_Runway = btnState(
                                  'heater', btns['btnRunway'], b_btn_Runway);
                              if (!b_btn_Runway) {
                                bRunwayHeatOUT = false;
                              }
                            });
                          }
                        : null,
                    onSqueezePress: b_btn_Mains && b_squeeze_available
                        ? () {
                            setState(() {
                              b_btn_Sqz_Pump = btnState('squeezepump',
                                  btns['btnSqueezePump'], b_btn_Sqz_Pump);
                            });
                          }
                        : null,
                    onRunwayIncreament: () {
                      if ((b_btn_Mains) &&
                          (!b_btn_Runway) &&
                          (b_squeeze_available)) {
                        d_sv_runway =
                            calc.valueincrement('runway', d_sv_runway);
                      }
                    },
                    onRunwayDecreament: () {
                      if ((b_btn_Mains) &&
                          (!b_btn_Runway) &&
                          (b_squeeze_available)) {
                        d_sv_runway =
                            calc.valuedecrement('runway', d_sv_runway);
                      }
                    },
                    onRunwayIncLongPressStart: (_) {
                      if ((b_btn_Mains) &&
                          (!b_btn_Powder) &&
                          (b_squeeze_available)) {
                        valueincrementLongPress('runway');
                      }
                    },
                    onRunwayDecLongPressStart: (_) {
                      if ((b_btn_Mains) &&
                          (!b_btn_Runway) &&
                          (b_squeeze_available)) {
                        valuedecrementLongPress('runway');
                      }
                    },
                    onLongPressEnd: (_) => longPressRelease(),
                  ),
                  SizedBox(height: SizeConfig.screen_height * 1.5),
                  OtherCard(
                    centrifugeButtonLabel:
                        btns['btnCentrifuge']!['btnState'] as String?,
                    vaccumPumpButtonLabel:
                        btns['btnVaccumPump']!['btnState'] as String?,
                    centrifugeButtonColor:
                        btns['btnCentrifuge']!['btnColor'] as Color?,
                    vaccumButtonColor:
                        btns['btnVaccumPump']!['btnColor'] as Color?,
                    centrifugePrecentValue:
                        d_pv_centrifuge.toString().padLeft(4, '0'),
                    centrifugeSetValue:
                        d_sv_centrifuge.toString().padLeft(4, '0'),
                    onCentrifugePress: b_btn_Mains && b_centrifugal_available
                        ? () {
                            setState(() {
                              if (!b_btn_Centrifugal) {
                                b_btn_Centrifugal = btnState('centrifuge',
                                    btns['btnCentrifuge'], b_btn_Centrifugal);
                                // d_centrifuge_out =
                                //     d_centrifuge_out ?? 0 + d_cen_min_val;
                                d_centrifuge_out = d_cen_min_val;
                              } else {
                                d_pv_centrifuge = 0;
                                b_btn_Centrifugal = btnState('centrifuge',
                                    btns['btnCentrifuge'], b_btn_Centrifugal);
                              }
                              if (!b_btn_Centrifugal) {
                                d_centrifuge_out = 1;
                                d_cen_start_idx = 0;
                              }
                            });
                          }
                        : null,
                    onVaccumPumpPress: b_btn_Mains && b_vacuum_available
                        ? () {
                            setState(() {
                              b_btn_Vacuum_Pump = btnState('vaccumpump',
                                  btns['btnVaccumPump'], b_btn_Vacuum_Pump);
                            });
                          }
                        : null,
                    onCentrifugeIncreamentPress: () {
                      if ((b_btn_Mains) &&
                          (!b_btn_Centrifugal) &&
                          (b_centrifugal_available)) {
                        setState(() {
                          d_sv_centrifuge = calc.valueincrement(
                              'centrifuge', d_sv_centrifuge);
                        });
                      }
                    },
                    onCentrifugeDecreamentPress: () {
                      if ((b_btn_Mains) &&
                          (!b_btn_Centrifugal) &&
                          (b_centrifugal_available)) {
                        setState(() {
                          d_sv_centrifuge = calc.valuedecrement(
                              'centrifuge', d_sv_centrifuge);
                        });
                      }
                    },
                    onIncCentrifugeLongPressStart: (_) {
                      if ((b_btn_Mains) &&
                          (!b_btn_Centrifugal) &&
                          (b_centrifugal_available)) {
                        valueincrementLongPress('centrifuge');
                      }
                    },
                    onDecCentrifugeLongPressStart: (_) {
                      if ((b_btn_Mains) &&
                          (!b_btn_Centrifugal) &&
                          (b_centrifugal_available)) {
                        valuedecrementLongPress('centrifuge');
                      }
                    },
                    onLongPressEnd: (_) => longPressRelease(),
                  ),
                  SizedBox(height: SizeConfig.screen_height * 1.5),
                  UltraSonicCard(
                    powderVibButtonLabel:
                        btns['btnPowderEMV']!['btnState'] as String?,
                    powderVibButtonColor:
                        btns['btnPowderEMV']!['btnColor'] as Color?,
                    uvEMVButtonLabel: btns['btnUV/EMV']!['btnState'] as String?,
                    uvEMVButtonColor: btns['btnUV/EMV']!['btnColor'] as Color?,
                    uvLiftPrecentValue: calc.uvliftPosition(d_pv_UV_lift_pos),
                    uvLiftUpLongPressStart: (_) {
                      setState(() {
                        t_uv_lift_up = Timer.periodic(
                            Duration(microseconds: 300), (timer) {
                          btns['btnUV_UP']!['btnColor'] = AppColors.red;
                          d_sv_UV_lift_pos = 2;
                        });
                      });
                    },
                    uvLiftUpLongPressEnd: (_) {
                      setState(() {
                        t_uv_lift_up.cancel();
                        btns['btnUV_UP']!['btnColor'] = AppColors.grey;
                        d_sv_UV_lift_pos = 0;
                      });
                    },
                    uvLiftDownLongPressStart: (_) {
                      setState(() {
                        t_uv_lift_down = Timer.periodic(
                            Duration(milliseconds: 300), (timer) {
                          btns['btnUV_DOWN']!['btnColor'] = AppColors.red;
                          d_sv_UV_lift_pos = 1;
                        });
                      });
                    },
                    uvLiftDownLongPressEnd: (_) {
                      setState(() {
                        t_uv_lift_down.cancel();
                        d_sv_UV_lift_pos = 0;
                        btns['btnUV_DOWN']!['btnColor'] = AppColors.grey;
                      });
                    },
                    onPowderVibPress: b_btn_Mains && b_powder_vib_available
                        ? () {
                            setState(() {
                              b_btn_PowderEMV = btnState('powderEMV',
                                  btns['btnPowderEMV'], b_btn_PowderEMV);
                            });
                          }
                        : null,
                    onUVEMVPress: b_btn_Mains && b_uv_vib_available
                        ? () {
                            setState(() {
                              b_btn_EM_Vibrator = btnState(
                                  'UV', btns['btnUV/EMV'], b_btn_EM_Vibrator);
                            });
                          }
                        : null,
                    liftUpButtonColor: btns['btnUV_UP']!['btnColor'] as Color?,
                    liftDownButtonColor:
                        btns['btnUV_DOWN']!['btnColor'] as Color?,
                    onUVLiftDownPress:
                        b_btn_Mains && b_uv_vib_available ? () {} : null,
                    onUVLiftUpPress:
                        b_btn_Mains && b_uv_vib_available ? () {} : null,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SizeConfig.screen_height * 25, //290
                    width: SizeConfig.screen_width * 40, //530
                  ), //container4
                ],
              )
            ],
          ),
        ),
      );
    } catch (e) {
      if (!errMsgOptional) {
        logFile.writeLogfile('Exception in optionalAttachments: $e');
        setState(() {
          errMsgOptional = true;
        });
      }
    }
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

  void addToRecord() {
    String rxtime = DateFormat('kk:mm:ss').format(DateTime.now());
    d_record_table_sino++;
    addRecordRxdList(
      TableRow(
        children: [
          _tableChildRow(d_record_table_sino.toString()),
          _tableChildRow(rxtime),
          _tableChildRow(d_pv_melt.toString()),
          _tableChildRow(d_pv_powder.toString()),
          _tableChildRow(d_pv_mould.toString()),
          _tableChildRow(d_pv_stirrer.toString()),
          _tableChildRow(b_btn_Pour_Open ? 'OPEN' : 'CLOSE'),
          if (b_inert_available) _tableChildRow(d_pv_gas_flow.toString()),
          if (b_vacuum_available)
            _tableChildRow(b_btn_Vacuum_Pump ? 'ON' : 'OFF'),
          if (b_centrifugal_available)
            _tableChildRow(d_pv_centrifuge.toString()),
          if (b_squeeze_available) _tableChildRow(d_pv_sqz_prsr.toString()),
        ],
      ),
    );
    addRecordToExcel([
      d_record_table_sino,
      rxtime,
      d_pv_melt,
      d_pv_powder,
      d_pv_mould,
      d_pv_stirrer,
      b_btn_Pour_Open ? 'ON' : 'OFF',
      if (b_inert_available) d_pv_gas_flow,
      if (b_vacuum_available) b_btn_Vacuum_Pump ? 'ON' : 'OFF',
      if (b_centrifugal_available) d_pv_centrifuge,
      if (b_squeeze_available) d_pv_sqz_prsr,
    ]);
    if (recordScrollController.hasClients) {
      recordScrollController
          .jumpTo(recordScrollController.position.maxScrollExtent);
    }
    print("Record adding");
  }

  void addToDataLogger(String rxtime) {
    d_data_logger_table_sino++;
    addDataLoggerRxdList(
      TableRow(
        children: [
          _tableChildRow(d_data_logger_table_sino.toString()),
          _tableChildRow(rxtime),
          _tableChildRow(d_pv_data_logger_temp_a.toString()),
          _tableChildRow(d_pv_data_logger_temp_b.toString()),
          _tableChildRow(d_pv_data_logger_temp_c.toString()),
          _tableChildRow(d_pv_data_logger_temp_d.toString()),
        ],
      ),
    );
    addDataLoggerToExcel([
      d_data_logger_table_sino,
      rxtime,
      d_pv_data_logger_temp_a,
      d_pv_data_logger_temp_b,
      d_pv_data_logger_temp_c,
      d_pv_data_logger_temp_d,
    ]);
    if (dataLogScrollController.hasClients) {
      dataLogScrollController
          .jumpTo(dataLogScrollController.position.maxScrollExtent);
    }
    print("Data logger adding");
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

  TableRow recordTableHeader() {
    return TableRow(
      children: [
        _buildTableHeaderCell('#'),
        _buildTableHeaderCell('TIME'),
        _buildTableHeaderCell('MELT'),
        _buildTableHeaderCell('POWDER'),
        _buildTableHeaderCell('MOULD'),
        _buildTableHeaderCell('STIR'),
        _buildTableHeaderCell('POUR'),
        if (b_inert_available) _buildTableHeaderCell('GAS'),
        if (b_vacuum_available) _buildTableHeaderCell('VAC'),
        if (b_centrifugal_available) _buildTableHeaderCell('CENT'),
        if (b_squeeze_available) _buildTableHeaderCell('SQZ'),
      ],
    );
  }

  TableRow dataLoggerTableHeader() {
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

  void _updateRecordTimer(String? value) {
    print("record time Value: $value");
    setState(() {
      _recordTableTimer = value;
      if (recordTimerEvent.isActive) recordTimerEvent.cancel();
      switch (_recordTableTimer) {
        case '1 Sec':
          recordTimerRestart(1);
          break;
        case '3 Sec':
          recordTimerRestart(3);
          break;
        case '5 Sec':
          recordTimerRestart(5);
          break;
        case '10 Sec':
          recordTimerRestart(10);
          break;
        case '30 Sec':
          recordTimerRestart(30);
          break;
        case '1 Min':
          recordTimerRestart(60);
          break;
        case '5 Min':
          recordTimerRestart(300);
          break;
        case '10 Min':
          recordTimerRestart(600);
          break;
        default:
          recordTimerRestart(10);
          break;
      }
    });
  }

  void recordTimerRestart(int _timer) {
    recordTimerEvent = Timer.periodic(Duration(seconds: _timer), (t) {
      if (btns['btnMain']!['btnState'] == 'Connected') {
        if (recordExcelFileContent.length == 0) {
          addRecordToExcel([recordTableHeader()]);
        }
        if (b_start_record) {
          addToRecord();
        }
      }
    });
  }

  void _updateDataLoggerTimer(String? value) {
    setState(() {
      print("date time value: $value");
      _dataLoggerTableTimer = value;
      if (dataLoggerTimerEvent.isActive) dataLoggerTimerEvent.cancel();
      switch (_dataLoggerTableTimer) {
        case '1 Sec':
          dataLoggerTimerRestart(1);
          break;
        case '5 Sec':
          dataLoggerTimerRestart(5);
          break;
        case '10 Sec':
          dataLoggerTimerRestart(10);
          break;
        case '30 Sec':
          dataLoggerTimerRestart(30);
          break;
        case '1 Min':
          dataLoggerTimerRestart(60);
          break;
        case '5 Min':
          dataLoggerTimerRestart(300);
          break;
        default:
          dataLoggerTimerRestart(10);
          break;
      }
    });
  }

  void dataLoggerTimerRestart(int _timer) {
    print("data logger time Value: $_timer");
    dataLoggerTimerEvent = Timer.periodic(Duration(seconds: _timer), (t) {
      if (btns['btnMain']!['btnState'] == 'Connected') {
        if (dataloggerExcelContent.length == 0) {
          addDataLoggerToExcel([dataLoggerTableHeader()]);
        }
        if (b_data_logger_start_record) {
          DateTime now = DateTime.now();
          String rxtime = DateFormat('kk:mm:ss').format(now);
          print("Received time: $rxtime - $now");
          addToDataLogger(rxtime);
        }
      }
    });
  }

  Widget record() {
    return Column(
      children: [
        Table(
          children: [
            recordTableHeader(),
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
                onPressed: b_btn_Mains
                    ? () {
                        onStartRecordPressed();
                        if (b_start_record)
                          _updateRecordTimer(_recordTableTimer);
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
                            value: _recordTableTimer,
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
                            onChanged:
                                b_start_record ? null : _updateRecordTimer,
                          ),
                        ),
                      ),
                      _buildButton(
                        buttonLabel: 'CLEAN',
                        buttonColor: AppColors.blue,
                        onPressed: onRecordReset,
                      ),
                      _buildButton(
                        buttonLabel: 'EXPORT',
                        buttonColor: AppColors.blue,
                        onPressed: () async {
                          if (recordExcelFileContent.length == 1) {
                            SnackbarService.showMessage(
                                context, "Record is Empty");
                          } else {
                            recordFile
                                .exportFile(recordExcelFileContent)
                                .then((exportedFilePath) {
                              // onResetData();
                              SnackbarService.showMessage(
                                  context,
                                  exportedFilePath == null
                                      ? "Record Exported"
                                      : "Record Exported to this path: $exportedFilePath");
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

// debug
  debugConsole() {
    return Container(
      width: SizeConfig.screen_width * 78,
      height: SizeConfig.screen_height * 25,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.screen_height * 1.25,
                bottom: SizeConfig.screen_height * 1.25),
            child: Text(
              'DebugConsole',
              style: TextStyle(
                fontSize: SizeConfig.font_height * 3.4,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1,
                    bottom: SizeConfig.screen_height * 1,
                    left: SizeConfig.screen_width * 1,
                    right: SizeConfig.screen_width * 1,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black),
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
                  width: SizeConfig.screen_width * 42, //500
                  height: SizeConfig.screen_height * 75, //600
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RxData:',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.65, //20
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.screen_height * 1,
                            bottom: SizeConfig.screen_height * 1,
                            left: SizeConfig.screen_width * 1,
                            right: SizeConfig.screen_width * 1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: rxDebugList,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: SizeConfig.screen_height * 1,
                    bottom: SizeConfig.screen_height * 1,
                    left: SizeConfig.screen_width * 1,
                    right: SizeConfig.screen_width * 1,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black),
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
                  width: SizeConfig.screen_width * 42, //500
                  height: SizeConfig.screen_height * 75, //600
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TxData:',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.65, //20
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.screen_height * 1,
                            bottom: SizeConfig.screen_height * 1,
                            left: SizeConfig.screen_width * 1,
                            right: SizeConfig.screen_width * 1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: txDebugList,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  txDataDebug(String txd) {
    String txtime = DateFormat('kk:mm:ss').format(DateTime.now());
    txDebugList.add(new Text('$txtime >>> $txd'));
    txDebugScrollController
        .jumpTo(txDebugScrollController.position.maxScrollExtent);
  }

  rxDataDebug(String rxd) {
    String rxtime = DateFormat('kk:mm:ss').format(DateTime.now());
    rxDebugList.add(new Text('$rxtime >>> $rxd'));
    rxDebugScrollController
        .jumpTo(rxDebugScrollController.position.maxScrollExtent);
  }

  bool warrantyStatus(String validDate) {
    var now = DateTime.now();
    int date = int.parse(validDate.substring(0, 2));
    int month = int.parse(validDate.substring(3, 5));
    int year = int.parse(validDate.substring(6, 10));

    var validdate = new DateTime.utc(year, month, date);

    if (validdate.compareTo(now) > 0) {
      return false;
    } else {
      return true;
    }
  }

  void addRecordToExcel(List excelData) {
    setState(() {
      recordExcelFileContent.add(excelData);
    });
  }

  void addDataLoggerToExcel(List newData) {
    setState(() {
      dataloggerExcelContent.add(newData);
    });
  }

  void addRecordRxdList(TableRow newRow) {
    setState(() {
      rxdList.add(newRow);
    });
  }

  void addDataLoggerRxdList(TableRow newRow) {
    setState(() {
      rxdDataLoggerList.add(newRow);
    });
  }

  void onStartRecordPressed() {
    setState(() {
      b_start_record = !b_start_record;
    });
  }

  void onStartDataLoggerPressed() {
    setState(() {
      b_data_logger_start_record = !b_data_logger_start_record;
      b_btn_Data_Logger = b_data_logger_start_record;
    });
  }

  void onDataLoggerExport() async {
    final dataLoggerFile = DataLoggerStorage();
    if (dataloggerExcelContent.length == 1) {
      SnackbarService.showMessage(context, "Record is Empty");
    } else {
      dataLoggerFile
          .exportFile(dataloggerExcelContent)
          .then((exportedFilePath) {
        SnackbarService.showMessage(
          context,
          exportedFilePath == null
              ? "Data Logger File exported"
              : "Data Logger file exported here: $exportedFilePath",
        );
      });
    }
  }

  void onRecordReset() {
    setState(() {
      d_record_table_sino = 0;
      rxdList = [];
      recordExcelFileContent = [
        [
          'Si_No',
          'Time',
          'Melt',
          'Powder',
          'Mould',
          'Stirrer',
          'Pour',
        ]
      ];
      if (b_inert_available) recordExcelFileContent[0].add("Gas");
      if (b_vacuum_available) recordExcelFileContent[0].add("Vaccum");
      if (b_centrifugal_available) recordExcelFileContent[0].add("Centrifugal");
      if (b_squeeze_available) recordExcelFileContent[0].add("Squeeze");
    });
  }

  void onDataLoggerReset() {
    setState(() {
      d_data_logger_table_sino = 0;
      rxdDataLoggerList = [];
      dataloggerExcelContent = [
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

  Widget dataLogger() {
    return Column(
      children: [
        Table(
          children: [
            dataLoggerTableHeader(),
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
                  children: rxdDataLoggerList,
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
                buttonColor: b_data_logger_start_record
                    ? AppColors.red!
                    : AppColors.green,
                onPressed: b_btn_Mains
                    ? () {
                        onStartDataLoggerPressed();
                        if (b_data_logger_start_record)
                          _updateDataLoggerTimer(_dataLoggerTableTimer);
                      }
                    : null,
                buttonLabel: b_data_logger_start_record
                    ? 'Stop Data Log'
                    : 'Start Data Log',
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
                            value: _dataLoggerTableTimer,
                            items: dataLoggerTimer
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
                            onChanged: _updateDataLoggerTimer,
                          ),
                        ),
                      ),
                      _buildButton(
                        buttonLabel: 'CLEAN',
                        buttonColor: AppColors.blue,
                        onPressed: onDataLoggerReset,
                      ),
                      _buildButton(
                        buttonLabel: 'EXPORT',
                        buttonColor: AppColors.blue,
                        onPressed: onDataLoggerExport,
                      ),
                    ],
                  ),
                ),
                if (b_data_logger_start_record)
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

  mainScreen() {
    if (isConnected) {
      if (selectedIndex == 0) {
        return stirCasting();
      } else if (selectedIndex == 1) {
        return inertAtmosphere();
      } else if (selectedIndex == 2) {
        return optionalAttachments();
      } else if (selectedIndex == 3) {
        return debugging == 'Y'
            ? DebugConsole(
                rxDebugList: rxDebugList,
                txDebugList: txDebugList,
                rxScrollController: rxDebugScrollController,
                txScrollController: txDebugScrollController,
              )
            : record();
      } else if (selectedIndex == 4) {
        return SettingsTab(
          appConfig: appconfig!,
          onUpdate: () {
            setState(() {
              appConfigFile.readExcelFile().then((value) {
                if ((value != null) && (value.length != 0)) {
                  clientInfo = value[0];
                  appconfig = value[1];
                  gasCalValues = value[2];
                  sqzCalValues = value[3];
                }
                appConfigTextAssign();
                var model = appconfig![0].toString().padLeft(6, '0');
                if (model.substring(0, 1) == '0') {
                  b_inert_available = false;
                } else {
                  b_inert_available = true;
                }
                if (model.substring(1, 2) == '0') {
                  b_vacuum_available = false;
                } else {
                  b_vacuum_available = true;
                }
                if (model.substring(2, 3) == '0') {
                  b_squeeze_available = false;
                } else {
                  b_squeeze_available = true;
                }
                if (model.substring(3, 4) == '0') {
                  b_centrifugal_available = false;
                } else {
                  b_centrifugal_available = true;
                }
                if (model.substring(4, 5) == '0') {
                  b_uv_vib_available = false;
                } else {
                  b_uv_vib_available = true;
                }
                if (model.substring(5, 6) == '0') {
                  b_powder_vib_available = false;
                } else {
                  b_powder_vib_available = true;
                }
                if (model.substring(6, 7) == '1') {
                  b_data_logger_available = true;
                } else {
                  b_data_logger_available = false;
                }
              });
              showAlertMessage('updated');
            });
          },
          onWifiPressed: () {
            b_wifiConnection = true;
            b_bluetoothConnection = false;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: TextFormField(
                    style: TextStyle(fontSize: SizeConfig.font_height * 2),
                    controller: _iptxtcontroller,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: 'Ip Address',
                      labelStyle: TextStyle(
                          fontSize: SizeConfig.font_height * 2,
                          color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        wifiConnection(_iptxtcontroller.text);
                        Navigator.pop(context);
                      },
                      child: Text('ok'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('close'),
                    ),
                  ],
                );
              },
            );
          },
          onBluetoothPressed: () async {
            b_wifiConnection = false;
            b_bluetoothConnection = true;
            var bluetoothState = await bluetooth.state;
            if (bluetoothState == BluetoothState.STATE_OFF) {
              await bluetooth.requestEnable();
            } else {
              await bluetooth.requestDisable();
              await bluetooth.requestEnable();
            }
            var devices = await bluetooth.getBondedDevices();
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Bluetooth paired'),
                  content: setupAlertBox(devices),
                );
              },
            );
          },
          isWifiConnected: b_wifiConnection,
          isBluetoothConnected: b_bluetoothConnection,
          stir_min_value: d_stirrer_min_val.toString(),
        );
      } else if (selectedIndex == 5) {
        return HelpTab(helpFilePath: helpFilePath);
      } else if (selectedIndex == 6) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.screen_height * 1,
                bottom: SizeConfig.screen_height * 1,
                left: SizeConfig.screen_width * 0.5,
                right: SizeConfig.screen_width * 0.5,
              ),
              color: AppColors.headbgColor,
              padding: EdgeInsets.only(
                top: SizeConfig.screen_height * 1,
                bottom: SizeConfig.screen_height * 1,
                left: SizeConfig.screen_width * 1,
                right: SizeConfig.screen_width * 1,
              ),
              child: Text(
                "CLIENT DETAILS",
                style: TextStyle(
                  fontSize: SizeConfig.font_height * 2,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.screen_height * 1,
                bottom: SizeConfig.screen_height * 1,
                left: SizeConfig.screen_width * 0.5,
                right: SizeConfig.screen_width * 0.5,
              ),
              padding: EdgeInsets.only(
                top: SizeConfig.screen_height * 1,
                bottom: SizeConfig.screen_height * 1,
                left: SizeConfig.screen_width * 1,
                right: SizeConfig.screen_width * 1,
              ),
              width: SizeConfig.screen_width * 55, //530
              height: SizeConfig.screen_height * 45, //300
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomerCard(
                    title: 'COLLEGE',
                    value: clientInfo![0],
                  ),
                  CustomerCard(
                    title: 'DEPT',
                    value: clientInfo![1],
                  ),
                  CustomerCard(
                    title: 'POC',
                    value: clientInfo![2],
                  ),
                  CustomerCard(
                    title: 'POC MOB',
                    value: clientInfo![3].toString(),
                  ),
                  CustomerCard(
                    title: 'MACHINE SL.NO',
                    value: clientInfo![4].toString(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: SizeConfig.screen_width * 17,
                        height: SizeConfig.screen_height * 3.5,
                        child: Text(
                          'WARRANTY STATUS',
                          style: TextStyle(
                            fontSize: SizeConfig.font_height * 2.4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        width: SizeConfig.screen_width * 35,
                        height: SizeConfig.screen_height * 3.5,
                        child: Text(
                          warrantyStatus(clientInfo![5])
                              ? 'INACTIVE'
                              : 'ACTIVE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            fontSize: SizeConfig.font_height * 2.4,
                            backgroundColor: warrantyStatus(clientInfo![5])
                                ? AppColors.red
                                : AppColors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        );
      } else if (selectedIndex == 7) {
        return dataLogger();
      }
    } else {
      if (b_start_autoConnect) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.screen_height * 1.5,
                  bottom: SizeConfig.screen_height * 1.5,
                  left: SizeConfig.screen_width * 1.5,
                  right: SizeConfig.screen_width * 1.5,
                ),
                child: Text(
                  'Connecting to device',
                  style: TextStyle(fontSize: SizeConfig.font_height * 2.5),
                ),
              ),
              CircularProgressIndicator(),
            ],
          ),
        );
      } else {
        if (selectedIndex == 5) {
          return HelpTab(helpFilePath: helpFilePath);
        } else if (selectedIndex == 6) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.screen_height * 1,
                  bottom: SizeConfig.screen_height * 1,
                  left: SizeConfig.screen_width * 0.5,
                  right: SizeConfig.screen_width * 0.5,
                ),
                color: AppColors.headbgColor,
                padding: EdgeInsets.only(
                  top: SizeConfig.screen_height * 1,
                  bottom: SizeConfig.screen_height * 1,
                  left: SizeConfig.screen_width * 1,
                  right: SizeConfig.screen_width * 1,
                ),
                child: Text(
                  "CLIENT DETAILS",
                  style: TextStyle(
                    fontSize: SizeConfig.font_height * 2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: SizeConfig.screen_height * 1,
                  bottom: SizeConfig.screen_height * 1,
                  left: SizeConfig.screen_width * 0.5,
                  right: SizeConfig.screen_width * 0.5,
                ),
                padding: EdgeInsets.only(
                  top: SizeConfig.screen_height * 1,
                  bottom: SizeConfig.screen_height * 1,
                  left: SizeConfig.screen_width * 1,
                  right: SizeConfig.screen_width * 1,
                ),
                width: SizeConfig.screen_width * 55, //530
                height: SizeConfig.screen_height * 45, //300
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomerCard(
                      title: 'COLLEGE',
                      value: clientInfo![0],
                    ),
                    CustomerCard(
                      title: 'DEPT',
                      value: clientInfo![1],
                    ),
                    CustomerCard(
                      title: 'POC',
                      value: clientInfo![2],
                    ),
                    CustomerCard(
                      title: 'POC MOB',
                      value: clientInfo![3].toString(),
                    ),
                    CustomerCard(
                      title: 'MACHINE SL.NO',
                      value: clientInfo![4].toString(),
                    ),
                    Row(
                      children: [
                        Container(
                          width: SizeConfig.screen_width * 17,
                          height: SizeConfig.screen_height * 3.5,
                          child: Text(
                            'WARRANTY STATUS',
                            style: TextStyle(
                              fontSize: SizeConfig.font_height * 2.4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          width: SizeConfig.screen_width * 35,
                          height: SizeConfig.screen_height * 3.5,
                          child: Text(
                            warrantyStatus(clientInfo![5])
                                ? 'INACTIVE'
                                : 'ACTIVE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              fontSize: SizeConfig.font_height * 2.4,
                              backgroundColor: warrantyStatus(clientInfo![5])
                                  ? AppColors.red
                                  : AppColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        } else {
          return SettingsTab(
            appConfig: appconfig!,
            onUpdate: () {
              setState(() {
                appConfigFile.readExcelFile().then((value) {
                  if ((value != null) && (value.length != 0)) {
                    clientInfo = value[0];
                    appconfig = value[1];
                    gasCalValues = value[2];
                    sqzCalValues = value[3];
                  }
                  appConfigTextAssign();
                  var model = appconfig![0].toString().padLeft(6, '0');
                  if (model.substring(0, 1) == '0') {
                    b_inert_available = false;
                  } else {
                    b_inert_available = true;
                  }
                  if (model.substring(1, 2) == '0') {
                    b_vacuum_available = false;
                  } else {
                    b_vacuum_available = true;
                  }
                  if (model.substring(2, 3) == '0') {
                    b_squeeze_available = false;
                  } else {
                    b_squeeze_available = true;
                  }
                  if (model.substring(3, 4) == '0') {
                    b_centrifugal_available = false;
                  } else {
                    b_centrifugal_available = true;
                  }
                  if (model.substring(4, 5) == '0') {
                    b_uv_vib_available = false;
                  } else {
                    b_uv_vib_available = true;
                  }
                  if (model.substring(5, 6) == '0') {
                    b_powder_vib_available = false;
                  } else {
                    b_powder_vib_available = true;
                  }
                  if (model.substring(6, 7) == '1') {
                    b_data_logger_available = true;
                  } else {
                    b_data_logger_available = false;
                  }
                });
                showAlertMessage('updated');
              });
            },
            onWifiPressed: () {
              b_wifiConnection = true;
              b_bluetoothConnection = false;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: TextFormField(
                      style: TextStyle(fontSize: SizeConfig.font_height * 2),
                      controller: _iptxtcontroller,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        labelText: 'Ip Address',
                        labelStyle: TextStyle(
                            fontSize: SizeConfig.font_height * 2,
                            color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          wifiConnection(_iptxtcontroller.text);
                          Navigator.pop(context);
                        },
                        child: Text('ok'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('close'),
                      ),
                    ],
                  );
                },
              );
            },
            onBluetoothPressed: () async {
              b_wifiConnection = false;
              b_bluetoothConnection = true;
              var bluetoothState = await bluetooth.state;
              if (bluetoothState == BluetoothState.STATE_OFF) {
                await bluetooth.requestEnable();
              } else {
                await bluetooth.requestDisable();
                await bluetooth.requestEnable();
              }
              var devices = await bluetooth.getBondedDevices();
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Bluetooth paired'),
                    content: setupAlertBox(devices),
                  );
                },
              );
            },
            isWifiConnected: b_wifiConnection,
            isBluetoothConnected: b_bluetoothConnection,
            stir_min_value: d_stirrer_min_val.toString(),
          );
        }
      }
    }
  }

  btnState(String name, btn, btnState) {
    try {
      if (b_btn_Mains) {
        setState(
          () {
            if (name == 'pouring') {
              if (btnState) {
                btn['btnState'] = 'CLOSE';
                btn['btnColor'] = AppColors.grey;
                btnState = false;
              } else {
                btn['btnState'] = 'OPEN';
                btn['btnColor'] = AppColors.red;
                btnState = true;
              }
            } else if (name == 'heater') {
              if (btnState) {
                btn['btnState'] = 'OFF';
                btn['btnColor'] = AppColors.grey;
                btnState = false;
              } else {
                btn['btnState'] = 'ON';
                btn['btnColor'] = AppColors.red;
                btnState = true;
              }
            } else if (name == 'autojog') {
              if (btnState) {
                btn['btnState'] = 'OFF';
                btn['btnColor'] = AppColors.grey;
                btnState = false;
              } else {
                btn['btnState'] = 'ON';
                btn['btnColor'] = AppColors.red;
                btnState = true;
              }
            } else {
              if (btnState) {
                btn['btnState'] = 'OFF';
                btn['btnColor'] = AppColors.grey;
                btnState = false;
              } else {
                btn['btnState'] = 'ON';
                btn['btnColor'] = AppColors.red;
                btnState = true;
              }
            }
          },
        );
      }
      return btnState;
    } catch (e) {
      if (!errMsgBtnState) {
        logFile.writeLogfile('Exception in btnState: $e');
        setState(() {
          errMsgBtnState = true;
        });
      }
    }
  }

  btnColorChanges(bool activeState) {
    if (activeState) {
      return Colors.blue[300];
    } else {
      return AppColors.blue;
    }
  }

  txtColorChanage(bool activeState) {
    if (activeState) {
      return AppColors.white;
    } else {
      return AppColors.black;
    }
  }

  // Long presss Value Events
  void valuedecrementLongPress(String name) {
    try {
      timer = Timer.periodic(Duration(milliseconds: 200), (t) {
        setState(() {
          if (name == 'furnace') {
            if (d_sv_furnace > 30) {
              d_sv_furnace -= 10;
            }
          } else if (name == 'melt') {
            if (d_sv_melt > 30) {
              d_sv_melt -= 10;
            }
          } else if (name == 'powder') {
            if (d_sv_powder > 30) {
              d_sv_powder -= 10;
            }
          } else if (name == 'mold') {
            if (d_sv_mould > 30) {
              d_sv_mould -= 10;
            }
          } else if (name == 'runway') {
            if (d_sv_runway > 30) {
              d_sv_runway -= 10;
            }
          } else if (name == 'centrifuge') {
            if (d_sv_centrifuge > 300) {
              d_sv_centrifuge -= 10;
            }
          } else if (name == 'speed') {
            if (d_sv_stirrer > 300) d_sv_stirrer -= 10;
          } else if (name == 'autojog') {
            if (d_sv_autojog > 1) {
              d_sv_autojog -= 1;
            }
          }
        });
      });
    } catch (e) {
      if (!errMsgValueDecLg) {
        logFile.writeLogfile('Exception in valuedecrementLongPress: $e');
        setState(() {
          errMsgValueDecLg = true;
        });
      }
    }
  }

  void valueincrementLongPress(String name) {
    try {
      timer = Timer.periodic(Duration(milliseconds: 200), (t) {
        setState(() {
          if (name == 'furnace') {
            if (d_sv_furnace < 1150) {
              d_sv_furnace += 10;
            }
          } else if (name == 'melt') {
            if (d_sv_melt < 1150) {
              d_sv_melt += 10;
            }
          } else if (name == 'powder') {
            if (d_sv_powder < 850) {
              d_sv_powder += 10;
            }
          } else if (name == 'mold') {
            if (d_sv_mould < 450) {
              d_sv_mould += 10;
            }
          } else if (name == 'runway') {
            if (d_sv_runway < 850) {
              d_sv_runway += 10;
            }
          } else if (name == 'centrifuge') {
            if (d_sv_centrifuge < 1400) {
              d_sv_centrifuge += 10;
            }
          } else if (name == 'speed') {
            if (d_sv_stirrer < 1200) d_sv_stirrer += 10;
          } else if (name == 'autojog') {
            if (d_sv_autojog < 10) d_sv_autojog += 1;
          }
        });
      });
    } catch (e) {
      if (!errMsgValueIecLg) {
        logFile.writeLogfile('Exception in valueincrementLongPress: $e');
        setState(() {
          errMsgValueIecLg = true;
        });
      }
    }
  }

  void longPressRelease() {
    timer.cancel();
  }

  // Wifi Connection
  wifiConnection(ipAddress) async {
    try {
      if (ipAddress == null) {
        return showAlertMessage('Enter properly');
      } else {
        if (ipAddress.toString().contains('.')) {
          socket = await Socket.connect(ipAddress.toString(), 23)
              .catchError((onError) {
            wifiConnection(ipAddress);
          });

          setState(() {
            isConnected = true;
            selectedIndex = 0;
          });

          connectionFile.writeConnectionFile('1,$ipAddress');
          rx();
          Timer.periodic(Duration(milliseconds: 300), (timer) {
            if (debugging == 'Y') {
              txDataDebug(transX());
            }
            sTxMsg(transX());
          });
        } else {
          return showAlertMessage('Given Ip address is not ip format');
        }
      }
    } catch (e) {
      if (!errMsgWifiCon) {
        logFile.writeLogfile('Exception in wifiConnection: $e');
        setState(() {
          errMsgWifiCon = true;
        });
      }
    }
  }

  // Bluetooth connection
  setupAlertBox(List<BluetoothDevice> devices) {
    return Container(
      width: SizeConfig.screen_width * 18, //300
      height: SizeConfig.screen_height * 30, //300
      child: devices.length == 0
          ? ListTile(
              title: Text('No devices is paired'),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(devices[index].name!),
                  onTap: () => bluetoothConnection(devices[index]),
                );
              },
            ),
    );
  }

  bluetoothConnection(BluetoothDevice device) async {
    try {
      if (!device.isConnected) {
        connection = await BluetoothConnection.toAddress(device.address)
            .timeout(Duration(seconds: 30), onTimeout: () {
          return showAlertMessage('Connection Timeout');
        });
      }
      setState(() {
        isConnected = true;
        connectionFile.writeConnectionFile('2,${device.address}');
      });

      Navigator.pop(context);
      try {
        if (connection != null) {
          connection?.input?.listen((Uint8List data) async {
            receiver(data);
            // displayText(data);
          }).onDone(() {
            connection?.finish();
          });
        } else {
          print('Connection becomes to null');
        }
      } catch (e) {
        print('Exception in reading msg via bluetooth: $e');
        logFile.writeLogfile('Exception in reading msg via bluetooth: $e');
      }

      Timer.periodic(Duration(milliseconds: 300), (timer) async {
        try {
          var sendMsg = transX();
          txd = 'xxx@SEUP${sendMsg}e#end\n';
          if (debugging!.toUpperCase() == 'Y') {
            txDataDebug(transX());
          }
          if (connection != null) {
            connection?.output.add(utf8.encode(txd + '\r\n') as Uint8List);
            await connection?.output.allSent;
          } else {
            print('connection becomes to null');
          }
        } catch (e) {
          print('Exception in send msg via bluetooth: $e');
          logFile.writeLogfile('Exception in send msg via bluetooth: $e');
        }
      });
    } on PlatformException catch (e) {
      if (!errMsgBluetoothPlatformCon) {
        logFile.writeLogfile('Platform Error occured: $e');
        setState(() {
          errMsgBluetoothPlatformCon = true;
        });
      }
    } catch (exception) {
      if (!errMsgBluetoothCon) {
        logFile.writeLogfile('Cannot connect, exception occured: $exception');
        setState(() {
          errMsgBluetoothCon = true;
        });
      }
    }
  }

  bluetoothConnectionWithAddress(address) async {
    try {
      var bluetoothState = await bluetooth.state;
      if (bluetoothState == BluetoothState.STATE_OFF) {
        await bluetooth.requestEnable();
      }

      connection = await BluetoothConnection.toAddress(address)
          .timeout(Duration(seconds: 30), onTimeout: () {
        return showAlertMessage('Connection TimeOut');
      });
      setState(() {
        isConnected = true;
      });
      try {
        if (connection != null) {
          connection?.input!.listen((Uint8List data) async {
            receiver(data);
            // displayText(data);
          }).onDone(() {
            // Bluetooth disconnected
            connection?.finish();
          });
        } else {
          print('connection becomes to null');
        }
      } catch (e) {
        print('Exception in reading msg vaia bluetooth: $e');
        logFile.writeLogfile('Exception in reading msg vaia bluetooth: $e');
      }

      Timer.periodic(Duration(milliseconds: 300), (timer) async {
        try {
          var sendMsg = transX();
          txd = 'xxx@SEUP${sendMsg}e#end\n';
          if (debugging!.toUpperCase() == 'Y') {
            txDataDebug(transX());
          }
          if (connection != null) {
            connection?.output.add(utf8.encode(txd + '\r\n') as Uint8List);
            await connection?.output.allSent;
          } else {
            print('connection becomes to null');
          }
        } catch (e) {
          print('Exception in send msg via bluetooth: $e');
          logFile.writeLogfile('Exception in send msg via bluetooth: $e');
        }
      });
    } on PlatformException catch (e) {
      if (!errMsgBluetoothPlatformCon) {
        logFile.writeLogfile('Platform Error occured: $e');
        setState(() {
          errMsgBluetoothPlatformCon = true;
        });
      }
    } catch (exception) {
      if (!errMsgBluetoothCon) {
        logFile.writeLogfile('Cannot connect, exception occured: $exception');
        setState(() {
          errMsgBluetoothCon = true;
        });
      }
    }
  }

  showAlertMessage(String msg) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(msg),
        );
      },
    );
  }

  showAlertMessageOKCANCEL(String msg) {
    try {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(msg),
            actions: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    b_btn_Pour_Open =
                        btnState('pouring', btns['btnPour'], b_btn_Pour_Open);
                    b_Start_B_Gas_Counter = true;
                  });
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('CANCEL'))
            ],
          );
        },
      );
    } catch (e) {
      if (!errMsgShowDialoge) {
        logFile.writeLogfile('Exception in showAlertMessageOKCANCEL: $e');
        setState(() {
          errMsgShowDialoge = true;
        });
      }
    }
  }

  void rx() {
    try {
      socket.listen((event) {
        Timer(Duration(milliseconds: 500), () {
          receiver(event);
          // displayText(event);
        });
      });
    } catch (e) {
      if (!errMsgWifiRx) {
        logFile.writeLogfile('Exception in rx: $e');
        setState(() {
          errMsgWifiRx = true;
        });
      }
    }
  }

//Datalogger validation for peak values > 1200
  // int d_Validate_DataLog_Temp(int dNewValue, int dOldValue) {
  //   int dReturnValue = 0;
  //   if (dNewValue < 1000)
  //     dReturnValue = dNewValue;
  //   else if ((dNewValue >= 1000) && (dNewValue < 1200))
  //     dReturnValue = 0;
  //   else
  //     dReturnValue = dOldValue;
  //   return dNewValue;
  // }

  String oldValue = "";

  void receiver(Uint8List event) {
    try {
      String s = String.fromCharCodes(event);
      // log("Data: $s");
      if (s.contains("ccc@")) {
        if (s.contains("eee")) {
          // log("FULL DATA: $s");
        } else {
          oldValue = s;
        }
      } else if (s.contains("eee")) {
        s = oldValue + s;
        oldValue = "";
        // log("Data merge: $s");

      }
      displayText(s);
      return;
      // if ((s.substring(0, 4) == "ccc@") &&
      //     (b_data_logger_available
      //         ? s.substring(44, 47) == "eee"
      //         : s.substring(35, 38) == "eee")) {
      //   displayText(s);
      //   return;
      // }
      // if (s.contains('@')) {
      //   var startIdx = s.indexOf("@");
      //   if (!s.endsWith('@')) {
      //     for (int i = startIdx + 1; i < s.length; i++) {
      //       sRxDataStart = sRxDataStart + s[i];
      //     }
      //   }
      //   s = '';
      //   bDataStart = true;
      //   bDataStop = false;
      // }
      // if (s.contains('e')) {
      //   var endIdx = s.indexOf("e");
      //   if (!s.startsWith('e')) {
      //     for (int i = endIdx - 1; i >= 0; i--) {
      //       sRxDataEnd = sRxDataEnd + s[i];
      //     }
      //     sRxDataEnd = sRxDataEnd.split('').reversed.join();
      //   }
      //   s = '';
      //   bDataStop = true;
      // }
      // if (bDataStart) {
      //   if (!bDataStop) {
      //     sRxDataMiddle = sRxDataMiddle + s;
      //     s = '';
      //   } else {
      //     sRxData = sRxDataStart + sRxDataMiddle + sRxDataEnd;
      //     displayText(sRxData);
      //     bDataStop = false;
      //     bDataStart = false;
      //     s = '';
      //     sRxData = '';
      //     sRxDataStart = '';
      //     sRxDataMiddle = '';
      //     sRxDataEnd = '';
      //   }
      // }
    } catch (e) {
      if (!errMsgReceiveMsg) {
        logFile.writeLogfile('Exception in receiver: $e');
        setState(() {
          errMsgReceiveMsg = true;
        });
      }
    }
  }

  Future<void> displayText(String text) async {
    final List<int> rxFurnace = rxDataPlacement[rxDataStructure["furnace"]!]!;
    final List<int> rxMelt = rxDataPlacement[rxDataStructure["melt"]!]!;
    final List<int> rxPowder = rxDataPlacement[rxDataStructure["powder"]!]!;
    final List<int> rxMould = rxDataPlacement[rxDataStructure["mould"]!]!;
    final List<int> rxRunway = rxDataPlacement[rxDataStructure["runway"]!]!;
    final List<int> rxStirrer = rxDataPlacement[rxDataStructure["stirrer"]!]!;
    final List<int> rxRotary = rxDataPlacement[rxDataStructure["rotary"]!]!;
    final List<int> rxGas = rxDataPlacement[rxDataStructure["gas"]!]!;
    final List<int> rxSqueeze = rxDataPlacement[rxDataStructure["squeeze"]!]!;
    try {
      // String text = String.fromCharCodes(data);
      if (text.contains("@")) {
        if (!text.isEmpty) {
          bDataReceived = true;

          // if ((text.length > 23) &&
          //     (text.length < (b_data_logger_available ? 51 : 33))) {
          final intialIndex = text.indexOf('@');
          text = text.substring(
              intialIndex + 1, b_data_logger_available ? 46 : 33);

          if (debugging == 'Y') {
            rxDataDebug(text);
            return;
          }
          // log("${text.codeUnitAt(0)}${text.codeUnitAt(1)} - ${text.codeUnitAt(2)}${text.codeUnitAt(3)} - ${text.codeUnitAt(4)}${text.codeUnitAt(5)} - ${text.codeUnitAt(6)}${text.codeUnitAt(7)} - ${text.codeUnitAt(8)}${text.codeUnitAt(9)} ");
          setState(
            () {
              d_pv_furnace = dvalidateTemperature(
                  int.parse(
                    text.codeUnitAt(rxFurnace[0]).toString().padLeft(2, '0') +
                        text
                            .codeUnitAt(rxFurnace[1])
                            .toString()
                            .padLeft(2, '0'),
                  ),
                  d_pv_furnace);
              d_pv_melt = dvalidateTemperature(
                  int.parse(
                    text.codeUnitAt(rxMelt[0]).toString().padLeft(2, '0') +
                        text.codeUnitAt(rxMelt[1]).toString().padLeft(2, '0'),
                  ),
                  d_pv_melt);
              d_pv_powder = dvalidateTemperature(
                  int.parse(
                    text.codeUnitAt(rxPowder[0]).toString().padLeft(2, '0') +
                        text.codeUnitAt(rxPowder[1]).toString().padLeft(2, '0'),
                  ),
                  d_pv_powder);
              d_pv_mould = dvalidateTemperature(
                  int.parse(
                    text.codeUnitAt(rxMould[0]).toString().padLeft(2, '0') +
                        text.codeUnitAt(rxMould[1]).toString().padLeft(2, '0'),
                  ),
                  d_pv_mould);
              if (b_squeeze_available) {
                d_pv_runway = dvalidateTemperature(
                    int.parse(
                      text.codeUnitAt(rxRunway[0]).toString().padLeft(2, '0') +
                          text
                              .codeUnitAt(rxRunway[1])
                              .toString()
                              .padLeft(2, '0'),
                    ),
                    d_pv_runway);
              }
              // d_pv_spare = text.codeUnitAt(10) + text.codeUnitAt(11);
              d_pv_stirrer = stirValidate(
                  int.parse(
                    text.codeUnitAt(rxStirrer[0]).toString().padLeft(2, '0') +
                        text
                            .codeUnitAt(rxStirrer[1])
                            .toString()
                            .padLeft(2, '0'),
                  ),
                  d_pv_stirrer);
              if (!b_btn_Stirrer) {
                setState(() {
                  d_pv_stirrer = 0;
                });
              }

              if (b_centrifugal_available) {
                d_pv_centrifuge = int.parse(text
                        .codeUnitAt(rxRotary[0])
                        .toString()
                        .padLeft(2, '0') +
                    text.codeUnitAt(rxRotary[1]).toString().padLeft(2, '0'));
                if (!b_btn_Centrifugal) {
                  d_pv_centrifuge = 0;
                }
              } else {
                d_pv_centrifuge = 0;
              }

              if (b_inert_available) {
                d_pv_gas_flow = int.parse(
                    text.codeUnitAt(rxGas[0]).toString().padLeft(2, '0') +
                        text.codeUnitAt(rxGas[1]).toString().padLeft(2, '0'));
                d_pv_gas_flow = dCalibratedGasValue(d_pv_gas_flow);
              } else {
                d_pv_gas_flow = 0;
              }

              if (b_squeeze_available) {
                d_pv_sqz_prsr = dCalibratedSqzPrsrValue(
                    int.parse(
                      text.codeUnitAt(rxSqueeze[0]).toString().padLeft(2, '0') +
                          text
                              .codeUnitAt(rxSqueeze[1])
                              .toString()
                              .padLeft(2, '0'),
                    ),
                    d_pv_sqz_prsr);
              } else {
                d_pv_sqz_prsr = 0;
              }
              // Getting the 20th character and
              // Converting the string to int and
              // then convert to binary using bulid in method called 'toRadixString()'
              var sig = text.codeUnitAt(20).toRadixString(2);
              sig = sig.padLeft(6, '0');

              if (b_uv_vib_available) {
                if (int.parse(sig.substring(0, 1)) == 1) {
                  //Sgnal 1 & UV up
                  d_pv_UV_lift_pos = 1;
                } else if (int.parse(sig.substring(1, 2)) == 1) {
                  //Sgnal 2 & UV down
                  d_pv_UV_lift_pos = 2;
                } else {
                  // in Operation
                  d_pv_UV_lift_pos = 0;
                }
              } else {
                d_pv_UV_lift_pos = 0;
              }

              if (int.parse(sig.substring(2, 3)) == 1) {
                //Sgnal 3 & Stir down
                d_pv_lift_pos = 1;
              } else if (int.parse(sig.substring(3, 4)) == 1) {
                //Sgnal 4 & Stir up
                d_pv_lift_pos = 2;
              } else {
                // in Operation
                d_pv_lift_pos = 0;
              }
              if (int.parse(sig.substring(4, 5)) == 1) {
                //Sgnal 5 & Pour close
                d_pv_pour_pos = 1;
              } else if (int.parse(sig.substring(5, 6)) == 1) {
                //Sgnal 6 & Pour open
                d_pv_pour_pos = 2;
              } else {
                // in Operation
                d_pv_pour_pos = 0;
              }
              if (d_pv_lift_pos == 1) {
                b_stirrer_down = true;
              } else {
                b_stirrer_down = false;
              }
              // For Data Logger
              if (b_data_logger_available) {
                d_pv_data_logger_temp_a = dvalidateTemperature(
                    int.parse(text.codeUnitAt(27).toString().padLeft(2, '0') +
                        text.codeUnitAt(28).toString().padLeft(2, '0')),
                    d_pv_data_logger_temp_a);
                d_pv_data_logger_temp_b = dvalidateTemperature(
                    int.parse(text.codeUnitAt(29).toString().padLeft(2, '0') +
                        text.codeUnitAt(30).toString().padLeft(2, '0')),
                    d_pv_data_logger_temp_b);
                d_pv_data_logger_temp_c = dvalidateTemperature(
                    int.parse(text.codeUnitAt(31).toString().padLeft(2, '0') +
                        text.codeUnitAt(32).toString().padLeft(2, '0')),
                    d_pv_data_logger_temp_c);
                d_pv_data_logger_temp_d = dvalidateTemperature(
                    int.parse(text.codeUnitAt(33).toString().padLeft(2, '0') +
                        text.codeUnitAt(34).toString().padLeft(2, '0')),
                    d_pv_data_logger_temp_d);
              }
              // log("Temp: $d_pv_furnace, $d_pv_melt, $d_pv_powder, $d_pv_mould, $d_pv_runway");
              // log("Lift: $d_pv_lift_pos, $d_pv_pour_pos");
              // log("Data logger: A -$d_pv_data_logger_temp_a, B -$d_pv_data_logger_temp_b, C -$d_pv_data_logger_temp_c, D -$d_pv_data_logger_temp_d");
              //  else {
              //   d_pv_data_logger_temp_a = 30;
              //   d_pv_data_logger_temp_b = 30;
              //   d_pv_data_logger_temp_c = 30;
              //   d_pv_data_logger_temp_d = 30;
              // }
              // validaterxData(text);
              // bDataReceived = true;
            },
          );
          // } else {
          //   LogEntryStorage().writeLogfile(
          //       'Data not in a given limit: ${text.codeUnits}\nData length: ${text.length}');
          // }
        }
      }
    } catch (e) {
      if (!errMsgDisplaytext) {
        logFile.writeLogfile('Exception in displaytext: $e');
        setState(() {
          errMsgDisplaytext = true;
        });
      }
    }
  }

  void getTxEventValue(SendIncreamentActionEnums value,
      Map<String, int> sendData, Function(Map<String, int> data) updateValues) {
    switch (value) {
      case SendIncreamentActionEnums.T1By1:
        sendData["T1"] = sendData["T1"]! + 1;
        break;
      case SendIncreamentActionEnums.T1By2:
        sendData["T1"] = sendData["T1"]! + 2;
        break;
      case SendIncreamentActionEnums.T1By4:
        sendData["T1"] = sendData["T1"]! + 4;
        break;
      case SendIncreamentActionEnums.T1By8:
        sendData["T1"] = sendData["T1"]! + 8;
        break;
      case SendIncreamentActionEnums.T2By1:
        sendData["T2"] = sendData["T2"]! + 1;
        break;
      case SendIncreamentActionEnums.T2By2:
        sendData["T2"] = sendData["T2"]! + 2;
        break;
      case SendIncreamentActionEnums.T2By4:
        sendData["T2"] = sendData["T2"]! + 4;
        break;
      case SendIncreamentActionEnums.T2By8:
        sendData["T2"] = sendData["T2"]! + 8;
        break;
      case SendIncreamentActionEnums.T3By1:
        sendData["T3"] = sendData["T3"]! + 1;
        break;
      case SendIncreamentActionEnums.T3By2:
        sendData["T3"] = sendData["T3"]! + 2;
        break;
      case SendIncreamentActionEnums.T3By4:
        sendData["T3"] = sendData["T3"]! + 4;
        break;
      case SendIncreamentActionEnums.T3By8:
        sendData["T3"] = sendData["T3"]! + 8;
        break;
      case SendIncreamentActionEnums.T4By1:
        sendData["T4"] = sendData["T4"]! + 1;
        break;
      case SendIncreamentActionEnums.T4By2:
        sendData["T4"] = sendData["T4"]! + 2;
        break;
      case SendIncreamentActionEnums.T4By4:
        sendData["T4"] = sendData["T4"]! + 4;
        break;
      case SendIncreamentActionEnums.T4By8:
        sendData["T4"] = sendData["T4"]! + 8;
        break;
      case SendIncreamentActionEnums.H1By1:
        sendData["H1"] = sendData["H1"]! + 1;
        break;
      case SendIncreamentActionEnums.H1By2:
        sendData["H1"] = sendData["H1"]! + 2;
        break;
      case SendIncreamentActionEnums.H1By4:
        sendData["H1"] = sendData["H1"]! + 4;
        break;
      case SendIncreamentActionEnums.H1By8:
        sendData["H1"] = sendData["H1"]! + 8;
        break;
      case SendIncreamentActionEnums.R1By2:
        sendData["R1"] = sendData["R1"]! + 2;
        break;
      case SendIncreamentActionEnums.R1By4:
        sendData["R1"] = sendData["R1"]! + 4;
        break;
    }
    updateValues(sendData);
  }

  // Sending Data

  String transX() {
    Map<String, int> sendEventData = {
      "T1": 48,
      "T2": 48,
      "T3": 48,
      "T4": 48,
      "H1": 48,
      "R1": 48,
      "D1": 48,
    };
    if (b_btn_Mains && ioFormat.entries.length != 0) {
      getTxEventValue(ioFormat["main"]!, sendEventData,
          (newValue) => sendEventData = newValue);
      // Heater Outputs
      if (bFurnaceHeatOUT)
        getTxEventValue(ioFormat["furnace"]!, sendEventData,
            (newValue) => sendEventData = newValue);
      if (bPowderHeatOUT)
        getTxEventValue(ioFormat["powder"]!, sendEventData,
            (newValue) => sendEventData = newValue);
      if (bMouldHeatOUT)
        getTxEventValue(ioFormat["mould"]!, sendEventData,
            (newValue) => sendEventData = newValue);
      if (bRunwayHeatOUT)
        getTxEventValue(ioFormat["runway"]!, sendEventData,
            (newValue) => sendEventData = newValue);

      if (b_btn_Stirrer)
        getTxEventValue(ioFormat["stirrer"]!, sendEventData,
            (newValue) => sendEventData = newValue); //R7
      if (b_btn_Centrifugal)
        getTxEventValue(ioFormat["rotary"]!, sendEventData,
            (newValue) => sendEventData = newValue);

      // Hydraulic Pump
      if (b_btn_Sqz_Pump)
        getTxEventValue(ioFormat["squeezePump"]!, sendEventData,
            (newValue) => sendEventData = newValue);

      //Data Logger Attachment
      if (b_data_logger_available) //check if attachment is enabled
      if (b_btn_Data_Logger) // check if button is clicked
      {
        getTxEventValue(ioFormat["dataLogger"]!, sendEventData,
            (newValue) => sendEventData = newValue); // Command
        sendEventData["D1"] = sendEventData["D1"]! - 40;
      }

      // Vacuum Pump  (or) vacuum solinoid
      if (b_btn_Vacuum_Pump)
        getTxEventValue(ioFormat["vaccumPump"]!, sendEventData,
            (newValue) => sendEventData = newValue);

      if (d_pv_furnace > 650) {
        // Bottom Pouring Opne Close
        if (b_btn_Pour_Open) {
          getTxEventValue(ioFormat["pourOpen"]!, sendEventData,
              (newValue) => sendEventData = newValue); //Pour open
          // Pouring Gas Shield
          if (b_B_Gas_Out) {
            getTxEventValue(ioFormat["gasOutPouring"]!, sendEventData,
                (newValue) => sendEventData = newValue);
          }
        } else
          getTxEventValue(ioFormat["pourClose"]!, sendEventData,
              (newValue) => sendEventData = newValue); //Pour close
      }

      // if (b_btn_Pour_Open) {

      // }

      //STIRRER LIFT POSITION
      //if d_sv_lift_pos=0  --> OFF
      // if d_sv_lift_pos=1 --> DOWN
      //if d_sv_lift_pos=2 --> UP
      if ((b_btn_Auto_Jog) || (b_lift_pos_up) || (b_lift_pos_down)) {
        if (d_sv_lift_pos == 1) //Down
          getTxEventValue(ioFormat["stirrerDown"]!, sendEventData,
              (newValue) => sendEventData = newValue);
        else if (d_sv_lift_pos == 2) //Up
          getTxEventValue(ioFormat["stirrerUp"]!, sendEventData,
              (newValue) => sendEventData = newValue);
      }

      // Inert Gas
      if (b_gas_out) {
        //Gas Retort
        getTxEventValue(ioFormat["gasOutRetort"]!, sendEventData,
            (newValue) => sendEventData = newValue);
        if (b_SF6) // gas2
          getTxEventValue(ioFormat["gasInletSF6"]!, sendEventData,
              (newValue) => sendEventData = newValue);
        if (b_Ar) // gas1
          getTxEventValue(ioFormat["gasInletArgon"]!, sendEventData,
              (newValue) => sendEventData = newValue);
      }

      //UV LIFT POSITION
      //if d_sv_UV_lift_pos=0  --> OFF
      // if d_sv_UV_lift_pos=1 --> DOWN
      //if d_sv_UV_lift_pos=2 --> UP
      if (d_sv_UV_lift_pos == 1) //Down
        getTxEventValue(ioFormat["uvDown"]!, sendEventData,
            (newValue) => sendEventData = newValue);
      else if (d_sv_UV_lift_pos == 2) //Up
        getTxEventValue(ioFormat["uvUp"]!, sendEventData,
            (newValue) => sendEventData = newValue);
      if (b_btn_EM_Vibrator)
        getTxEventValue(ioFormat["uvVibrator"]!, sendEventData,
            (newValue) => sendEventData = newValue);
      if (b_btn_PowderEMV)
        getTxEventValue(ioFormat["powderEMV"]!, sendEventData,
            (newValue) => sendEventData = newValue);
    }

    // converting current values to ascii and sending to terminal
    var ac1 = new String.fromCharCode(sendEventData["T1"]!);
    var ac2 = new String.fromCharCode(sendEventData["T2"]!);
    var ac3 = new String.fromCharCode(sendEventData["T3"]!);
    var ac4 = new String.fromCharCode(sendEventData["T4"]!);
    var h1 = new String.fromCharCode(sendEventData["H1"]!);
    var r1 = new String.fromCharCode(sendEventData["R1"]!);
    var d1 = new String.fromCharCode(sendEventData["D1"]!);
    var stir = new String.fromCharCode(
        d_stirrer_out == 13 ? d_stirrer_out! + 1 : d_stirrer_out!);
    var cent = new String.fromCharCode(
        d_centrifuge_out == 13 ? d_centrifuge_out! + 1 : d_centrifuge_out!);
    return (ac1 + ac2 + ac3 + ac4 + h1 + r1 + d1 + stir + cent);
  }

  int dCalibratedGasValue(int dPVvalue) {
    int dreturnvalue = 0;
    try {
      if (dPVvalue <= gasCalValues!.first) {
        dreturnvalue = 0;
      } else if (dPVvalue > gasCalValues!.last) {
        dreturnvalue = 99;
      } else {
        for (int i = 1; i < gasCalValues!.length; i++) {
          if ((dPVvalue > gasCalValues![i - 1]) &&
              (dPVvalue <= gasCalValues![i])) {
            dreturnvalue = i;
          }
        }
      }

      if (!b_btn_Inert_Gas) dreturnvalue = 0;
    } catch (e) {
      logFile.writeLogfile('Exception in dCalibratedGasValue: $e');
    }
    return dreturnvalue;
  }

  int dCalibratedSqzPrsrValue(int dPVvalue, int dOVvalue) {
    int dreturnvalue = 0;
    //Changes Starts - Venkat
    int dAdditionValue = 30;
    if (dPVvalue > dAdditionValue) dPVvalue = dPVvalue - dAdditionValue;
    //Changes Ends - Venkat
    try {
      // print('Squeeze Cal: $sqzCalValues');
      if (dPVvalue <= sqzCalValues!.first) {
        dreturnvalue = 0;
      } else if (dPVvalue > sqzCalValues!.last + 50) {
        dreturnvalue = dOVvalue; //display Old value
      } else {
        for (int i = 1; i < sqzCalValues!.length; i++) {
          if ((dPVvalue > sqzCalValues![i - 1]) &&
              (dPVvalue <= sqzCalValues![i])) {
            dreturnvalue = i;
          }
        }
      }

      if (!b_btn_Sqz_Pump) dreturnvalue = 0;
    } catch (e) {
      logFile.writeLogfile('Exception in dCalibratedSqzPrsrValue: $e');
    }
    return dreturnvalue;
  }

  void sTxMsg(sendMsg) {
    try {
      // String txtime = DateFormat('hh:mm:ss').format(DateTime.now());
      print('SendingMsg: $sendMsg');
      txd = 'xxx@SEUP${sendMsg}e#end';
      socket.write(txd);
    } catch (e) {
      if (!errMsgSendMsg) {
        logFile.writeLogfile('Exception in sTxMsg: $e');
        setState(() {
          errMsgSendMsg = true;
        });
      }
    }
  }

  appConfigTextAssign() {
    setState(() {
      dFurnaceMaxTime = appconfig![1];
      dPowderMaxTime = appconfig![2];
      dMouldMaxTime = appconfig![3];
      dRunwayMaxTime = appconfig![4];
      d_stirrer_min_val = appconfig![5];
      d_stirrer_max_val = appconfig![6];
      d_cen_min_val = appconfig![7];
      d_cen_max_val = appconfig![8];
      debugging = appconfig![9];
      d_shield_max_time = appconfig![10];
      d_vacuum_delay = appconfig![11];
      b_data_logger_screen_available = appconfig![13] == 'Y';
    });
  }

  bool getIsWarningShow(String text) {
    return warningText.split(',').any((element) => element == text);
  }

  void updateWarningText(String action, String text) {
    List data = warningText.split(',');
    if (action == "add") {
      data.add(text);
    } else if (action == "remove") {
      data.remove(text);
    }
    if (data.isNotEmpty && data[0] == "") {
      warningText = data[1];
    } else {
      warningText = data.join(',');
    }
    setState(() {});
  }

  masterTimer_Event() {
    try {
      setState(() {
        // appConfigTextAssign();
        if (bDataReceived) {
          btns['btnMain']!['btnState'] = 'Connected';
          dDataReceivedIndex = 0;
          b_ringtone = false;
        } else {
          dDataReceivedIndex++;
          if (dDataReceivedIndex >= 10) {
            btns['btnMain']!['btnState'] = 'DisConnected';
            dDataReceivedIndex = 0;
            b_ringtone = true;
            // b_start_autoConnect = false;
            // if (!b_start_autoConnect) {
            connectionFile.readConnectionFile().then((value) {
              if (value != null) {
                // print('Connecting to device');
                if (value[0] == '1') {
                  b_wifiConnection = true;
                  b_bluetoothConnection = false;
                  wifiConnection(value[1]);
                } else if (value[0] == '2') {
                  b_wifiConnection = false;
                  b_bluetoothConnection = true;
                  bluetoothConnectionWithAddress(value[1]);
                }
              }
            });
            // }
          }
        }
        // playing alert sound
        if (alerm == 'Y') {
          if (b_btn_Mains) {
            if (isConnected) {
              if (b_ringtone)
                FlutterRingtonePlayer.playRingtone();
              else
                FlutterRingtonePlayer.stop();
            }
          } else
            FlutterRingtonePlayer.stop();
        }
        bDataReceived = false;
        if (b_Start_B_Gas_Counter) {
          if (d_B_Gas_idx >= d_shield_max_time) {
            b_B_Gas_Out = true;
          } else {
            d_B_Gas_idx++;
            b_B_Gas_Out = false;
          }
        }
        //STIRRER LIFT POSITION
        //if d_sv_lift_pos=0  --> OFF
        // if d_sv_lift_pos=1 --> DOWN
        //if d_sv_lift_pos=2 --> UP
        if (b_auto_jog_timer) {
          d_lift_jog_idx++;
          if (d_lift_jog_idx <= d_sv_autojog) {
            d_sv_lift_pos = 2;
          } else {
            if (b_stirrer_down) {
              d_sv_lift_pos = 0;
              d_lift_jog_idx = 0;
            } else {
              d_sv_lift_pos = 1;
            }
          }
        } else {
          d_sv_lift_pos = 0;
        }

        // if (b_auto_jog_timer)
        // {
        //   if(b_stirrer_down)
        //   {
        //     d_lift_jog_idx++;
        //     if (d_lift_jog_idx <= d_sv_autojog) {
        //     d_sv_lift_pos = 2;
        //   }
        //   }
        //   else
        //    {
        //       d_sv_lift_pos = 1;
        //       d_lift_jog_idx=0;
        //   }
        //   // print('autojog start');
        //   else {
        //     if (b_stirrer_down) {
        //       d_sv_lift_pos = 0;
        //       d_lift_jog_idx = 0;
        //     } else {
        //       d_sv_lift_pos = 1;
        //     }
        //   }
        // }
        //For Furnace
        // if (d_pv_furnace == 0 || d_pv_melt == 0) {
        if (d_pv_furnace == 0) {
          if (!getIsWarningShow("Furnace TC!")) {
            updateWarningText("add", "Furnace TC!");
          }
        } else {
          if (getIsWarningShow("Furnace TC!")) {
            updateWarningText("remove", "Furnace TC!");
          }
        }

        if (d_pv_melt == 0) {
          if (!getIsWarningShow("Melt TC!")) {
            updateWarningText("add", "Melt TC!");
          }
        } else if (getIsWarningShow("Melt TC!")) {
          updateWarningText("remove", "Melt TC!");
        }
        // }
        if (b_btn_Furance) {
          if (d_pv_furnace == 0 || d_pv_melt == 0) {
            bFurnaceHeatOUT = false;
          } else {
            dFurnaceOut = calc.temp_CalOutPercent(
                d_pv_furnace, d_sv_furnace, dFurnaceMaxTime, 0);
            dFurnaceOFFTime = (10 - dFurnaceOut);
            dFurnaceONTime = (10 - dFurnaceOFFTime);
            dFurnaceCounter++;
            if (dFurnaceCounter <= dFurnaceONTime)
              bFurnaceHeatOUT = true;
            else
              bFurnaceHeatOUT = false;
            if (dFurnaceCounter == 10) dFurnaceCounter = 0;
            if ((d_pv_furnace >= d_sv_furnace) || (d_pv_melt >= d_sv_melt))
              bFurnaceHeatOUT = false;
          }
        }
        if (bFurnaceHeatOUT) {
          b_lbl_furnace = true;
        } else {
          b_lbl_furnace = false;
        }
        //For Powder
        if (d_pv_powder == 0) {
          if (!getIsWarningShow("Powder TC!")) {
            updateWarningText("add", "Powder TC!");
          }
        } else {
          if (getIsWarningShow("Powder TC!")) {
            updateWarningText("remove", "Powder TC!");
          }
        }
        if (b_btn_Powder) {
          if (d_pv_powder == 0) {
            bPowderHeatOUT = false;
          } else {
            dPowderOut = calc.temp_CalOutPercent(
                d_pv_powder, d_sv_powder, dPowderMaxTime, 0);
            dPowderOFFTime = (10 - dPowderOut);
            dPowderONTime = (10 - dPowderOFFTime);
            dPowderCounter++;
            if (dPowderCounter <= dPowderONTime)
              bPowderHeatOUT = true;
            else
              bPowderHeatOUT = false;
            if (dPowderCounter == 10) dPowderCounter = 0;
            if (d_pv_powder >= d_sv_powder) bPowderHeatOUT = false;
          }
        }
        if (bPowderHeatOUT) {
          b_lbl_powder = true;
        } else {
          b_lbl_powder = false;
        }
        //For Mould
        if (d_pv_mould == 0) {
          if (!getIsWarningShow("Mould TC!")) {
            updateWarningText("add", "Mould TC!");
          }
        } else {
          if (getIsWarningShow("Mould TC!")) {
            updateWarningText("remove", "Mould TC!");
          }
        }
        if (b_btn_Mould) {
          if (d_pv_mould == 0) {
            bMouldHeatOUT = false;
          } else {
            dMouldOut = calc.temp_CalOutPercent(
                d_pv_mould, d_sv_mould, dMouldMaxTime, 0);
            dMouldOFFTime = (10 - dMouldOut);
            dMouldONTime = (10 - dMouldOFFTime);
            dMouldCounter++;
            if (dMouldCounter <= dMouldONTime)
              bMouldHeatOUT = true;
            else
              bMouldHeatOUT = false;
            if (dMouldCounter == 10) dMouldCounter = 0;
            if (d_pv_mould >= d_sv_mould) bMouldHeatOUT = false;
          }
        }
        if (bMouldHeatOUT) {
          b_lbl_mould = true;
        } else {
          b_lbl_mould = false;
        }
        //For Runway
        if (d_pv_runway == 0) {
          if (!getIsWarningShow("Runway TC!")) {
            updateWarningText("add", "Runway TC!");
          }
        } else {
          if (getIsWarningShow("Runway TC!")) {
            updateWarningText("remove", "Runway TC!");
          }
        }
        if (b_btn_Runway) {
          if (d_pv_runway == 0) {
            bRunwayHeatOUT = false;
          } else {
            dRunwayOut = calc.temp_CalOutPercent(
                d_pv_runway, d_sv_runway, dRunwayMaxTime, 0);
            dRunwayOFFTime = (10 - dRunwayOut);
            dRunwayONTime = (10 - dRunwayOFFTime);
            dRunwayCounter++;
            if (dRunwayCounter <= dRunwayONTime)
              bRunwayHeatOUT = true;
            else
              bRunwayHeatOUT = false;
            if (dRunwayCounter == 10) dRunwayCounter = 0;
            if (d_pv_runway >= d_sv_runway) bRunwayHeatOUT = false;
          }
        }
        if (bRunwayHeatOUT) {
          b_lbl_runway = true;
        } else {
          b_lbl_runway = false;
        }

        //For Inert Gas Flow
        if (b_btn_Inert_Gas) {
          b_gas_out = true;
          if (d_pv_gas_flow <= d_sv_gas_flow - 1) {
            d_GAS_IDX++;
            if (d_sv_gas_ar > d_sv_gas_sf6) {
              if (d_GAS_IDX <= d_sv_gas_ar) {
                b_Ar = true;
                b_SF6 = false;
              } else {
                b_Ar = false;
                b_SF6 = true;
              }
            } else if (d_sv_gas_sf6 > d_sv_gas_ar) {
              if (d_GAS_IDX <= d_sv_gas_sf6) {
                b_Ar = false;
                b_SF6 = true;
              } else {
                b_Ar = true;
                b_SF6 = false;
              }
            } else {
              if (d_GAS_IDX <= 5) {
                b_Ar = true;
                b_SF6 = false;
              } else {
                b_Ar = false;
                b_SF6 = true;
              }
            }
            if (d_GAS_IDX >= 10) d_GAS_IDX = 1;
          } else {
            b_Ar = false;
            b_SF6 = false;
          }
        } else {
          b_Ar = false;
          b_SF6 = false;
          b_gas_out = false;
        }
        if (b_btn_Stirrer) {
          if (d_stirrer_start_idx > 8) {
            // print('Stirrer from mastertimer: $d_pv_stirrer');
            d_stirrer_out = d_stirrer_out! +
                calc.d_Calculate_Stirrer_Out(d_pv_stirrer, d_sv_stirrer);
            if (d_stirrer_out! <= 8) d_stirrer_out = 8;
            d_stirrer_start_idx = 0;
          } else
            d_stirrer_start_idx++;
        } else
          d_stirrer_out = 1;
        if (b_btn_Centrifugal) {
          if (d_cen_start_idx > 4) {
            d_centrifuge_out = d_centrifuge_out! +
                calc.d_Calculate_Stirrer_Out(d_pv_centrifuge, d_sv_centrifuge);
            if (d_centrifuge_out! > d_cen_max_val!)
              d_centrifuge_out = d_cen_max_val;
            d_cen_start_idx = 0;
          } else
            d_cen_start_idx++;
        } else
          d_centrifuge_out = 1;
      });
    } catch (e) {
      if (!errMsgMasterTimer) {
        logFile.writeLogfile('Exception in masterTimer_Event: $e');
        setState(() {
          errMsgMasterTimer = true;
        });
      }
    }
  }

  int dvalidateTemperature(int pv, int ov) {
    if (pv < 1100)
      return pv;
    else if ((pv > 1100) && (pv < 1300)) {
      logFile.writeLogfile('Check Thermocouple\n');
      //return value should be zero
      return 0;
    } else if ((pv > 6000) && (pv < 7000)) {
      logFile.writeLogfile('Check SMPS\n');
      //return value should be zero
      return 0;
    } else
      return ov;
  }

  int stirValidate(int pv, int ov) {
    if (!b_btn_Stirrer) {
      return 0;
    }
    if (pv.toString().length < 5) {
      if (pv > 3000)
        return ov;
      else
        return pv;
    } else {
      return pv;
    }
  }
}

class CustomerCard extends StatelessWidget {
  final String title;
  final String value;
  const CustomerCard({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: SizeConfig.screen_width * 17,
          height: SizeConfig.screen_height * 3.5,
          child: Text(
            title,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screen_width * 35,
          height: SizeConfig.screen_height * 3.5,
          child: Text(
            ': $value',
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.4,
            ),
          ),
        ),
      ],
    );
  }
}
