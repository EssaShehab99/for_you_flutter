import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/data/models/user.dart';
import 'package:for_you_flutter/data/providers/checkup_manager.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/data/setting/config.dart';
import 'package:for_you_flutter/modules/sign_in.dart';
import 'package:for_you_flutter/shared/dropdown_input.dart';
import 'package:for_you_flutter/styles/theme_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'data/models/checkup.dart';
import 'data/providers/app_state_manager.dart';
import 'data/providers/hospitals_manager.dart';
import 'data/providers/user_manager.dart';
import 'modules/associated_hospitals.dart';
import 'modules/checkups_screen.dart';
import 'modules/description.dart';
import 'modules/questionnaires_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      saveLocale: true,
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppStateManager()),
      ChangeNotifierProvider(create: (context) => HospitalManager()..initial(ConstantValues.hospitalsList)),
      ChangeNotifierProvider(create: (context) => CheckupManager()..setItems(ConstantValues.checkupList)),
      ChangeNotifierProvider(create: (context) => UserManager()..setUser(User(name: "براء", phone: "555666999", age: 20, height: 1.8, weight: 56, blood: "O+", socialStatus: "married".tr()))),
      ChangeNotifierProvider(create: (context) => QuestionnairesManager()..setItems(ConstantValues.questionnaireList)),
    ],child: Consumer<AppStateManager>(
      builder: (context, value, child) {
        Config.getLocal(context);
        return MaterialApp(
        home: SafeArea(child: AssociatedHospitals()),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
          theme: ThemeApp.light,
      );
      },
    ),);
  }
}
