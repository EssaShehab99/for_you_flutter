import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:for_you_flutter/constants/constant_images.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/modules/sign_in.dart';
import 'package:for_you_flutter/shared/components.dart';
import 'package:for_you_flutter/shared/locale_switch.dart';

class Description extends StatelessWidget {
  const Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Components.bodyScreens([    Flexible(
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
            ))]),
    );
  }
}
