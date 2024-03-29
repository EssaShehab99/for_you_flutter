import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:for_you_flutter/constants/constant_values.dart';
import 'package:for_you_flutter/data/network/sign_in_dao.dart';
import 'package:for_you_flutter/data/providers/checkup_manager.dart';
import 'package:for_you_flutter/data/providers/questionnaires_manager.dart';
import 'package:for_you_flutter/data/setting/config.dart';
import 'package:for_you_flutter/modules/description.dart';
import 'package:for_you_flutter/styles/theme_app.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'data/network/account_dao.dart';
import 'data/network/sign_up_dao.dart';
import 'data/providers/app_state_manager.dart';
import 'data/providers/hospitals_manager.dart';
import 'data/providers/user_manager.dart';
import 'modules/sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      saveLocale: true,
      child: MyApp(Initial: await Config.getInitial(),)));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,required this.Initial}) : super(key: key);
final bool Initial;
  @override
  Widget build(BuildContext context) {

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateManager()),
        ChangeNotifierProvider(
            create: (context) =>
                HospitalManager()..setItems(ConstantValues.hospitalsList)),
        ChangeNotifierProvider(
            create: (context) =>
                CheckupManager()..setItems(ConstantValues.checkupList)),
        ChangeNotifierProvider(create: (context) => SignInDAO()),
        ChangeNotifierProvider(create: (context) => UserManager()
             /*..setUser(User(
                  name: "براء",
                  phone: "+967773380265",
                  age: 20,
                  gender: 1,
                  height: 1.8,
                  weight: 56,
                  blood: 1,
                  socialStatus: 1,
                  password: 'a')
              )*/
            ),
        ChangeNotifierProxyProvider<UserManager, SignUpDAO>(
          create: (context) => SignUpDAO(
              user: Provider.of<UserManager>(context, listen: false).getUser),
          update: (context, userManager, _) =>
              SignUpDAO(user: userManager.getUser),
        ),
        ChangeNotifierProvider(
            create: (context) => QuestionnairesManager()
              ..setItems(ConstantValues.questionnaireList)),
        ChangeNotifierProxyProvider<UserManager, AccountDAO>(
          create: (context) => AccountDAO(
              userManager: Provider.of<UserManager>(context, listen: false)),
          update: (context, userManager, _) =>
              AccountDAO(userManager: userManager),
        ),
      ],
      child: Consumer<AppStateManager>(
        builder: (context, value, child) {
          Config.getLocal(context);
          return MaterialApp(
            home: SafeArea(child: Initial?SignIn():Description()),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: ThemeApp.light,
          );
        },
      ),
    );
  }
}
