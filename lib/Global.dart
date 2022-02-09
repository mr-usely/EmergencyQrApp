import 'User.dart';

class G {
  static List<User>? users = [];

  static User? loggedUser;

  static List<User> getUsers(User user) {
    List<User> filteredUsers = users!
        .where((e) => (!e.firstName!
            .toLowerCase()
            .contains(user.firstName!.toLowerCase())))
        .toList();

    return filteredUsers;
  }
}
