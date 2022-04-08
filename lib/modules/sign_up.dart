import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/data/models/user.dart';
import 'package:for_you_flutter/data/network/sign_up_dao.dart';
import 'package:for_you_flutter/data/providers/user_manager.dart';
import 'package:for_you_flutter/modules/questionnaires_screen.dart';
import 'package:for_you_flutter/modules/verify_phone.dart';
import 'package:for_you_flutter/shared/dropdown_input.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:provider/provider.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String blood;
  late String socialStatus;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: nameController,
                        hint: "name".tr()),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        hint: "phone-number".tr()),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        hint: "age".tr()),
                    DropdownInput(
                        items: ["man".tr(), "woman".tr()],
                        hint: "gender".tr(),
                        onChanged: (value) {}),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: heightController,
                        keyboardType: TextInputType.number,
                        hint: "height".tr()),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: weightController,
                        keyboardType: TextInputType.number,
                        hint: "weight".tr()),
                    DropdownInput(
                        items: ["A+", "A-", "B+", "B-", "O+", "O-", "AB"],
                        hint: "blood-type".tr(),
                        onChanged: (value) {
                          blood = value;
                        }),
                    DropdownInput(
                        items: [
                          "married".tr(),
                          "celibate".tr(),
                          "widower".tr()
                        ],
                        hint: "social-status".tr(),
                        onChanged: (value) {
                          socialStatus = value;
                        }),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: passwordController,
                        hint: "password".tr(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true),
                    TextInput(
                        validator: (value) {
                          if (value == null || value!=passwordController.text) {
                            return 'not-match'.tr();
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        controller: TextEditingController(),
                        hint: "confirm".tr(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true),
                    Components.MainButton(
                        children: [
                          Text(
                            "next".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: ColorsApp.white),
                          )
                        ],
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Provider.of<UserManager>(context,listen: false).setUser(User(
                              name: nameController.text,
                                phone: phoneController.text,
                                age: int.parse(ageController.text),
                                height: double.parse(heightController.text),
                                weight: double.parse(weightController.text),
                                blood: blood,
                                socialStatus: socialStatus,
                                password: passwordController.text));
                          Provider.of<SignUpDAO>(context, listen: false).user=Provider.of<UserManager>(context, listen: false).getUser;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyPhone(),
                              ));
                          }
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "has-account".tr(),
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
