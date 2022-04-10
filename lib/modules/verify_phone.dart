import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' as localized;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/models/user.dart';
import 'package:for_you_flutter/data/network/sign_up_dao.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:for_you_flutter/modules/questionnaires_screen.dart';
import 'package:for_you_flutter/shared/dropdown_input.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';

class VerifyPhone extends StatefulWidget {
  VerifyPhone({Key? key}) : super(key: key);

  @override
  State<VerifyPhone> createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final TextEditingController verifyCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late SignUpDAO signUpDAO;
  bool invalidVerification = false;

  @override
  void initState() {
    signUpDAO = Provider.of<SignUpDAO>(context, listen: false);
    signUpDAO.verifyPhone(
        verificationCompleted: (phoneAuthCredential) {
          setState(() {
            verifyCodeController.text = phoneAuthCredential.smsCode!;
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          setState(() {
            invalidVerification = true;
          });
        },
        codeSent: (
          String verificationId,
          int? forceResendingToken,
        ) async {
          signUpDAO.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Components.bodyScreens([
          Flexible(
              child: Center(
                child: Wrap(
                  children: [
                    Text(
                      "code-was-send".tr() +
                          ": " +
                          Provider.of<UserManager>(context, listen: false)
                              .getUser!
                              .phone,
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.0))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "edit".tr(),
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 15),
                      ),
                    ),
                    TweenAnimationBuilder(
                        duration:
                        Duration(seconds: UserManager.DURATION_TIME_OUT),
                        tween: Tween(
                            begin: Duration(
                                minutes: UserManager.DURATION_TIME_OUT),
                            end: Duration.zero),
                        onEnd: () {
                          setState(() {
                            invalidVerification = false;
                          });
                        },
                        builder: (BuildContext context, Duration value, _) {
                          return Text(
                            "${value.inMinutes}",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                ?.copyWith(color: Colors.blue, height: 2.35),
                          );
                        }),
                  ],
                ),
              )),
          Flexible(
              child: SizedBox(
                height: 50,
              )),
          Flexible(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'invalid-code'.tr();
                          }
                          return null;
                        },
                        textDirection: TextDirection.ltr,
                        controller: verifyCodeController,
                        keyboardType: TextInputType.number,
                        hint: "code".tr()),
                  ],
                ),
              )),
          Flexible(
              child: Components.MainButton(
                  children: [
                    Text(
                      "active-account".tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(color: ColorsApp.white),
                    )
                  ],
                  onTap: () {
                    // Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) =>
                    //                     QuestionnairesScreen(),
                    //               ));
                    signUpDAO.verificationCode(
                        smsCode: verifyCodeController.text,
                        onSuccess: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    QuestionnairesScreen(),
                              ));
                        },
                        onClick: () {
                          setState(() {
                            invalidVerification = false;
                          });
                        },
                        onFailed: () {
                          setState(() {
                            invalidVerification = true;
                          });
                        });
                  })),
          if (invalidVerification)
            Flexible(
              child: Text(
                "invalid-code".tr(),
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    ?.copyWith(color: Colors.red, fontSize: 15),
              ),
            )
        ]),
      ),
    );
  }
}
