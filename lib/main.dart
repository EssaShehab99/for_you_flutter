import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/data/setting/config.dart';
import 'package:for_you_flutter/modules/sign_in.dart';
import 'package:for_you_flutter/styles/theme_app.dart';
import 'package:provider/provider.dart';

import 'data/providers/app_state_manager.dart';
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

    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AppStateManager()),
      ChangeNotifierProvider(create: (context) => QuestionnairesManager()..setItems(ConstantValues.questionnaireList)),
    ],child: Consumer<AppStateManager>(
      builder: (context, value, child) {
        Config.getLocal(context);
        return MaterialApp(
        home: SafeArea(child: QuestionnairesScreen()),
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
