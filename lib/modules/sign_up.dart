import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/modules/questionnaires_screen.dart';
import 'package:for_you_flutter/shared/dropdown_input.dart';
import 'package:for_you_flutter/styles/colors_app.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        controller: nameController,
                        hint: "name".tr()),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: phoneController,
                        hint: "phone-number".tr()),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: phoneController,
                        hint: "age".tr()),
                    DropdownInput(items: ["man".tr(),"woman".tr()],hint: "gender".tr(),onChanged: (value){}),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: phoneController,
                        hint: "height".tr()),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: phoneController,
                        hint: "weight".tr()),
                    DropdownInput(items: ["A+","A-","B+","A-","O+","O-","AB"],hint: "blood-type".tr(),onChanged: (value){}),
                    DropdownInput(items: ["married".tr(),"celibate".tr(),"widower".tr()],hint: "social-status".tr(),onChanged: (value){}),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: phoneController,
                        hint: "password".tr(),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true),
                    TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'validate-value'.tr();
                          }
                          return null;
                        },
                        controller: phoneController,
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionnairesScreen(),
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
            ],
          ),
        ),
      ),
    );
  }
}
