import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/models/checkup.dart';
import 'package:for_you_flutter/data/models/hospital.dart';
import 'package:for_you_flutter/data/models/questionnaire.dart';
import 'package:for_you_flutter/data/network/account_dao.dart';
import 'package:for_you_flutter/data/providers/checkup_manager.dart';
import 'package:for_you_flutter/data/providers/hospitals_manager.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/shared/map_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../constants/constant_values.dart';
import '../data/providers/user_manager.dart';
import '../shared/components.dart';
import '../shared/dropdown_input.dart';
import '../shared/text_input.dart';
import '../styles/colors_app.dart';
import 'home.dart';

class AssociatedHospitals extends StatelessWidget {
  AssociatedHospitals({Key? key}) : super(key: key);
  final BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  double? calculateDistance(lat1, lon1, lat2, lon2) {
    if(lat1!=null&&lon1!=null&&lat2!=null&&lon2!=null){
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    Components.checkPermission(context);
    bool isEdit = false;
    AccountDAO accountDAO = Provider.of<AccountDAO>(context, listen: false);
    List<Questionnaire> questionnaires =
        Provider.of<QuestionnairesManager>(context, listen: false)
            .questionnaireList;
    List<Checkup> checkupList =
        Provider.of<CheckupManager>(context, listen: false).checkupList;
    HospitalManager hospitalManager =
        Provider.of<HospitalManager>(context, listen: false);
    bool isLoading = false;
    if (hospitalManager.isCloud) {
      isEdit = true;
      hospitalManager.hospitalList.forEach((element) {});
    }
    UserManager userManager=Provider.of<UserManager>(context,listen: false);
    return SafeArea(
      child: Scaffold(
        body: Consumer<HospitalManager>(builder: (context, value, child) {
          return SlidingUpPanel(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(ConstantValues.radius)),
            panel: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 3,
                    width: 30,
                    margin: EdgeInsets.all(ConstantValues.padding),
                    decoration: BoxDecoration(
                        color: ColorsApp.primary,
                        borderRadius:
                            BorderRadius.circular(ConstantValues.radius)),
                  ),
                ),
                Expanded(
                    child: ListView(
                  children: [
                    for (var item in hospitalManager.hospitalList
                        .where((element) => element.isChecked == true))
                      Container(
                          height: 175,
                          width: double.infinity,
                          padding: EdgeInsets.all(ConstantValues.padding),
                          margin: EdgeInsets.only(
                              top: ConstantValues.padding,
                              left: ConstantValues.padding,
                              right: ConstantValues.padding),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ConstantValues.radius)),
                              color: ColorsApp.primary,
                              boxShadow: [
                                BoxShadow(
                                    color: ColorsApp.shadow,
                                    blurRadius: 1,
                                    spreadRadius: 1)
                              ]),
                          child: InkWell(
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(item.name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                ?.copyWith(
                                                    fontSize: 15,
                                                    color: ColorsApp.white)),
                                      ),
                                      Flexible(
                                        child: Consumer<UserManager>(

                                          builder: (context, value, child) => Text("${calculateDistance(item.location?.latitude, item.location?.longitude, value.location?.latitude, value.location?.longitude)?.toStringAsFixed(2)} " + "km".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                      fontSize: 15,
                                                      color: ColorsApp.white)),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                  ],
                ))
              ],
            ),
            minHeight: 30,
            body: Components.bodyScreens([
              Flexible(
                  child: Center(
                child: Text(
                  "welcome".tr() +
                      " " +
                      userManager
                          .getUser!
                          .name,
                  style: Theme.of(context).textTheme.headline1,
                ),
              )),
              Flexible(
                  child: SizedBox(
                height: 50,
              )),
              Flexible(child: _AssociatedCard()),
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
                      initialPosition: value.hospitalList[8].location ??
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
                                isEdit ? "edit".tr() : "sign-up".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: ColorsApp.white),
                              )
                      ],
                      onTap: () {
                        if (!isLoading) {
                          setState(() {
                            isLoading = true;
                            if (isEdit) {
                              accountDAO
                                  .updateHospitals(hospitalManager.hospitalList)
                                  .whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "success-edit".tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                              color: CupertinoColors.white),
                                    ),
                                  ));
                                });
                              });
                            } else {
                              accountDAO
                                  .setInformation(
                                      hospitalList:
                                          hospitalManager.hospitalList,
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
                          });
                        }
                      });
                }),
              ),
              Flexible(
                  child: SizedBox(
                height: 50,
              ))
            ]),
          );
        }),
      ),
    );
  }
}

class _AssociatedCard extends StatefulWidget {
  const _AssociatedCard({
    Key? key,
  }) : super(key: key);

  @override
  State<_AssociatedCard> createState() => _AssociatedCardState();
}

class _AssociatedCardState extends State<_AssociatedCard> {
  bool isAnother = false;
  late TextEditingController anotherController;
  late HospitalManager hospitalManager;

  @override
  void initState() {
    hospitalManager = Provider.of<HospitalManager>(context, listen: false);
    anotherController = TextEditingController();
    if(hospitalManager.hospitalList[8].isChecked){
      anotherController.text=hospitalManager.hospitalList[8].name!;
      anotherController.addListener(() {
        // if(anotherController.text!=null)
        hospitalManager.setHospitalName(9, anotherController.text);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    anotherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isAnother=hospitalManager.hospitalList[8].isChecked;
    if(hospitalManager.hospitalList[8].isChecked)
      anotherController.text=hospitalManager.hospitalList[8].name!;

    return Container(
      height: 175,
      width: double.infinity,
      padding: EdgeInsets.all(ConstantValues.padding),
      margin: EdgeInsets.only(top: ConstantValues.padding),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: ColorsApp.white,
          boxShadow: [
            BoxShadow(color: ColorsApp.shadow, blurRadius: 1, spreadRadius: 1)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: DropdownInput(
                width: 200,
                isCheckBox: true,
                onCheckBox: (List<bool> list) {
                  for (int i = 0; i < list.length; i++) {
                    if (list[i] == true) {
                      Provider.of<HospitalManager>(context, listen: false)
                          .setCheck(i, true);
                    } else {
                      Provider.of<HospitalManager>(context, listen: false)
                          .setCheck(i, false);
                    }
                  }
                  setState(() {
                    if (list[8] == true)
                      isAnother = true;
                    else
                      isAnother = false;
                  });
                },
                hint: "associated-hospitals".tr(),
                items: List<String>.generate(
                    Provider.of<HospitalManager>(context, listen: false)
                        .hospitalList
                        .length,
                        (index) => Provider.of<HospitalManager>(context, listen: false)
                        .hospitalList[index]
                        .name!),
              )),
          isAnother
              ? TextInput(
            controller: anotherController,
            hint: "associated-hospitals".tr(),
            textInputAction: TextInputAction.done,
          )
              : SizedBox.shrink()
        ],
      ),
    );
  }
}
