import 'package:emergency_app/widgets/pages/CreateAccountScreen/CreateAccountScreen.dart';
import 'package:emergency_app/widgets/pages/LoginScreen/LoginScreen.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/MyProfileScreen.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/ProfileDetailsScreen.dart';
import 'package:emergency_app/widgets/pages/ScanQRScreen/ScanQRScreen.dart';
import 'package:emergency_app/widgets/pages/MainPage/main_page.dart';
import 'package:emergency_app/widgets/pages/QRScreen/QRScreen.dart';

class Routes {
  //
  static routes() {
    return {
      MainPage.ROUTE_ID: (context) => const MainPage(),
      LoginScreen.ROUTE_ID: (context) => const LoginScreen(),
      ScanQrScreen.ROUTE_ID: (context) => const ScanQrScreen(),
      QRScreen.ROUTE_ID: (context) => const QRScreen(),
      CreateAccountScreen.ROUTE_ID: (context) => const CreateAccountScreen(),
      MyProfileScreen.ROUTE_ID: (context) => const MyProfileScreen(),
      ProfileDetailsScreen.ROUTE_ID: (context) => const ProfileDetailsScreen()
    };
  }

  static initScreen() {
    return MainPage.ROUTE_ID;
  }
}


// Color(0xFFFF6961) - Red

// Color(0xFFFFE080) - Yellow