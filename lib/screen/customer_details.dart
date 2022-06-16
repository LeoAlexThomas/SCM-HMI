import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/model/customer_details_response.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class CustomerDetails extends StatelessWidget {
  final CustomerDetailsResponse customerDetails;
  const CustomerDetails({
    Key key,
    @required this.customerDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey,
      child: Column(
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
              'CLIENT DETAILS',
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
                Row(
                  children: [
                    Container(
                      width: SizeConfig.screen_width * 17,
                      height: SizeConfig.screen_height * 3.5,
                      child: Text(
                        'COLLEGE',
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
                        ': ${customerDetails.college}',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.4,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.screen_width * 17,
                      height: SizeConfig.screen_height * 3.5,
                      child: Text(
                        'DEPT',
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
                        ': ${customerDetails.department}',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.4,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.screen_width * 17,
                      height: SizeConfig.screen_height * 3.5,
                      child: Text(
                        'POC',
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
                        ': ${customerDetails.policy}',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.4,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.screen_width * 17,
                      height: SizeConfig.screen_height * 3.5,
                      child: Text(
                        'POC MOB',
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
                        ': ${customerDetails.policyNo}',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.4,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: SizeConfig.screen_width * 17,
                      height: SizeConfig.screen_height * 3.5,
                      child: Text(
                        'MACHINE SL.NO',
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
                        ': ${customerDetails.machineNo}',
                        style: TextStyle(
                          fontSize: SizeConfig.font_height * 2.4,
                        ),
                      ),
                    ),
                  ],
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
                        customerDetails.isWarrentyExpired
                            ? 'INACTIVE'
                            : 'ACTIVE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: SizeConfig.font_height * 2.4,
                          backgroundColor: customerDetails.isWarrentyExpired
                              ? AppColors.red
                              : AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
