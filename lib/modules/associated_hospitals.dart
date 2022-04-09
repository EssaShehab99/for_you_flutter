import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/models/checkup.dart';
import 'package:for_you_flutter/data/models/hospital.dart';
import 'package:for_you_flutter/data/models/questionnaire.dart';
import 'package:for_you_flutter/data/network/account_dao.dart';
import 'package:for_you_flutter/data/providers/checkup_manager.dart';
import 'package:for_you_flutter/data/providers/hospitals_manager.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/shared/associated_card.dart';
import 'package:for_you_flutter/shared/map_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/constant_values.dart';
import '../data/providers/user_manager.dart';
import '../shared/components.dart';
import '../styles/colors_app.dart';
import 'home.dart';

class AssociatedHospitals extends StatelessWidget {
  const AssociatedHospitals({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Questionnaire> questionnaires =
        Provider.of<QuestionnairesManager>(context, listen: false)
            .questionnaireList;

    List<Checkup> checkupList =
        Provider.of<CheckupManager>(context, listen: false).checkupList;
    List<Hospital> hospitalList =
        Provider.of<HospitalManager>(context, listen: false).hospitalList;
    bool isLoading = false;

    return SafeArea(
      child: Scaffold(
        body: Consumer<HospitalManager>(builder: (context, value, child) {
          return Components.bodyScreens([
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
              onChanged: (String value) {},
            )),
            if (value.hospitalList[8].isChecked)
              Flexible(
                  child: Container(
                height: 400,
                width: double.infinity,
                padding: EdgeInsets.all(ConstantValues.padding * 0.5),
                margin: EdgeInsets.only(top: ConstantValues.padding),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: ColorsApp.white,
                    boxShadow: [
                      BoxShadow(
                          color: ColorsApp.shadow,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: MapCard(
                    onTapMap: (point) {
                      value.hospitalList[8].location = point;
                    },
                    initialPosition:
                        LatLng(24.71320026053638, 46.67536760671966),
                  ),
                ),
              )),
            Flexible(
              child: StatefulBuilder(builder: (context, setState) {
                return Components.MainButton(
                    children: [
                      isLoading
                          ? CircularProgressIndicator(
                              color: ColorsApp.white,
                            )
                          : Text(
                              "sign-up".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: ColorsApp.white),
                            )
                    ],
                    onTap: () {
                      if(!isLoading){
                        Provider.of<AccountDAO>(context, listen: false)
                            .setInformation(
                            hospitalList: hospitalList,
                            checkupList: checkupList,
                            questionnaires: questionnaires)
                            .whenComplete(() {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(),
                              ));
                          setState(() {
                            isLoading = false;
                          });
                        });
                      }
                      setState(() {
                        isLoading = true;
                      });

                    });
              }),
            )
          ]);
        }),
      ),
    );
  }
}
