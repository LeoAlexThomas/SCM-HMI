import 'dart:async';

import 'package:StirCastingMachine/local_storage.dart';

var logFile = LogEntryStorage();

class Calculation {
  Timer? timer;
// For furnace
  int furnaceOut = 0,
      furnaceCounter = 0,
      furnaceONTime = 0,
      furnaceOFFTime = 10;
  bool furnaceHeatOUT = false;

// For powder
  int powderOut = 0, powderCounter = 0, powderONTime = 0, powderOFFTime = 10;
  bool powderHeatOUT = false;

// For mould
  int mouldOut = 0, mouldCounter = 0, mouldONTime = 0, mouldOFFTime = 10;
  bool mouldHeatOUT = false;

// For runway
  int runwayOut = 0, runwayCounter = 0, runwayONTime = 0, runwayOFFTime = 10;
  bool runwayHeatOUT = false;

// For AutoJog
  int lift_jog_idx = 0;
  int sv_lift_pos = 0;

// For Gas
  int gasIdx = 1;

// For Error Message
  bool errMsg = false;

  valuedecrement(String name, int value) {
    try {
      if (name == 'furnace') {
        if (value > 30) {
          return value -= 10;
        } else {
          return value;
        }
      } else if (name == 'melt') {
        if (value > 30) {
          return value -= 10;
        } else {
          return value;
        }
      } else if (name == 'powder') {
        if (value > 30) {
          return value -= 10;
        } else {
          return value;
        }
      } else if (name == 'mold') {
        if (value > 30) {
          return value -= 10;
        } else {
          return value;
        }
      } else if (name == 'speed') {
        if (value > 300) {
          return value -= 10;
        } else {
          return value;
        }
      } else if (name == 'autojog') {
        if (value > 1) {
          return value -= 1;
        } else {
          return value;
        }
      } else if (name == 'gasFlow') {
        if (value > 0) {
          return value -= 1;
        } else {
          return value;
        }
      } else if (name == 'centrifuge') {
        if (value > 300) {
          return value -= 10;
        } else {
          return value;
        }
      } else if (name == 'runway') {
        if (value > 750) {
          return value -= 5;
        } else {
          return value;
        }
      }
    } catch (e) {
      logFile.writeLogfile('Exception in valuedecrement: $e');
    }
  }

  valueincrement(String name, int value) {
    try {
      if (name == 'furnace') {
        if (value < 1000) {
          return value += 10;
        } else {
          return value;
        }
      } else if (name == 'melt') {
        if (value < 1000) {
          return value += 10;
        } else {
          return value;
        }
      } else if (name == 'powder') {
        if (value < 850) {
          return value += 10;
        } else {
          return value;
        }
      } else if (name == 'mold') {
        if (value < 450) {
          return value += 10;
        } else {
          return value;
        }
      } else if (name == 'speed') {
        if (value < 1200) {
          return value += 10;
        } else {
          return value;
        }
      } else if (name == 'autojog') {
        if (value < 10) {
          return value += 1;
        } else {
          return value;
        }
      } else if (name == 'gasFlow') {
        if (value < 10) {
          return value += 1;
        } else {
          return value;
        }
      } else if (name == 'centrifuge') {
        if (value < 1400) {
          return value += 10;
        } else {
          return value;
        }
      } else if (name == 'runway') {
        if (value < 850) {
          return value += 10;
        } else {
          return value;
        }
      }
    } catch (e) {
      logFile.writeLogfile('Exception in valueincrement: $e');
    }
  }

  gasFlowControlDec(String name, int gas1, int gas2) {
    try {
      if (name == 'gas1') {
        if (gas1 > 0) {
          gas1 -= 10;
          gas2 = 100 - gas1;
        }
      } else if (name == 'gas2') {
        if (gas2 > 0) {
          gas2 -= 10;
          gas1 = 100 - gas2;
        }
      }
      return [gas1, gas2];
    } catch (e) {
      logFile.writeLogfile('Exception in gasFlowControlDec:$e');
    }
  }

  gasFlowControlInc(String name, int gas1, int gas2) {
    try {
      if (name == 'gas1') {
        if (gas1 < 100) {
          gas1 += 10;
          gas2 = 100 - gas1;
        }
      } else if (name == 'gas2') {
        if (gas2 < 100) {
          gas2 += 10;
          gas1 = 100 - gas2;
        }
      }
      return [gas1, gas2];
    } catch (e) {
      logFile.writeLogfile('Exception in gasFlowControlInc: $e');
    }
  }

  String pourCondition(int? pourPosition) {
    if (pourPosition == 2) {
      return 'OPEN';
    } else if (pourPosition == 1) {
      return 'CLOSE';
    } else {
      return 'OPER';
    }
  }

  String liftPosition(int? leverPosition) {
    if (leverPosition == 1) {
      return 'DOWN';
    } else if (leverPosition == 2) {
      return 'UP';
    } else {
      return 'OPER';
    }
  }

  String uvliftPosition(int? leverPosition) {
    if (leverPosition == 2) {
      return 'UP';
    } else if (leverPosition == 1) {
      return 'DOWN';
    } else {
      return 'OPER';
    }
  }

  temp_CalOutPercent(int pv, int sv, int outMax, int outMin) {
    try {
      int dOut = 0;
      if (pv <= sv) {
        int dDiff = sv - pv;
        if (dDiff <= 2)
          dOut = 1;
        else if (dDiff <= 4)
          dOut = 2;
        else if (dDiff <= 6)
          dOut = 3;
        else if (dDiff <= 8)
          dOut = 4;
        else if (dDiff <= 10)
          dOut = 5;
        else if (dDiff <= 12)
          dOut = 6;
        else if (dDiff <= 14)
          dOut = 7;
        else if (dDiff <= 16)
          dOut = 8;
        else if (dDiff > 16) dOut = 9;
        if (dOut >= outMax) dOut = outMax;
        if (dOut <= outMin) dOut = outMin;
      } else
        dOut = 0;
      return dOut;
    } catch (e) {
      logFile.writeLogfile('Errorin temp_CalOutPercent: $e');
    }
  }

  bool btnPressedCallOut(
    String heatername,
    String heaterState,
    int pv,
    int sv,
    int maxtime,
    int mintime,
  ) {
    if (heatername == 'furnace') {
      if (heaterState == 'ON') {
        furnaceOut = temp_CalOutPercent(pv, sv, maxtime, mintime);
        furnaceOFFTime = (10 - furnaceOut);
        furnaceONTime = (10 - furnaceOFFTime);
        furnaceCounter++;
        if (furnaceCounter <= furnaceONTime)
          furnaceHeatOUT = true;
        else
          furnaceHeatOUT = false;
        if (furnaceCounter == 10) furnaceCounter = 0;
      }
      return furnaceHeatOUT;
    } else if (heatername == 'powder') {
      if (heaterState == 'ON') {
        powderOut = temp_CalOutPercent(pv, sv, maxtime, mintime);
        powderOFFTime = (10 - powderOut);
        powderONTime = (10 - powderOFFTime);
        powderCounter++;
        if (powderCounter <= powderONTime)
          powderHeatOUT = true;
        else
          powderHeatOUT = false;
        if (powderCounter == 10) powderCounter = 0;
      }
      return powderHeatOUT;
    } else if (heatername == 'mold') {
      if (heaterState == 'ON') {
        mouldOut = temp_CalOutPercent(pv, sv, maxtime, mintime);
        mouldOFFTime = (10 - mouldOut);
        mouldONTime = (10 - mouldOFFTime);
        mouldCounter++;
        if (mouldCounter <= mouldONTime)
          mouldHeatOUT = true;
        else
          mouldHeatOUT = false;
        if (mouldCounter == 10) mouldCounter = 0;
      }
      return mouldHeatOUT;
    } else {
      //  if (heatername == 'runway')
      if (heaterState == 'ON') {
        mouldOut = temp_CalOutPercent(pv, sv, maxtime, mintime);
        mouldOFFTime = (10 - mouldOut);
        mouldONTime = (10 - mouldOFFTime);
        mouldCounter++;
        if (mouldCounter <= mouldONTime)
          mouldHeatOUT = true;
        else
          mouldHeatOUT = false;
        if (mouldCounter == 10) mouldCounter = 0;
      }

      return runwayHeatOUT;
    }
  }

  int d_Calculate_Stirrer_Out(int dPV, int dSV) {
    int d_inc = 0;

    try {
      if (dPV == 0) {
        d_inc = 0;
      } else {
        if (dPV <= dSV) {
          int dDiff = dSV - dPV;
          if (dDiff >= 150)
            d_inc = 4;
          else if (dDiff >= 100)
            d_inc = 3;
          else if (dDiff >= 50)
            d_inc = 2;
          else if (dDiff >= 25) {
            d_inc = 1;
          }
        } else if (dPV > dSV) {
          int dDiff = dPV - dSV;
          if (dDiff >= 100)
            d_inc = -4;
          else if (dDiff >= 60)
            d_inc = -3;
          else if (dDiff >= 40)
            d_inc = -2;
          else if (dDiff >= 20) d_inc = -1;
        }
      }
    } catch (e) {
      logFile.writeLogfile('d_Calculate_Stirrer_Out error: $e');
    }
    return d_inc;
  }

  autoJogFunction(autojogtimer, stirpos) {
    try {
      lift_jog_idx++;
      if (lift_jog_idx <= autojogtimer) {
        sv_lift_pos = 2;
      } else {
        if (stirpos == 1) {
          sv_lift_pos = 0;
          lift_jog_idx = 0;
        } else {
          sv_lift_pos = 1;
        }
      }
      return sv_lift_pos;
    } catch (e) {
      logFile.writeLogfile('autoJogFunction error: $e');
    }
  }
}
