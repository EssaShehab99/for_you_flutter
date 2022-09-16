import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:for_you_flutter/data/setting/config.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '/styles/colors_app.dart';

class LocaleSwitch extends StatelessWidget {
  const LocaleSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ToggleSwitch(
      minWidth: 90.0,
      cornerRadius: 20.0,
      activeBgColors: [[ColorsApp.primary], [ColorsApp.primary]],
      activeFgColor: ColorsApp.white,
      inactiveBgColor: ColorsApp.grey,
      inactiveFgColor: ColorsApp.white,
      initialLabelIndex: EasyLocalization.of(context)?.currentLocale==Locale('ar', 'SA')?0:1,
      totalSwitches: 2,
      labels: ['AR', 'EN'],
      radiusStyle: true,
      onToggle: (index) {
        if(index==0) {
          Config.setLocal(false,context);
        } else
          Config.setLocal(true,context);
      },
    );
  }
}
