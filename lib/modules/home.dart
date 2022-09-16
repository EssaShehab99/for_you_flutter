import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '/data/network/account_dao.dart';
import '/data/providers/user_manager.dart';
import '/modules/associated_hospitals.dart';
import '/modules/questionnaires_screen.dart';
import '/modules/sign_in.dart';
import '/modules/sign_up.dart';
import '/styles/colors_app.dart';
import 'package:provider/provider.dart';

import '/constants/constant_images.dart';
import '/data/network/sign_up_dao.dart';
import '/data/providers/checkup_manager.dart';
import '/data/providers/hospitals_manager.dart';
import '/data/providers/questionnaires_manager.dart';
import '/shared/components.dart';
import '/shared/custom_button.dart';
import 'checkups_screen.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AccountDAO accountDAO = Provider.of<AccountDAO>(context);
    QuestionnairesManager questionnairesManager =
        Provider.of<QuestionnairesManager>(context);
    CheckupManager checkupManager =
        Provider.of<CheckupManager>(context);
    HospitalManager hospitalManager =
        Provider.of<HospitalManager>(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SignIn(),
              ));
          return Future.value(false);
        },
        child: Scaffold(

          body: Components.bodyScreens([
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
                child: buildColumn(
                    onTapOne: () {
                      Components.showCustomDialog(context: context, children: [
                        Text(
                          "beneficiaries-message".tr(),
                          style: Theme.of(context).textTheme.headline1,
                          textAlign: TextAlign.justify,
                        ),
                        CustomButton(
                            children: [
                              Text(
                                "ok".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: ColorsApp.white),
                              )
                            ],
                            onTap: () {
                              Navigator.pop(context);
                            }),
                      ]);
                    },
                    onTapTow: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(operationType: OperationType.Edit),
                          ));
                    },
                    textOne: "beneficiaries".tr(),
                    imageOne: ConstantImage.iconFive,
                    textTwo: "personal-information".tr(),
                    imageTow: ConstantImage.iconFour)),
            Flexible(
                child: buildColumn(
                    onTapTow: () async {
                       BuildContext? dialogContext;
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) {
                            dialogContext = ctx;
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 25),
                                  CircularProgressIndicator(),
                                  SizedBox(height: 25),
                                  CustomButton(
                                      children: [
                                        Text(
                                          "cancel".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(color: ColorsApp.white),
                                        )
                                      ],
                                      onTap: () {
                                        Navigator.pop(dialogContext!);
                                        dialogContext=null;
                                      }),
                                ],
                              ),
                            );
                          });
                      accountDAO.getQuestionnaires().then((value) {
                        if(dialogContext!=null){
                          Navigator.pop(dialogContext!);
                          questionnairesManager.setItems(value);
                          questionnairesManager.isCloud = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuestionnairesScreen()));
                        }
                      });

                      // Navigator.push(context,MaterialPageRoute(builder: (context) => QuestionnairesScreen()));
                    },
                    onTapOne: () {
                      BuildContext? dialogContext;
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) {
                            dialogContext = ctx;
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 25),
                                  CircularProgressIndicator(),
                                  SizedBox(height: 25),
                                  CustomButton(
                                      children: [
                                        Text(
                                          "cancel".tr(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.copyWith(color: ColorsApp.white),
                                        )
                                      ],
                                      onTap: () {
                                        Navigator.pop(dialogContext!);
                                        dialogContext=null;
                                      }),
                                ],
                              ),
                            );
                          });
                      accountDAO.getCheckups().then((value) {
                        if(dialogContext!=null){
                          Navigator.pop(dialogContext!);
                          checkupManager.setItems(value);
                          checkupManager.isCloud = true;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CheckupsScreen()));
                        }
                      });
                    },
                    textOne: "medical-examinations".tr(),
                    imageOne: ConstantImage.iconOne,
                    textTwo: "medical-history".tr(),
                    imageTow: ConstantImage.iconSix)),
            Flexible(
                child: buildColumn(
                  onTapOne: () {
                    BuildContext? dialogContext;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (ctx) {
                          dialogContext = ctx;
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 25),
                                CircularProgressIndicator(),
                                SizedBox(height: 25),
                                CustomButton(
                                    children: [
                                      Text(
                                        "cancel".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            ?.copyWith(color: ColorsApp.white),
                                      )
                                    ],
                                    onTap: () {
                                      Navigator.pop(dialogContext!);
                                      dialogContext=null;
                                    }),
                              ],
                            ),
                          );
                        });
                    accountDAO.getHospitals().then((value) {
                      if(dialogContext!=null){
                        Navigator.pop(dialogContext!);
                        value.forEach((element) {
                          hospitalManager.checkHospital(element.id,element.location,element.name);
                        });
                        hospitalManager.isCloud = true;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AssociatedHospitals()));
                      }
                    });
                  },
                    textOne: "hospital-network".tr(),
                    imageOne: ConstantImage.iconFive,
                    textTwo: "phone".tr(),
                    onTapTow: (){
                      Components.launchUrl("920022776",call: true);
                    },
                    imageTow: ConstantImage.iconThree)),
            Flexible(
              child: CustomButton(
                  children: [
                    Text(
                      "log-out".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: ColorsApp.white),
                    )
                  ],
                  onTap: () {
                    Provider.of<SignUpDAO>(context, listen: false).auth.signOut();
                    Provider.of<UserManager>(context, listen: false).signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignIn(),
                        ));
                  }),
            )
          ]),
        ),
      ),
    );
  }

  Column buildColumn(
      {required String textOne,
      required String imageOne,
      required String textTwo,
      required String imageTow,
      GestureTapCallback? onTapOne,
      GestureTapCallback? onTapTow}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Row(
            children: [
              Expanded(
                child: Components.homeCard(
                    text: textOne, icon: imageOne, onTap: onTapOne),
              ),
              Expanded(
                child: Components.homeCard(
                    text: textTwo, icon: imageTow, onTap: onTapTow),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
