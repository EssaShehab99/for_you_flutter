import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/providers/hospitals_manager.dart';
import 'package:for_you_flutter/shared/associated_card.dart';
import 'package:for_you_flutter/shared/dropdown_input.dart';
import 'package:for_you_flutter/shared/map_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/providers/user_manager.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../styles/colors_app.dart';

class AssociatedHospitals extends StatelessWidget {
  const AssociatedHospitals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(ConstantValues.padding),
          child: Consumer<HospitalManager>(
            builder:(context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: LocaleSwitch(),
                  ),
                  Flexible(
                      child: SizedBox(
                    height: 50,
                  )),
                  Flexible(
                      flex: 3,
                      child: Center(
                        child: SvgPicture.asset(
                          ConstantImage.logo,
                          width: double.infinity,
                          height: 200,
                        ),
                      )),
                  Flexible(
                      child: SizedBox(
                    height: 50,
                  )),
                  Flexible(
                      child: Center(
                    child: Text(
                      "welcome".tr() +
                          " " +
                          Provider.of<UserManager>(context, listen: false)
                              .getUser!
                              .name,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )),
                  Flexible(
                      child: SizedBox(
                    height: 50,
                  )),
                  Flexible(
                      child: AssociatedCard(
                    onChanged: (String value) {
                    },
                  )),
                  if(value.hospitalList[8].isChecked)
                  Flexible(child: Container(
                      height: 400,
                      width: double.infinity,
                      padding: EdgeInsets.all(ConstantValues.padding*0.5),
                      margin: EdgeInsets.only(top: ConstantValues.padding),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: ColorsApp.white,
                          boxShadow: [
                            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
                          ]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        child: MapCard(onTapMap: (point) {
                          value.hospitalList[8].location=point;
                        },initialPosition: LatLng(24.71320026053638, 46.67536760671966),
                        ),
                      ),
                  )),
                  Flexible(child: Components.MainButton(
                      children: [
                        Text(
                          "sign-up".tr(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: ColorsApp.white),
                        )
                      ],
                      onTap: () {
                      }),)
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
