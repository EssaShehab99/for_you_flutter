import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
     int? blood;
     int? socialStatus;
    int? gender;
    bool isEdit = false;
    User? user = Provider.of<UserManager>(context).getUser;
    if (user != null) {
      isEdit = true;

      nameController.text = user.name;
      phoneController.text = user.phone;
      ageController.text = user.age.toString();
      heightController.text = user.height.toString();
      weightController.text = user.weight.toString();
      gender = user.gender;
      blood = user.blood;
      socialStatus = user.socialStatus;
    }
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
                    enabled: !isEdit,
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
                    items: ConstantValues.gender,
                    hint: "gender".tr(),
                    selectedValue: gender==null?null:ConstantValues.gender[gender],
                    onChanged: (value) {
                      gender=ConstantValues.gender.indexOf(value);
                    }),
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
                    items: ConstantValues.bloodType,
                    hint: "blood-type".tr(),
                    selectedValue: blood==null?null:ConstantValues.bloodType[blood],
                    onChanged: (value) {
                      blood = ConstantValues.bloodType.indexOf(value);
                    }),
                DropdownInput(
                    items: ConstantValues.socialStatusList,
                    hint: "social-status".tr(),
                    selectedValue: socialStatus==null?null:ConstantValues.socialStatusList[socialStatus],
                    onChanged: (value) {
                      socialStatus = ConstantValues.socialStatusList.indexOf(value);
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
                      if (value == null || value != passwordController.text) {
                        return 'not-match'.tr();
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    controller: TextEditingController(),
                    hint: "confirm".tr(),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Components.MainButton(
                        children: [
                          isLoading
                              ? CircularProgressIndicator(
                            color: ColorsApp.white,
                          )
                              : Text(
                            isEdit ? "edit".tr() : "next".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: ColorsApp.white),
                          )
                        ],
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            setState((){
                              isLoading=true;
                            });
                            if (!isEdit) {
                              Provider.of<UserManager>(context, listen: false)
                                  .setUser(User(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      age: int.parse(ageController.text),
                                      height: double.parse(heightController.text),
                                      weight: double.parse(weightController.text),
                                      blood: blood!,
                                      gender: gender!,
                                      socialStatus: socialStatus!,
                                      password: passwordController.text));
                              // Provider.of<SignUpDAO>(context, listen: false).user =
                              //     Provider.of<UserManager>(context, listen: false)
                              //         .getUser;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerifyPhone(),
                                  ));
                            } else {
                              Provider.of<SignUpDAO>(context, listen: false)
                                  .updateUser(User(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      age: int.parse(ageController.text),
                                      height: double.parse(heightController.text),
                                      weight: double.parse(weightController.text),
                                      blood: blood!,
                                      gender: gender!,
                                      socialStatus: socialStatus!,
                                      password: passwordController.text)).whenComplete((){
                                setState((){
                                  isLoading=false;
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green,
                                    content:  Text("success-edit".tr(),style: Theme.of(context).textTheme.bodyText1?.copyWith(color: CupertinoColors.white),),
                                  ));
                                });
                                Provider.of<UserManager>(context, listen: false)
                                    .setUser(User(
                                    name: nameController.text,
                                    phone: phoneController.text,
                                    age: int.parse(ageController.text),
                                    height: double.parse(heightController.text),
                                    weight: double.parse(weightController.text),
                                    blood: blood!,
                                    gender: gender!,
                                    socialStatus: socialStatus!,
                                    password: passwordController.text));
                              });
                            }
                          }
                        });
                  }
                ),
                SizedBox(
                  height: 10,
                ),
                if (!isEdit)
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
