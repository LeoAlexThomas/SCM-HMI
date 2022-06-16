import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';

class AppConfigStorage {
  Future<String> _localpath() async {
    final directory = await getExternalStorageDirectory();
    // print('${directory.absolute.path}/new_folder');
    return directory.path;
  }

  Future<Uint8List> _localExcelfile() async {
    final path = await _localpath();
    print("config Path: $path");
    return File('$path/config.xlsx').readAsBytes();
  }

  // for read file from external storage

  Future<List> readExcelFile() async {
    try {
      // For Config excel file
      List clientDetails = [];
      List mechineDetails = [];
      List gasCalibrationValues = [];
      List sqzCalibrationValues = [];
      String helpFilePath = '';
      var excel = Excel.decodeBytes(await _localExcelfile());

      Sheet sheetObject = excel['Sheet1'];
      //below Getting cell(e.g. C3 position) by using sheetObject and adding cell's value to clientDetails List after getting cell from sheet
      // HelpFilePath
      helpFilePath = sheetObject.cell(CellIndex.indexByString('H19')).value;
      // ClientDetails
      clientDetails.add(sheetObject.cell(CellIndex.indexByString('C3')).value);
      clientDetails.add(sheetObject.cell(CellIndex.indexByString('C4')).value);
      clientDetails.add(sheetObject.cell(CellIndex.indexByString('C5')).value);
      clientDetails.add(sheetObject.cell(CellIndex.indexByString('C6')).value);
      clientDetails.add(sheetObject.cell(CellIndex.indexByString('C7')).value);
      clientDetails.add(sheetObject.cell(CellIndex.indexByString('C8')).value);

      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C11')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C12')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C13')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C14')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C15')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C16')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C17')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C18')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C19')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C20')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C21')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C22')).value);
      mechineDetails
          .add(sheetObject.cell(CellIndex.indexByString('C23')).value);

      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H3')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H4')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H5')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H6')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H7')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H8')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H9')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H10')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H11')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H12')).value);
      gasCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('H13')).value);

      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L3')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L4')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L5')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L6')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L7')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L8')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L9')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L10')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L11')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L12')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L13')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L14')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L15')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L16')).value);
      sqzCalibrationValues
          .add(sheetObject.cell(CellIndex.indexByString('L17')).value);

      return [
        clientDetails,
        mechineDetails,
        _gasValues(gasCalibrationValues),
        _sqzValues(sqzCalibrationValues),
        helpFilePath,
      ];
    } catch (e) {
      print('Exception in reading excel file : $e');
      LogEntryStorage().writeLogfile('Exception in reading excel file : $e');
    }
  }

  // Future<List> readExcelFile() async {
  //   try {
  //     // For Config excel file
  //     List clientDetails = [];
  //     List mechineDetails = [];
  //     List gasCalibrationValues = [];
  //     List sqzCalibrationValues = [];
  //     String helpFilePath = '';
  //     // var excel = Excel.decodeBytes(await _localExcelfile());
  //     ByteData data = await rootBundle.load("assets/docs/config.xlsx");
  //     var bytes =
  //         data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  //     var excel = Excel.decodeBytes(bytes);

  //     //Excel excel = await rootBundle.load('assets/docs/config.xlsx');

  //     Sheet sheetObject = excel['Sheet1'];
  //     //below Getting cell(e.g. C3 position) by using sheetObject and adding cell's value to clientDetails List after getting cell from sheet
  //     // HelpFilePath
  //     helpFilePath = sheetObject.cell(CellIndex.indexByString('H19')).value;
  //     // ClientDetails
  //     clientDetails.add(sheetObject.cell(CellIndex.indexByString('C3')).value);
  //     clientDetails.add(sheetObject.cell(CellIndex.indexByString('C4')).value);
  //     clientDetails.add(sheetObject.cell(CellIndex.indexByString('C5')).value);
  //     clientDetails.add(sheetObject.cell(CellIndex.indexByString('C6')).value);
  //     clientDetails.add(sheetObject.cell(CellIndex.indexByString('C7')).value);
  //     clientDetails.add(sheetObject.cell(CellIndex.indexByString('C8')).value);

  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C11')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C12')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C13')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C14')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C15')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C16')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C17')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C18')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C19')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C20')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C21')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C22')).value);
  //     mechineDetails
  //         .add(sheetObject.cell(CellIndex.indexByString('C23')).value);

  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H3')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H4')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H5')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H6')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H7')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H8')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H9')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H10')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H11')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H12')).value);
  //     gasCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('H13')).value);

  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L3')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L4')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L5')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L6')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L7')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L8')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L9')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L10')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L11')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L12')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L13')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L14')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L15')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L16')).value);
  //     sqzCalibrationValues
  //         .add(sheetObject.cell(CellIndex.indexByString('L17')).value);

  //     return [
  //       clientDetails,
  //       mechineDetails,
  //       _gasValues(gasCalibrationValues),
  //       _sqzValues(sqzCalibrationValues),
  //       helpFilePath,
  //     ];
  //   } catch (e) {
  //     print('Exception in reading excel file : $e');
  //     LogEntryStorage().writeLogfile('Exception in reading excel file : $e');
  //   }
  // }

  List _gasValues(List ls) {
    List diff = [];
    List maxValue = [];
    for (int i = 0; i < ls.length - 1; i++) {
      diff.add(((ls[i + 1] - ls[i]) / 2).round());
    }
    // print('diff:$diff');

    maxValue.add(ls[1] - diff[0]);
    for (int j = 1; j < diff.length; j++) {
      maxValue.add(ls[j] + diff[j]);
    }
    maxValue.add(ls.last + diff.last);
    // print('GasMaxValue: $maxValue');
    return maxValue;
  }

  List _sqzValues(List ls) {
    List diff = [];
    List maxValue = [];
    for (int i = 0; i < ls.length - 1; i++) {
      diff.add(((ls[i + 1] - ls[i]) / 5).round());
    }

    maxValue.add(ls[0]);
    for (int i = 0; i < diff.length; i++) {
      for (int j = 0; j < 5; j++) {
        int len = maxValue.length;
        if (len % 5 == 0) {
          if ((maxValue[len - 1] + diff[i]) > (ls[i + 1])) {
            maxValue.add(ls[i + 1]);
            // print('addition value exist max value & Value added:${ls[i + 1]} ');
            // print('Value at 5th pos: $maxValue');
          } else {
            maxValue.add(maxValue[len - 1] + diff[i]);
          }
        } else {
          maxValue.add(maxValue[len - 1] + diff[i]);
        }
      }
    }
    return maxValue;
  }
}

class RecordStorage {
  Future<String> _localpath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  // For creating excel file or any type of file
  Future<File> _localfile() async {
    final path = await _localpath();
    return File('$path/record.xls');
  }

  Future<File> _localExcelfile() async {
    final path = await _localpath();
    print(path);
    String recordName =
        DateFormat('dd-mm-yyyy_hh:mm:ss').format(DateTime.now());
    return File('$path/SCM-Export_${recordName}.xls');
  }

  exportFile(String str) async {
    File f = await _localExcelfile();
    f.writeAsString(str);
    // print('content updated');
  }

  Future<String> readRecord() async {
    try {
      // List item;
      final file = await _localfile();

      String content = await file.readAsString();
      return content;
    } catch (e) {
      LogEntryStorage().writeLogfile('Execption in reading RECORD file: $e');
    }
  }

  Future<File> writeRecordfile(String st) async {
    try {
      final file = await _localfile();
      // lst.every((element) {
      //   str += element.toString();
      // });
      return file.writeAsString(st, mode: FileMode.append);
    } catch (e) {
      LogEntryStorage().writeLogfile('Execption in writing RECORD file: $e');
    }
  }
}

class LogEntryStorage {
  Future<String> _localpath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> _localfile() async {
    final path = await _localpath();
    // print('$path/log.txt');
    return File('$path/log.txt');
  }

  Future<File> writeLogfile(String st) async {
    try {
      final file = await _localfile();
      st += '$st\n';
      return file.writeAsString(st, mode: FileMode.append);
    } catch (e) {
      print('Execption in writing file: $e');
    }
  }
}

class ConnectionStorage {
  Future<String> _localpath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> _localfile() async {
    final path = await _localpath();
    return File('$path/connection.txt');
  }

  Future<List> readConnectionFile() async {
    try {
      // List item;
      final file = await _localfile();

      String content = await file.readAsString();
      List con = content.split(',');
      return con;
    } catch (e) {
      LogEntryStorage()
          .writeLogfile('Execption in reading Connection file: $e');
    }
  }

  Future<File> writeConnectionFile(String st) async {
    try {
      final file = await _localfile();
      return file.writeAsString(st);
    } catch (e) {
      LogEntryStorage()
          .writeLogfile('Execption in writing connection file: $e');
    }
  }
}

class PasswordStorage {
  Future<String> _localpath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future<File> _localfile() async {
    final path = await _localpath();
    return File('$path/pw.txt');
  }

  Future<File> writePasswordText(String st) async {
    try {
      final file = await _localfile();
      return file.writeAsString(st);
    } catch (e) {
      LogEntryStorage().writeLogfile('Execption in writing password file: $e');
    }
  }
}
