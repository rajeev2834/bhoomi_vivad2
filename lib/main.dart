import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/providers/get_base_data.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_report_screen.dart';
import 'package:bhoomi_vivad/screens/home_screen.dart';
import 'package:bhoomi_vivad/screens/login.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:bhoomi_vivad/screens/vivad_entry/vivad_entry_screen.dart';
import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BhoomiVivad());
}

class BhoomiVivad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: AddBaseData(),
        ),
        ChangeNotifierProvider.value(
          value: GetBaseData(),
        ),
        ChangeNotifierProvider.value(
          value: UploadVivadProvider(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Bhoomi Vivad",
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? HomeScreen()
              : FutureBuilder(
            future: auth.autoLogin(),
            builder: (ctx, authResultSnapshot) =>
            authResultSnapshot.connectionState ==
                ConnectionState.waiting
                ? MySplashScreen()
                : Login(),
          ),
          routes: {
            UploadVivadScreen.routeName: (context) => UploadVivadScreen(),
            VivadEntryScreen.routeName: (context) => VivadEntryScreen(),
            VivadReportScreen.routeName: (context) => VivadReportScreen(),
          },
        ),
      ),
    );
  }
}