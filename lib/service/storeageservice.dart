import 'package:shared_preferences/shared_preferences.dart';

class Storage {

  getLoginStatus() async {
    final pref = await SharedPreferences.getInstance();
    final status = pref.getBool("loginStatus");
    return status;
  }
}
