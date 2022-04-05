import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:for_you_flutter/constants/constant_images.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/modules/sign_in.dart';
import 'package:for_you_flutter/shared/locale_switch.dart';
import 'package:for_you_flutter/styles/colors_app.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../data/setting/config.dart';

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ConstantValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                child: SvgPicture.asset(ConstantImage.logo,
                    width: double.infinity)),
            Flexible(
                child: SizedBox(
              height: 50,
            )),
            Flexible(
                child: Text(
              "title-desc".tr(),
              style: Theme.of(context).textTheme.headline1,
            )),
            Flexible(
                flex: 4,
                child: Text(
                  "details-desc".tr(),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.justify,
                )),
            Flexible(
                child: Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => SignIn(),));
                },
                child: Text("skip".tr(),
                  style: Theme.of(context).textTheme.headline1,),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
