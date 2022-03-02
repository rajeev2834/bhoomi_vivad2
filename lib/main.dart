import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/providers/get_base_data.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_report_screen.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/grievance_screen.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/grievance_status_screen.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/tracking_id_screen.dart';
import 'package:bhoomi_vivad/screens/home_screen.dart';
import 'package:bhoomi_vivad/screens/landing/landing_screen.dart';
import 'package:bhoomi_vivad/screens/login.dart';
import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:bhoomi_vivad/screens/verify_otp/send_otp_screen.dart';
import 'package:bhoomi_vivad/screens/verify_otp/verify_otp_provider.dart';
import 'package:bhoomi_vivad/screens/verify_otp/verify_otp_screen.dart';
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
        ChangeNotifierProvider.value(
          value: GetApiData(),
        ),
        ChangeNotifierProvider.value(
          value: VerifyOTPProvider(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Bhoomi Vivad",
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Landing(),
          routes: {
            GrievanceEntryScreen.routeName: (context) => GrievanceEntryScreen(),
            SendOTPScreen.routeName: (context) => SendOTPScreen(),
            VerifyOTPScreen.routeName: (context) => VerifyOTPScreen(),
            TrackingIdScreen.routeName: (context) => TrackingIdScreen(),
            GrievanceStatus.routeName: (context) => GrievanceStatus(),
            Login.routeName: (context) => Login(),
            HomeScreen.routeName: (context) => HomeScreen(),
            UploadVivadScreen.routeName: (context) => UploadVivadScreen(),
            VivadEntryScreen.routeName: (context) => VivadEntryScreen(),
            VivadReportScreen.routeName: (context) => VivadReportScreen(),
          },
        ),
    );
  }
}