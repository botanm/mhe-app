import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/core.dart';

class LocalStorageService {
  /*
  https://www.youtube.com/watch?v=w8cZKm9s228
*/

  // static const _loggedinBoxName = 'loggedinBox';
  static const _boxName = 'localStorageBox';
  // static Box get _loggedinBox => Hive.box<loggedin>(_loggedinBoxName);
  static Box get _localStorageBox => Hive.box(_boxName);

  static const _keyLocale = 'locale';
  static const _keyLocalizedTexts = 'localizedTexts';
  static const _keyLoggedInUserData = 'loggedInUserData';
  static const _keyMe = 'me';
  static const _keyMyQuestions = 'myQuestions';
  static const _keyBookmarks = 'bookmarks';
  static const _keyDocHistory = 'docHistory';

  static Future<void> initialize() async {
    await Hive.initFlutter();
    // Hive.registerAdapter(loggedinAdapter());
    // await Hive.openBox<loggedin>(_loggedinBoxName);
    await Hive.openBox(_boxName);
  }

  static Future<void> setLocale(String locale) async {
    try {
      await _localStorageBox.put(_keyLocale, locale);
    } catch (e) {
      // Handle errors
      print('Error setting locale: $e');
    }
  }

  static String? getLocale() {
    try {
      return _localStorageBox.get(_keyLocale) as String?;
    } catch (e) {
      // Handle errors
      print('Error getting locale: $e');
      return null;
    }
  }

  static Future<void> setLocalizedTexts(String localizedTexts) async {
    try {
      await _localStorageBox.put(_keyLocalizedTexts, localizedTexts);
    } catch (e) {
      // Handle errors
      print('Error setting localized texts: $e');
    }
  }

  static String? getLocalizedTexts() {
    try {
      return _localStorageBox.get(_keyLocalizedTexts) as String?;
    } catch (e) {
      // Handle errors
      print('Error getting localized texts: $e');
      return null;
    }
  }

  static Future<void> setLoggedInUserData(String userData) async {
    try {
      await _localStorageBox.put(_keyLoggedInUserData, userData);
    } catch (e) {
      // Handle errors
      print('Error setting logged-in user data: $e');
    }
  }

  static Map<String, dynamic>? getLoggedInUserData() {
    try {
      final value = _localStorageBox.get(_keyLoggedInUserData) as String?;
      return value == null ? null : jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      // Handle errors
      print('Error getting logged-in user data: $e');
      return null;
    }
  }

  static Future<void> deleteLoggedInUserData() async {
    try {
      await _localStorageBox.delete(_keyLoggedInUserData);
    } catch (e) {
      // Handle errors
      print('Error deleting logged-in user data: $e');
    }
  }

  static Future<void> setMe(String me) async {
    try {
      await _localStorageBox.put(_keyMe, me);
    } catch (e) {
      // Handle errors
      print('Error setting me data: $e');
    }
  }

  static Map<String, dynamic>? getMe() {
    try {
      final value = _localStorageBox.get(_keyMe) as String?;
      return value == null ? null : jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      // Handle errors
      print('Error getting me data: $e');
      return null;
    }
  }

  static Future<void> deleteMe() async {
    try {
      await _localStorageBox.delete(_keyMe);
    } catch (e) {
      // Handle errors
      print('Error deleting me data: $e');
    }
  }

// Set a new question ID in the local storage
  static Future<void> setNewQuestion(int id) async {
    try {
      String? value = _localStorageBox.get(_keyMyQuestions) as String?;

      if (value == null) {
        value = jsonEncode([id]);
      } else {
        List<int> newList = List<int>.from(jsonDecode(value));
        newList.add(id); // Add to the end of the list
        // _newList.insert(0, id); // Uncomment to add to the start of the list
        value = jsonEncode(newList);
      }
      await _localStorageBox.put(_keyMyQuestions, value);
    } catch (e) {
      print('Error setting new question: $e');
    }
  }

// Get the list of question IDs from local storage
  static Future<List<int>?> getMyQuestions() async {
    try {
      final String? value = _localStorageBox.get(_keyMyQuestions) as String?;

      return value == null ? null : List<int>.from(jsonDecode(value));
    } catch (e) {
      print('Error getting my questions: $e');
      return null;
    }
  }

// Remove a question ID from the list in local storage
  static Future<void> removeInMyQuestion(
      BuildContext context, String id) async {
    try {
      String? value = _localStorageBox.get(_keyMyQuestions) as String?;
      if (value != null) {
        List<int> newList = List<int>.from(jsonDecode(value));
        newList.remove(int.parse(id));
        value = jsonEncode(newList);
      }
      await _localStorageBox.put(_keyMyQuestions, value);
      Provider.of<Core>(context, listen: false).removeInMyQuestion(id);
    } catch (e) {
      print('Error removing question: $e');
    }
  }

// Set a new bookmark ID in the local storage
  static Future<void> setBookmark(int id) async {
    try {
      String? value = _localStorageBox.get(_keyBookmarks) as String?;

      if (value == null) {
        value = jsonEncode([id]);
      } else {
        List<int> newList = List<int>.from(jsonDecode(value));
        newList.add(id); // Add to the end of the list
        // _newList.insert(0, id); // Uncomment to add to the start of the list
        value = jsonEncode(newList);
      }
      await _localStorageBox.put(_keyBookmarks, value);
    } catch (e) {
      print('Error setting bookmark: $e');
    }
  }

// Get the list of bookmark IDs from local storage
  static Future<List<int>?> getBookmarks() async {
    try {
      final String? value = _localStorageBox.get(_keyBookmarks) as String?;

      return value == null ? null : List<int>.from(jsonDecode(value));
    } catch (e) {
      print('Error getting bookmarks: $e');
      return null;
    }
  }

// Remove a bookmark ID from the list in local storage
  static Future<void> removeInBookmarks(String id) async {
    try {
      String? value = _localStorageBox.get(_keyBookmarks) as String?;
      if (value != null) {
        List<int> newList = List<int>.from(jsonDecode(value));
        newList.remove(int.parse(id));
        value = jsonEncode(newList);
      }
      await _localStorageBox.put(_keyBookmarks, value);
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

// Set a new document history in the local storage
  static Future<void> setDocHistory(Map<String, dynamic> data) async {
    try {
      String? value = _localStorageBox.get(_keyDocHistory) as String?;
      if (value == null) {
        value = jsonEncode([data]);
      } else {
        List<Map<String, dynamic>> newList =
            List<Map<String, dynamic>>.from(jsonDecode(value));
        newList.add(data); // Add to the end of the list
        // _newList.insert(0, data); // Uncomment to add to the start of the list
        value = jsonEncode(newList);
      }
      await _localStorageBox.put(_keyDocHistory, value);
    } catch (e) {
      print('Error setting document history: $e');
    }
  }

// Get the list of document histories from local storage
  static Future<List<Map<String, dynamic>>?> getDocHistory() async {
    try {
      final String? value = _localStorageBox.get(_keyDocHistory) as String?;

      return value == null
          ? null
          : List<Map<String, dynamic>>.from(jsonDecode(value));
    } catch (e) {
      print('Error getting document history: $e');
      return null;
    }
  }

// Remove a document history from the list in local storage
  static Future<void> removeInDocHistory(Map<String, dynamic> data) async {
    try {
      String? value = _localStorageBox.get(_keyDocHistory) as String?;
      if (value != null) {
        List<Map<String, dynamic>> newList =
            List<Map<String, dynamic>>.from(jsonDecode(value));
        newList.removeWhere((element) =>
            element['refNo'] == data['refNo'] &&
            element['refDate'] == data['refDate'] &&
            element['branchId'] == data['branchId']);
        value = jsonEncode(newList);
      }
      await _localStorageBox.put(_keyDocHistory, value);
    } catch (e) {
      print('Error removing document history: $e');
    }
  }
  //     String? value = _localStorageBox.get(_keyMyQuestions) as String?;
  //     if (value != null) {
  //       List<int> newList = List<int>.from(jsonDecode(value));
  //       newList.remove(int.parse(id));
  //       value = jsonEncode(newList);
  //     }

  //     await _localStorageBox.put(_keyMyQuestions, value);
  //     Provider.of<Core>(context, listen: false).removeInMyQuestion(id);
  //   } catch (e) {
  //     // Handle errors
  //     print('Error removing question: $e');
  //   }
  // }
// }
}


// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import '../../models/loggedin.dart';

// class LocalStorageService {
//   static final _storage = FlutterSecureStorage();

  // static const _keyLocale = 'locale';
  // static const _keyLocalizedTexts = 'localizedTexts';
  // static const _keyContentLocale = 'contentLocales';
  // static const _keyLoggedInUserData = 'loggedInUserData';
  // static const _keyMe = 'me';
  // static const _keyMyQuestions = 'myQuestions';
  // static const _keyBookmarks = 'bookmarks';

  // static const _keyUsername = 'username';
  // static const _keyPets = 'pets';
  // static const _keyBirthday = 'birthday';


  // static Future setLocale(String locale) async =>
  //     await _storage.write(key: _keyLocale, value: locale);

  // static Future<String?> getLocale() async =>
  //     await _storage.read(key: _keyLocale);

  // static Future setContentLocales(List<String> locales) async =>
  //     await _storage.write(key: _keyContentLocale, value: jsonEncode(locales));

  // static Future<List<String>?> getContentLocales() async {
  //   final value = await _storage.read(key: _keyContentLocale);

  //   return value == null ? null : List<String>.from(jsonDecode(value));
  // }

  // static Future setUserData(userData) async {
  //   await _storage.write(key: _keyUserData, value: userData);
  // }

  // static Future<Map<String, dynamic>?> getUserData() async {
  //   final value = await _storage.read(key: _keyUserData);

  //   return value == null ? null : Map<String, dynamic>.from(jsonDecode(value));
  // }

  // static Future deleteUserData() async {
  //   await _storage.delete(key: _keyUserData);
  // }

  // static Future setMe(me) async {
  //   await _storage.write(key: _keyMe, value: me);
  // }

  // static Future<Map<String, dynamic>?> getMe() async {
  //   final value = await _storage.read(key: _keyMe);

  //   return value == null ? null : Map<String, dynamic>.from(jsonDecode(value));
  // }

  // static Future deleteMe() async {
  //   await _storage.delete(key: _keyMe);
  // }

  // static Future setNewQuestion(int id) async {
  //   String? value = await _storage.read(key: _keyMyQuestions);

  //   if (value == null) {
  //     value = jsonEncode([id]);
  //   } else {
  //     List<int> _newList = List<int>.from(jsonDecode(value));
  //     _newList.add(id); // _newList.insert(0, id); // at the start of the list
  //     value = jsonEncode(_newList);
  //   }
  //   await _storage.write(key: _keyMyQuestions, value: value);
  // }

  // static Future<List<int>?> getMyQuestions() async {
  //   final String? value = await _storage.read(key: _keyMyQuestions);

  //   return value == null ? null : List<int>.from(jsonDecode(value));
  // }

  // static Future removeInMyQuestion(BuildContext context, String id) async {
  //   String? value = await _storage.read(key: _keyMyQuestions);
  //   if (value != null) {
  //     List<int> _newList = List<int>.from(jsonDecode(value));
  //     _newList.remove(int.parse(id));
  //     value = jsonEncode(_newList);
  //   }
  //   await _storage.write(key: _keyMyQuestions, value: value);
  //   Provider.of<Centers>(context, listen: false).removeInMyQuestion(id);
  // }

  // static Future setBookmark(int id) async {
  //   String? value = await _storage.read(key: _keyBookmarks);

  //   if (value == null) {
  //     value = jsonEncode([id]);
  //   } else {
  //     List<int> _newList = List<int>.from(jsonDecode(value));
  //     _newList.add(id); // _newList.insert(0, id); // at the start of the list
  //     value = jsonEncode(_newList);
  //   }
  //   await _storage.write(key: _keyBookmarks, value: value);
  // }

  // static Future<List<int>?> getBookmarks() async {
  //   final String? value = await _storage.read(key: _keyBookmarks);

  //   return value == null ? null : List<int>.from(jsonDecode(value));
  // }

  // static Future removeInBookmarks(String id) async {
  //   String? value = await _storage.read(key: _keyBookmarks);
  //   if (value != null) {
  //     List<int> _newList = List<int>.from(jsonDecode(value));
  //     _newList.remove(int.parse(id));
  //     value = jsonEncode(_newList);
  //   }
  //   await _storage.write(key: _keyBookmarks, value: value);
  // }

  // static Future setUsername(String username) async =>
  //     await _storage.write(key: _keyUsername, value: username);
  //
  // static Future<String?> getUsername() async =>
  //     await _storage.read(key: _keyUsername);
  //
  // static Future setPets(List<String> pets) async {
  //   final value = json.encode(pets);
  //
  //   await _storage.write(key: _keyPets, value: value);
  // }
  //
  // static Future<List<String>?> getPets() async {
  //   final value = await _storage.read(key: _keyPets);
  //
  //   return value == null ? null : List<String>.from(json.decode(value));
  // }
  //
  // static Future setBirthday(DateTime dateOfBirth) async {
  //   final birthday = dateOfBirth.toIso8601String(); // convert DateTime object type to String
  //
  //   await _storage.write(key: _keyBirthday, value: birthday);
  // }
  //
  // static Future<DateTime?> getBirthday() async {
  //   final birthday = await _storage.read(key: _keyBirthday);
  //
  //   return birthday == null ? null : DateTime.tryParse(birthday); // convert String type to DateTime object
  // }
// }
