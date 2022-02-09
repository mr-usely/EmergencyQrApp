import 'package:emergency_app/CreateAccountScreen.dart';
import 'package:emergency_app/LoginScreen.dart';
import 'package:emergency_app/ScanQRScreen.dart';
import 'package:emergency_app/main_page.dart';
import 'package:emergency_app/QRScreen.dart';

class Routes {
  //
  static routes() {
    return {
      MainPage.ROUTE_ID: (context) => MainPage(),
      LoginScreen.ROUTE_ID: (context) => LoginScreen(),
      ScanQrScreen.ROUTE_ID: (context) => ScanQrScreen(),
      QRScreen.ROUTE_ID: (context) => QRScreen(),
      CreateAccountScreen.ROUTE_ID: (context) => CreateAccountScreen(),
    };
  }

  static initScreen() {
    return MainPage.ROUTE_ID;
  }
}
