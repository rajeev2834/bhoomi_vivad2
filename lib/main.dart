import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/screens/home_screen.dart';
import 'package:bhoomi_vivad/screens/login.dart';
import 'package:bhoomi_vivad/screens/splash_screen.dart';
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
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Bhoomi Bank Nawada",
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
          },
        ),
      ),
    );
  }
}