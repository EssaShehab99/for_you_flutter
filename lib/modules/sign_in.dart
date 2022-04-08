import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/modules/home.dart';
import 'package:for_you_flutter/modules/sign_up.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../data/network/sign_up_dao.dart';
import '../data/providers/user_manager.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool? isValidate=true;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ConstantValues.padding),
        child: Column(
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
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInput(
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
                          if(isValidate!=null&& !(isValidate!)) Flexible(
                            child: Text(
                              "invalid-code".tr(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(color: Colors.red, fontSize: 15),
                            ),
                          ),
                          Components.MainButton(
                              children: [
                                isValidate==null
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
                                  final key = encrypt.Key.fromUtf8(
                                      'my 32 length key................');
                                  final iv = encrypt.IV.fromLength(16);
                                  final encrypter =
                                      encrypt.Encrypter(encrypt.AES(key));
                                  var encrypted = encrypter
                                      .encrypt(passwordController.text, iv: iv);
                                  Provider.of<SignUpDAO>(context, listen: false)
                                      .signIn(
                                          phoneController.text, encrypted.base64)
                                      .then((value) {
                                    if (value != null) {
                                      Provider.of<UserManager>(context,
                                              listen: false)
                                          .setUser(value);
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
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                          child: Icon(
                                        Icons.info_outline,
                                        color: ColorsApp.primary,
                                        size: 35,
                                      )),
                                      Text(
                                        "slide-fingerprint".tr(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      )
                                    ],
                                  ),
                                ));
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
          ],
        ),
      ),
    );
  }
}
