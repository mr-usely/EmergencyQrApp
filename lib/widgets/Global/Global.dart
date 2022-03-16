import 'package:emergency_app/widgets/Models/Contacts.dart';
import 'package:emergency_app/widgets/Models/Pathologies.dart';
import 'package:emergency_app/widgets/Models/ScannedUser.dart';

import '../Models/User.dart';

class G {
  static List<User>? users = [];

  static List<Pathologies>? pathologies = [];

  static List<Contacts>? contacts = [];

  static User? loggedUser;
  static ScannedUser? scannedUser;
  static Pathologies? getPathologies;
  static Contacts? getContacts;

  static bool? isScanned;

  // server link
  static const link = 'https://emergency-app-server.herokuapp.com';

  static List<User> getUsers(User user) {
    List<User> filteredUsers = users!
        .where((e) => (!e.firstName!
            .toLowerCase()
            .contains(user.firstName!.toLowerCase())))
        .toList();

    return filteredUsers;
  }
}
