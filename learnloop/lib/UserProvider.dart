// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class UserProvider with ChangeNotifier {
//   User? _user;
//
//   User? get user => _user;
//
//   //get isLoggedIn => null;
//
//   void setUser(User user) {
//     _user = user;
//     notifyListeners();
//   }
//
//   void clearUser() {
//     _user = null;
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> loadSession() async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null && session.user != null) {
      _user = session.user;
    } else {
      _user = null;
    }
    notifyListeners();
  }
}
