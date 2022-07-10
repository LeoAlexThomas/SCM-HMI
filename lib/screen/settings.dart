import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/local_storage.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class SettingsTab extends StatefulWidget {
  final List appConfig;
  final VoidCallback onUpdate;
  final VoidCallback onWifiPressed;
  final VoidCallback onBluetoothPressed;
  final bool isWifiConnected;
  final bool isBluetoothConnected;
  final String stir_min_value;

  SettingsTab({
    Key? key,
    required this.appConfig,
    required this.onUpdate,
    required this.onWifiPressed,
    required this.onBluetoothPressed,
    required this.isWifiConnected,
    required this.isBluetoothConnected,
    required this.stir_min_value,
  }) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool isAdminLoggedIn = false;
  var pwFile = PasswordStorage();
  final _admin_password_txtcontroller = TextEditingController();

  @override
  void dispose() {
    _admin_password_txtcontroller.dispose();
    super.dispose();
  }

  Widget _buildConnectionTab({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(0.0),
        height: SizeConfig.screen_height * 7,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[300] : AppColors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            Icon(
              icon,
              size: SizeConfig.font_height * 3.75,
              color: isSelected ? AppColors.white : AppColors.black,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: SizeConfig.font_height * 2.2,
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isAdminLoggedIn) {
      return widget.appConfig.length == 0
          ? Center(
              child: Text(
                'Insert config file\nand Restart the application',
                style: TextStyle(
                  fontSize: SizeConfig.font_height * 2.65, //20
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 15),
                    _buildSettingCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'CONNECTION SETTING',
                            style: TextStyle(
                              fontSize: SizeConfig.font_height * 2.65, //20
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildConnectionTab(
                              onPressed: widget.onWifiPressed,
                              icon: Icons.wifi,
                              label: "WIFI",
                              isSelected: widget.isWifiConnected),
                          _buildConnectionTab(
                            onPressed: widget.onBluetoothPressed,
                            icon: Icons.bluetooth,
                            label: 'Bluetooth',
                            isSelected: widget.isBluetoothConnected,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            _buildMachineMaxoutInfoCard(),
                            Container(
                              margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.screen_height * 1.5,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.screen_height * 1.5,
                                horizontal: SizeConfig.screen_width * 1.5,
                              ),
                              width: SizeConfig.screen_width * 25, //300
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
                              child: _buildMachineInfoContent(
                                'DEBUG',
                                widget.appConfig[9].toString(),
                              ),
                            ),
                            _buildMachineGasInfoCard(),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            _buildMachineStirrerInfoCard(),
                            _buildMachineCentrifugalInfoCard(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSettingButtons(
                      buttonLabel: "UPDATE",
                      onPressed: widget.onUpdate,
                    ),
                    _buildSettingButtons(
                      buttonLabel: "EXIT",
                      onPressed: () {
                        setState(() {
                          isAdminLoggedIn = false;
                          _admin_password_txtcontroller.text = "";
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            );
    } else {
      return adminlogin();
    }
  }

  Widget _buildSettingCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.screen_height * 1.5),
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.screen_width * 1.5),
      width: SizeConfig.screen_width * 25, //300
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
      child: child,
    );
  }

  Widget _buildMachineMaxoutInfoCard() {
    return _buildSettingCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "Max. OUT %",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.65, //20
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _buildMachineInfoContent('FURNACE', widget.appConfig[1].toString()),
          const SizedBox(height: 5),
          _buildMachineInfoContent('POWDER', widget.appConfig[2].toString()),
          const SizedBox(height: 5),
          _buildMachineInfoContent('MOLD', widget.appConfig[3].toString()),
          const SizedBox(height: 5),
          _buildMachineInfoContent('RUNWAY', widget.appConfig[4].toString()),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMachineGasInfoCard() {
    return _buildSettingCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "GAS",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.65, //20
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _buildMachineInfoContent('POUR GAS', widget.appConfig[10].toString()),
          const SizedBox(height: 5),
          _buildMachineInfoContent('VACUUM', widget.appConfig[11].toString()),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMachineStirrerInfoCard() {
    return _buildSettingCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "STIRRER OUT %",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.65, //20
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _buildMachineInfoContent('STIRRER_MIN', widget.stir_min_value),
          const SizedBox(height: 5),
          _buildMachineInfoContent(
              'STIRRER_MAX', widget.appConfig[6].toString()),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMachineCentrifugalInfoCard() {
    return _buildSettingCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            "CENTRIFUGAL OUT %",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.65, //20
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _buildMachineInfoContent('CEN_MIN', widget.appConfig[7].toString()),
          const SizedBox(height: 5),
          _buildMachineInfoContent('CEN_MAX', widget.appConfig[8].toString()),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Row _buildMachineInfoContent(String label, String contentValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: CustomTextStyle.textStyleHd(),
        ),
        const Spacer(),
        Container(
          width: SizeConfig.screen_width * 12,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black),
          ),
          child: Text(
            contentValue,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.font_height * 2.4, //17
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingButtons({
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: AppColors.blue,
        padding:
            EdgeInsets.symmetric(horizontal: SizeConfig.screen_width * 2.5),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        buttonLabel,
        style: TextStyle(
          fontSize: SizeConfig.font_height * 2,
          color: AppColors.white,
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget adminlogin() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: SizeConfig.screen_width * 18, //300
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'UserName:',
                  style: TextStyle(
                    fontSize: SizeConfig.font_height * 2.65, //20
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: SizeConfig.screen_width * 9,
                  child: Text(
                    'Admin',
                    style: TextStyle(
                      fontSize: SizeConfig.font_height * 2.65, //20
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: SizeConfig.screen_width * 18, //300
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Password:',
                  style: TextStyle(
                    fontSize: SizeConfig.font_height * 2.65, //20
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: SizeConfig.screen_width * 10,
                  height: SizeConfig.screen_height * 8,
                  child: _buildPasswordField(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: SizeConfig.screen_width * 9.5, //150
            height: SizeConfig.screen_height * 6,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.blue,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: SizeConfig.font_height * 2.5,
                  color: AppColors.white,
                ),
              ),
              onPressed: _handleLogin,
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogin() {
    if (_admin_password_txtcontroller.text == '0000') {
      String pw1 = _admin_password_txtcontroller.text.codeUnitAt(0).toString();
      String pw2 = _admin_password_txtcontroller.text.codeUnitAt(1).toString();
      String pw3 = _admin_password_txtcontroller.text.codeUnitAt(2).toString();
      String pw4 = _admin_password_txtcontroller.text.codeUnitAt(3).toString();
      String password = pw1 + pw2 + pw3 + pw4;
      // Save password as ascii code
      pwFile.writePasswordText(password);
      setState(() {
        isAdminLoggedIn = true;
      });
    } else {
      SnackbarService.showMessage(context, "Incorrect admin password");
    }
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      maxLength: 4,
      keyboardType: TextInputType.number,
      controller: _admin_password_txtcontroller,
      obscureText: true,
      decoration: InputDecoration(
        counterText: '',
        filled: true,
        fillColor: Colors.white70,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
          borderSide: BorderSide(color: AppColors.black, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(color: AppColors.black),
        ),
      ),
      style: TextStyle(
        fontSize: SizeConfig.font_height * 2.75,
      ), //20
    );
  }
}
