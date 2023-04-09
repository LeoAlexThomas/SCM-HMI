import 'package:StirCastingMachine/data/data.dart';
import 'package:StirCastingMachine/services/size_config.dart';
import 'package:flutter/material.dart';

class CustomerDetails extends StatelessWidget {
  final String college;
  final String department;
  final String policy;
  final int policyNo;
  final int machineNo;
  final bool isWarrentyExpired;
  const CustomerDetails({
    Key? key,
    required this.college,
    required this.department,
    required this.policy,
    required this.policyNo,
    required this.machineNo,
    required this.isWarrentyExpired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                value: college,
              ),
              CustomerCard(
                title: 'DEPT',
                value: department,
              ),
              CustomerCard(
                title: 'POC',
                value: policy,
              ),
              CustomerCard(
                title: 'POC MOB',
                value: policyNo.toString(),
              ),
              CustomerCard(
                title: 'MACHINE SL.NO',
                value: machineNo.toString(),
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
                      isWarrentyExpired ? 'INACTIVE' : 'ACTIVE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: SizeConfig.font_height * 2.4,
                        backgroundColor:
                            isWarrentyExpired ? AppColors.red : AppColors.green,
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
