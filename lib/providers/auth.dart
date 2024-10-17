import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import '/constants/api_path.dart' as endpoints;
import 'package:http/http.dart' as http;

import '../utils/services/http_exception.dart';
import '../utils/services/local_storage_service.dart';
// import 'basics.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _refresh;
  DateTime? _tokenExpiryDate;
  DateTime? _refreshExpiryDate;
  String? _userId;
  Map<String, dynamic>? _me;
  Timer? _authTimer;
  static const Map<String, String> _headers = {
    "content-type": "application/json",
    "accept": "application/json",
  };

  bool get isAuth => _userId != null; // bool get isAuth => token != null;

  //
  String? get token {
    if (_tokenExpiryDate != null &&
        _tokenExpiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId => _userId;
  Map<String, dynamic>? get me => _me;
  bool get isStaff => true; // isAuth && _me!['is_staff'];
  bool get isSuperuser => true; // isAuth && _me!['is_superuser'];

  int sidemenuIndex = 0;

  Future<void> _authenticate({Map<String, dynamic> authData = const {}}) async {
    // print("authData ${authData}");

    var endpoint = Uri.parse(endpoints.refresh);
    String method = 'POST';
    http.MultipartRequest request = http.MultipartRequest(method, endpoint);

    // // Add form fields to the request
    // request.fields['refresh'] = _refresh!;

    if (authData.isNotEmpty) {
      // print(" if (authData.isNotEmpty)");
      endpoint = Uri.parse(endpoints.login);
      request = http.MultipartRequest(method, endpoint);

      request.fields['BiometricCode'] = authData['username'];
      request.fields['Password'] = authData['password'];
    }

    try {
      // Send the multipart request and get the response
      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      var state = decodedData['state'];
      var msg = decodedData['msg'];
      if (state == -1) {
        throw HttpException(msg);

        /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException", BUT catch (error) in the place that call "login() function" can't distinguish between general errors and HttpException errors
        // throw 'Authentication failed';
      }

      // if (decodedData['detail'] != null) {
      //   throw HttpException(decodedData['detail']);

      //   /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException",
      //   /// BUT catch (error) in the place that calls "login() function" can't distinguish
      //   /// between general errors and HttpException errors
      //   // throw 'Authentication failed';
      // }

      _token = decodedData['data']['accessToken'];
      // _refresh = decodedData['data']['refresh'];
      _userId = decodedData['data']['employeeId'].toString();
      _me = decodedData['data']['profile'];
      _me!['photo'] = decodedData['data']['photo'];

      // /// _tokenExpiryDate
      // List<String> tokenSplit = _token!.split('.');
      // Map<String, dynamic> tokenPayload = jsonDecode(
      //     ascii.decode(base64.decode(base64.normalize(tokenSplit[1]))));
      // _tokenExpiryDate =
      //     DateTime.fromMillisecondsSinceEpoch(tokenPayload['exp'] * 1000);

      // /// _refreshExpiryDate
      // List<String> refreshSplit = _refresh!.split('.');
      // Map<String, dynamic> refreshPayload = jsonDecode(
      //     ascii.decode(base64.decode(base64.normalize(refreshSplit[1]))));
      // _refreshExpiryDate =
      //     DateTime.fromMillisecondsSinceEpoch(refreshPayload['exp'] * 1000);

      // _userId = tokenPayload['user_id'].toString();

      // _refreshLoginTimer();

      // if (authData.isNotEmpty) {
      //   await fetchAndSetMe();
      // }

      Map<String, dynamic> loggedInUserData = {
        'token': _token,
        // 'refresh': _refresh,
        // 'tokenExpiryDate': _tokenExpiryDate!
        //     .toIso8601String(), // convert DateTime object type to String
        // 'refreshExpiryDate': _refreshExpiryDate!.toIso8601String(),
        'userId': _userId,
      };

      final encodedUserData = jsonEncode(loggedInUserData);
      // final loggedinUserDataInstance = loggedin()..data = loggedInUserData;
      // await LocalStorageService.setLoggedInUserData(loggedinUserDataInstance);

      await LocalStorageService.setLoggedInUserData(encodedUserData);
      await LocalStorageService.setMe(jsonEncode(_me));

      // print(await SecureStorageService.getLoggedInUserData());
      notifyListeners();
    } catch (e) {
      // print("I am in _authenticate catch (e) $e");
      rethrow;
      // throw e;
    }
  }

  Future<void> fetchAndSetMe() async {
    var me = await http.get(Uri.parse(endpoints.me),
        headers: {'Authorization': 'Bearer $_token'});

    final String utf8DecodedData = utf8.decode(me.bodyBytes);
    // final Map<String, dynamic> decotedMe = jsonDecode(me.body); // can't decode arabic or kurdish or Latin characters
    final Map<String, dynamic> decotedMe = jsonDecode(utf8DecodedData);

    // Map<String, dynamic>? rp = decotedMe['AnswererProfile'];
    // if (rp != null) {
    //   rp.update(
    //       'avatar', (value) => value == null ? null : '$serverAddress$value');
    //   rp.update('cover_image',
    //       (value) => value == null ? null : '$serverAddress$value');
    //   decotedMe.update('AnswererProfile', (value) => rp);
    // }
    // print("HHH: ${decotedMe}");
    _me = decotedMe;
    await LocalStorageService.setMe(jsonEncode(_me));
  }

  Future<void> login(Map<String, dynamic> authData) async {
    return _authenticate(authData: authData);
  }

  Future<bool> tryAutoLogin() async {
    // print("tryAutoLogin()");
    final fetchedUserData = LocalStorageService.getLoggedInUserData();
    if (fetchedUserData == null) {
      return false;
    }
    // final tokenExpiryDate = DateTime.tryParse(fetchedUserData[
    //     'tokenExpiryDate']); // convert String type to DateTime object
    // final refreshExpiryDate =
    //     DateTime.tryParse(fetchedUserData['refreshExpiryDate']);

    // if (tokenExpiryDate!.isBefore(DateTime.now())) {
    //   if (refreshExpiryDate!.isBefore(DateTime.now())) {
    //     logout();
    //     return false;
    //   }
    //   _refresh = fetchedUserData['refresh'];

    //   try {
    //     await _refreshLogin();
    //     return true; // Refresh Login Success
    //   } catch (e) {
    //     rethrow;
    //     // throw e;
    //   }
    // }
    _token = fetchedUserData['token'];
    // _refresh = fetchedUserData['refresh'];
    // _tokenExpiryDate = tokenExpiryDate;
    // _refreshExpiryDate = refreshExpiryDate;
    _userId = fetchedUserData['userId'];
    _me = LocalStorageService.getMe();
    notifyListeners();
    // _refreshLoginTimer();
    return true;
  }

  Future<bool> _refreshLogin() async {
    // print('I am in Auth() in _refreshLogin()');
    try {
      await _authenticate(); // don't send "authData" argument to refresh login
      _me = LocalStorageService.getMe();
      return true; // Refresh Login Success
    } catch (e) {
      rethrow;
      // throw e;
    }
  }

  void _refreshLoginTimer() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _tokenExpiryDate!.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeToExpiry), _refreshLogin);
  }

  Future<void> logout() async {
    _token = null;
    _refresh = null;
    _tokenExpiryDate = null;
    _refreshExpiryDate = null;
    _userId = null;
    _me = null;
    sidemenuIndex = 0;

    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    await LocalStorageService.deleteLoggedInUserData();
    await LocalStorageService.deleteMe();
  }

  Future<void> getOTP(Map<String, dynamic> body) async {
    try {
      final http.Response res = await http.post(
        Uri.parse(endpoints.getOTP),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // _privileges = jsonDecode(utf8DecodedData);
      final decodedData = jsonDecode(
          res.body); // can't decode arabic or kurdish or Latin characters
      if (res.statusCode != 200) {
        throw '$decodedData';
      }
      // print("HHH res ${res.statusCode}");
      // print("HHH decodedData ${decodedData}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyOTP(Map<String, dynamic> body) async {
    try {
      final http.Response res = await http.post(
        Uri.parse(endpoints.verifyOTP),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // _privileges = jsonDecode(utf8DecodedData);
      final decodedData = jsonDecode(
          res.body); // can't decode arabic or kurdish or Latin characters
      if (res.statusCode != 200) {
        throw '$decodedData';
      }
      // print("HHH res ${res.statusCode}");
      // print("HHH decodedData ${decodedData}");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(Map<String, dynamic> body) async {
    try {
      final http.Response res = await http.post(
        Uri.parse(endpoints.resetPassword),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // _privileges = jsonDecode(utf8DecodedData);
      final decodedData = jsonDecode(
          res.body); // can't decode arabic or kurdish or Latin characters
      if (res.statusCode == 200) {
        return;
      } else if (decodedData['password'] != null) {
        // print("HHH res ${res.statusCode}");
        // print("HHH decodedData ${decodedData['password']}");
        throw HttpException(decodedData['password'].toString());
      } else {
        throw '$decodedData';
      }
    } catch (e) {
      // print("HHH ${e}");
      rethrow;
    }
  }
}
