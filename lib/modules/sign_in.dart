import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as Services;
import '/data/setting/config.dart';
import '/modules/home.dart';
import '/modules/sign_up.dart';
import '/styles/colors_app.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:provider/provider.dart';
import '/data/models/user.dart';
import '/data/network/sign_in_dao.dart';
import '/data/providers/user_manager.dart';
import '/shared/components.dart';
import '/shared/custom_button.dart';
import '/shared/text_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:easy_localization/easy_localization.dart' as localized;

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> _authenticateWithBiometrics(BuildContext context) async {
    bool isAuth = false;
    try {

      bool authStatus = await auth.authenticate(
          androidAuthStrings: AndroidAuthMessages(
              signInTitle: "auth-confirm".tr(), biometricHint: ""),
          localizedReason: 'scan-fingerprint'.tr(),
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true);
      if (authStatus) {
        List<String>? userData = await Config.getUser();
        if (userData != null) {
          isAuth = true;
          User? user = await Provider.of<SignInDAO>(context, listen: false)
              .signIn(userData[0], userData[1]);
          if (user != null) {
            Provider.of<UserManager>(context, listen: false).setUser(user);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ));
          }
        }
      } else {
        isAuth = true;
      }
    } on Services.PlatformException catch (e) {
      isAuth = true;
      showErrorDialog(
        context,
      );
      return false;
    } catch (e) {
      isAuth = true;
      showErrorDialog(context);
      return false;
    }
    return isAuth;
  }

  showErrorDialog(BuildContext context) =>
      Components.showCustomDialog(context: context, children: [
        Center(
            child: Icon(
          Icons.info_outline,
          color: ColorsApp.primary,
          size: 35,
        )),
        Text(
          "error-authentication".tr(),
          style: Theme.of(context).textTheme.headline1,
        )
      ]);
  Future<bool> _onBackPressed(context) async{
    return await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title:  Text("are-sure".tr(),
          style: Theme.of(context).textTheme.headline1,),
        content:  Text("do-you-exit".tr(),
          style: Theme.of(context).textTheme.headline1,),
        actionsPadding: EdgeInsets.only(right:10.0,bottom:10.0),
        actions: <Widget>[
           GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("no".tr() ,style: Theme.of(context)
        .textTheme
        .bodyText1)),
          SizedBox(height: 16),
           GestureDetector(
            onTap: () => exit(0),
            child: Text("yes".tr(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    bool? isValidate = true;
    bool? isValidateFinger = true;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () {

          _onBackPressed(context);
          return Future.value(false);
        },
        child: Scaffold(
          body: Components.bodyScreens([
            Flexible(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInput(
                      textDirection: TextDirection.ltr,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'validate-value'.tr();
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      hint: "phone-number".tr(),
                      icon: Icons.phone_android),
                  TextInput(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'validate-value'.tr();
                        }
                        return null;
                      },
                      controller: passwordController,
                      hint: "password".tr(),
                      icon: Icons.password),
                  StatefulBuilder(
                    builder: (context, setState) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isValidate != null && !(isValidate!))
                          Flexible(
                            child: Text(
                              "incorrect-data".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(color: Colors.red, fontSize: 15),
                            ),
                          ),
                        CustomButton(
                            children: [
                              Text(
                                "sign-in".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: ColorsApp.white),
                              )
                            ],
                            isLoading: isValidate == null,
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isValidate = null;
                                });

                                final encrypter =
                                encrypt.Encrypter(encrypt.AES(User.key));
                                encrypt.Encrypted encrypted = encrypter.encrypt(
                                    passwordController.text,
                                    iv: User.iv);
                                Provider.of<SignInDAO>(context, listen: false)
                                    .signIn(
                                    phoneController.text, encrypted.base64)
                                    .then((value) {
                                  if (value != null) {
                                    Provider.of<UserManager>(context,
                                        listen: false)
                                        .setUser(value);
                                    Config.setUser(
                                        phoneController.text, encrypted.base64);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
                                        ));
                                  } else {
                                    setState(() {
                                      isValidate = false;
                                    });
                                  }
                                });
                              }
                            }),
                        CustomButton(
                            children: [
                              Icon(Icons.fingerprint,
                                  color: ColorsApp.white, size: 35),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "sign-in-by-finger".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: ColorsApp.white),
                              )
                            ],
                            isLoading: isValidateFinger == null,
                            onTap: () {
                              setState(() {
                                isValidateFinger = null;
                              });
                              _authenticateWithBiometrics(context).then((value) {
                                setState(() {
                                  isValidateFinger = false;
                                });
                              });

                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(operationType: OperationType.Add),
                          ));
                    },
                    child: Text(
                      "has-not-account".tr(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            Colors.white.withOpacity(0.0))),
                  )
                ],
              ),
            ))
          ]),
        ),
      ),
    );
  }
}
