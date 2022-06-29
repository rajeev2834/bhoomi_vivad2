import 'package:bhoomi_vivad/providers/addBaseData.dart';
import 'package:bhoomi_vivad/providers/auth.dart';
import 'package:bhoomi_vivad/providers/get_base_data.dart';
import 'package:bhoomi_vivad/screens/admin_module/screens/admin_dashboard.dart';
import 'package:bhoomi_vivad/screens/admin_module/screens/admin_home.dart';
import 'package:bhoomi_vivad/screens/all_vivad/status_update_provider.dart';
import 'package:bhoomi_vivad/screens/all_vivad/status_update_screen.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_pending_screen.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_report_screen.dart';
import 'package:bhoomi_vivad/screens/all_vivad/vivad_summary_screen.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/get_api_data.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/grievance_screen.dart';
import 'package:bhoomi_vivad/screens/grievance_entry/tracking_id_screen.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_timeline_screen.dart';
import 'package:bhoomi_vivad/screens/hearing_timeline/hearing_update_provider.dart';
import 'package:bhoomi_vivad/screens/home_screen.dart';
import 'package:bhoomi_vivad/screens/landing/help_screen.dart';
import 'package:bhoomi_vivad/screens/landing/landing_screen.dart';
import 'package:bhoomi_vivad/screens/login.dart';
import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_provider.dart';
import 'package:bhoomi_vivad/screens/upload_vivad/upload_vivad_screen.dart';
import 'package:bhoomi_vivad/screens/verify_otp/send_otp_screen.dart';
import 'package:bhoomi_vivad/screens/verify_otp/verify_otp_provider.dart';
import 'package:bhoomi_vivad/screens/verify_otp/verify_otp_screen.dart';
import 'package:bhoomi_vivad/screens/vivad_entry/vivad_entry_screen.dart';
import 'package:bhoomi_vivad/utils/size_config.dart';
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
        ChangeNotifierProvider.value(
          value: StatusUpdateProvider(),
        ),
        ChangeNotifierProvider.value(
          value: HearingUpdateProvider(),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Bhoomi Vivad",
                theme: ThemeData(
                  primarySwatch: Colors.indigo,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: Landing(),
                routes: {
                  GrievanceEntryScreen.routeName: (context) =>
                      GrievanceEntryScreen(),
                  SendOTPScreen.routeName: (context) => SendOTPScreen(),
                  VerifyOTPScreen.routeName: (context) => VerifyOTPScreen(),
                  TrackingIdScreen.routeName: (context) => TrackingIdScreen(),
                  Login.routeName: (context) => Login(),
                  HomeScreen.routeName: (context) => HomeScreen(),
                  AdminHomeScreen.routeName: (context) => AdminHomeScreen(),
                  DashboardScreen.routeName: (context) => DashboardScreen(),
                  UploadVivadScreen.routeName: (context) => UploadVivadScreen(),
                  VivadEntryScreen.routeName: (context) => VivadEntryScreen(),
                  VivadPendingScreen.routeName: (context) =>
                      const VivadPendingScreen(),
                  StatusUpdateScreen.routeName: (context) =>
                      StatusUpdateScreen(),
                  HearingTimeLineScreen.routeName: (context) =>
                      HearingTimeLineScreen(),
                  VivadSummaryScreen.routeName: (context) =>
                      VivadSummaryScreen(),
                  VivadReportScreen.routeName: (context) => VivadReportScreen(),
                  HelpScreen.routeName: (context) => HelpScreen(),
                },
              );
            },
          );
        },
      ),
    );
  }
}
