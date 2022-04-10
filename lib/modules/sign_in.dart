import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as Services;
import 'package:for_you_flutter/data/setting/config.dart';
import 'package:for_you_flutter/modules/home.dart';
import 'package:for_you_flutter/modules/sign_up.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:provider/provider.dart';
import '../data/models/user.dart';
import '../data/network/sign_in_dao.dart';
import '../data/network/sign_up_dao.dart';
import '../data/providers/user_manager.dart';
import '../shared/components.dart';
import '../shared/text_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:easy_localization/easy_localization.dart' as localized;


class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      auth
          .authenticate(
              androidAuthStrings: AndroidAuthMessages(
                  signInTitle: "auth-confirm".tr(), biometricHint: ""),
              localizedReason: 'scan-fingerprint'.tr(),
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true)
          .then((value) {
        if (value) {
          Config.getUser().then((value) {
            if (value != null) {
              Provider.of<SignInDAO>(context, listen: false)
                  .signIn(value[0], value[1])
                  .then((value) {
                if (value != null) {
                  Provider.of<UserManager>(context, listen: false)
                      .setUser(value);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Home(),
                      ));
                }
              });
            }
          });
        }
      });
    } on Services.PlatformException catch (e) {
      showErrorDialog(
        context,
      );
      return;
    } catch (e) {
      showErrorDialog(context);
    }
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

  @override
  Widget build(BuildContext context) {
    bool? isValidate = true;

    return SafeArea(
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
                  builder: (context, setState) {
                    return Column(
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
                        Components.MainButton(
                            children: [
                              isValidate == null
                                  ? CircularProgressIndicator(
                                      color: ColorsApp.white,
                                    )
                                  : Text(
                                      "sign-in".tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(color: ColorsApp.white),
                                    )
                            ],
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
                      ],
                    );
                  },
                ),
                Components.MainButton(
                    children: [
                      Icon(Icons.fingerprint, color: ColorsApp.white, size: 35),
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
                    onTap: () {
                      _authenticateWithBiometrics(context);
                    }),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
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
    );
  }
}
