import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:for_you_flutter/styles/colors_app.dart';

import '../constants/constant_images.dart';
import '../constants/constant_values.dart';
import '../shared/components.dart';
import '../shared/locale_switch.dart';
import '../shared/text_input.dart';

class SignUp extends StatelessWidget {
   SignUp({Key? key}) : super(key: key);
 final TextEditingController phoneController=TextEditingController();
 final TextEditingController passwordController=TextEditingController();

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
                    child: SvgPicture.asset(ConstantImage.logo,
                        width: double.infinity,height: 200,),
                  )),
              Flexible(
                  child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInput(controller: phoneController,hint: "phone-number".tr(), icon: Icons.person),
                    TextInput(controller: passwordController,hint: "password".tr(), icon: Icons.email),
                    Components.MainButton(children: [Text("sign-in".tr(),style: Theme.of(context).textTheme.bodyText1,)],onTap:(){}),
                    Components.MainButton(children: [Icon(Icons.fingerprint,color: ColorsApp.primary,size: 35),SizedBox(width: 20,),Text("sign-in-by-finger".tr(),style: Theme.of(context).textTheme.bodyText1,)], onTap: () {}),
                    SizedBox(height: 10,),
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("has-not-account".tr(),
                      style: Theme.of(context).textTheme.bodyText1,),style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.0))),)
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
