import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import '../utils/services/local_storage_service.dart';
import '/constants/api_path.dart' as endpoints;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../utils/services/http_exception.dart';

class Core with ChangeNotifier {
  String authToken = '';
  String userId = '';
  bool loggedInIsStaff = false;
  bool loggedInIsSuperuser = false;

  String get loggedInUsername => findUserById(int.parse(userId))['username'];
  List<dynamic> _users = [];
  List<dynamic> _centerReps = [];
  List<dynamic> _questions = [];
  List<dynamic> _answeredQuestions = [];
  List<dynamic> _myQuestions = [];
  List<dynamic> _bookmarkQuestions = [];
  List<dynamic> _roleStats = [];
  List<dynamic> _chartStats = [];
  List<dynamic> _rectangleStats = [];

  Map<String, dynamic>? userSearchData;
  Map<String, dynamic>? questionSearchData;
  Map<String, dynamic>? answeredQuestionSearchData;

  List<int> _bookmarkIDs = [];
  List<int> _myQuestionIDs = [];

  int countQuestions = 0;
  int countAnsweredQuestions = 0;
  int countMyQuestions = 0;
  int countBookmarks = 0;

  String _filterPayloadUsers = '';
  String _filterPayloadQuestions = '';
  String _filterPayloadAnsweredQuestions = '';

  String _nextUsers = '';
  String _nextQuestions = '';
  String _nextAnsweredQuestions = '';
  String _nextMyQuestions = '';
  String _nextBookmarks = '';

  bool _isLoadingUsers = false;
  bool _isLoadingQuestions = false;
  bool _isLoadingAnsweredQuestions = false;
  bool _loadingMyQuestions = false;
  bool _loadingBookmarks = false;

  void update(
      String t, String u, bool isAuthAndStaff, bool isAuthAndSuperuser) {
    authToken = t;

    if (userId != u) _initialization(u, isAuthAndStaff, isAuthAndSuperuser);
  }

  void _initialization(String u, bool isAuthAndStaff, bool isAuthAndSuperuser) {
    userId = u;
    loggedInIsStaff = isAuthAndStaff;
    loggedInIsSuperuser = isAuthAndSuperuser;

    _users = [];
    _centerReps = [];
    _questions = [];
    _answeredQuestions = [];
    _myQuestions = [];
    _bookmarkQuestions = [];

    _bookmarkIDs = [];
    _myQuestionIDs = [];
    _roleStats = [];
    _chartStats = [];
    _rectangleStats = [];

    countQuestions = 0;
    countAnsweredQuestions = 0;
    countMyQuestions = 0;
    countBookmarks = 0;

    _filterPayloadUsers = '';
    _filterPayloadQuestions = '';
    _filterPayloadAnsweredQuestions = '';

    _nextUsers = '';
    _nextQuestions = '';
    _nextAnsweredQuestions = '';
    _nextMyQuestions = '';
    _nextBookmarks = '';

    _isLoadingUsers = false;
    _isLoadingQuestions = false;
    _isLoadingAnsweredQuestions = false;
    _loadingMyQuestions = false;
    _loadingBookmarks = false;

    // fetchAndSetUsers('');
    // fetchAndSetQuestions('');
    // fetchAndSetAnsweredQuestions('');
  }

  Map<String, String>? get _headers {
    return authToken.isNotEmpty ? {'Authorization': 'Bearer $authToken'} : null;
  }

  Map<String, dynamic> getTypeInfo(String type) {
    Map<String, dynamic> info = {};
    switch (type) {
      case "users":
        {
          info = {
            "container": users,
            "isNext": isNextUsers,
            "isLoading": isLoadingUsers,
            "onRefresh": onRefreshUsers,
            "fetchAndSet": fetchAndSetUsers,
            "searchdata": userSearchData
          };
        }
        break;

      case "questions":
        {
          info = {
            "container": questions,
            "isNext": isNextQuestions,
            "isLoading": isLoadingQuestions,
            "onRefresh": onRefreshQuestions,
            "fetchAndSet": fetchAndSetQuestions,
            "searchdata": questionSearchData
          };
        }
        break;

      case "answeredQuestions":
        {
          info = {
            "container": answeredQuestions,
            "isNext": isNextAnsweredQuestions,
            "isLoading": isLoadingAnsweredQuestions,
            "onRefresh": onRefreshAnsweredQuestions,
            "fetchAndSet": fetchAndSetAnsweredQuestions,
            "searchdata": answeredQuestionSearchData
          };
        }
        break;

      case "myquestions":
        {
          info = {
            "container": myquestions,
            "isNext": isNextMyQuestions,
            "isLoading": loadingMyQuestions,
            "onRefresh": onRefreshMyQuestions,
            "fetchAndSet": fetchAndSetMyQuestions,
            "searchdata": null
          };
        }
        break;

      case "bookmarks":
        {
          info = {
            "container": bookmarkQuestions,
            "isNext": isNextBookmarks,
            "isLoading": loadingBookmarks,
            "onRefresh": () async {},
            "fetchAndSet": fetchAndSetBookmarkQuestions,
            "searchdata": null
          };
        }
        break;

      default:
        {
          print("Invalid choice");
        }
        break;
    }
    return info;
  }

  List<dynamic> get users => [..._users];
  List<dynamic> get centerReps => [..._centerReps];
  List<dynamic> get questions => [..._questions];
  List<dynamic> get answeredQuestions => [..._answeredQuestions];
  List<dynamic> get myquestions => [..._myQuestions];
  List<dynamic> get bookmarkQuestions => [..._bookmarkQuestions];
  List<dynamic> get roleStats => [..._roleStats];
  List<dynamic> get chartStats => [..._chartStats];
  List<dynamic> get rectangleStats => [..._rectangleStats];

  String get filterPayloadUsers => _filterPayloadUsers;
  String get filterPayloadQuestions => _filterPayloadQuestions;
  String get filterPayloadAnsweredQuestions => _filterPayloadAnsweredQuestions;

  String get nextUsers => _nextUsers;
  String get nextQuestions => _nextQuestions;
  String get nextAnswers => _nextAnsweredQuestions;
  String get nextMyQuestions => _nextMyQuestions;
  String get nextBookmarks => _nextBookmarks;

  bool get isNextUsers => _nextUsers != '' ? true : false;
  bool get isNextQuestions => _nextQuestions != '' ? true : false;
  bool get isNextAnsweredQuestions =>
      _nextAnsweredQuestions != '' ? true : false;
  bool get isNextMyQuestions => _nextMyQuestions != '' ? true : false;
  bool get isNextBookmarks => _nextBookmarks != '' ? true : false;

  bool get isLoadingUsers => _isLoadingUsers ? true : false;
  bool get isLoadingQuestions => _isLoadingQuestions ? true : false;
  bool get isLoadingAnsweredQuestions =>
      _isLoadingAnsweredQuestions ? true : false;
  bool get loadingMyQuestions => _loadingMyQuestions ? true : false;
  bool get loadingBookmarks => _loadingBookmarks ? true : false;

  Map<String, dynamic> findUserById(int id) {
    return _users.firstWhere((q) => q['id'] == id);
  }

  Map<String, dynamic> findCenterRepById(int id) {
    return _centerReps.firstWhere((q) => q['id'] == id);
  }

  Map<String, dynamic> findQuestionById(int id) {
    return _questions.firstWhere((q) => q['id'] == id);
  }

  Map<String, dynamic> findAnsweredQuestionById(int id) {
    return _answeredQuestions.firstWhere((a) => a['id'] == id);
  }

  Map<String, dynamic> findMyQuestionById(int id) {
    return _myQuestions.firstWhere((a) => a['id'] == id);
  }

  Map<String, dynamic> findBookmarkById(int id) {
    return _bookmarkQuestions.firstWhere((a) => a['id'] == id);
  }

  void _addNewElement(
      List<dynamic> listPointer, Map<String, dynamic> newElement) {
    // _listPointer.add(_newElement);
    listPointer.insert(0, newElement); // at the start of the list
    notifyListeners();
  }

  void _swapEditedElement(
      List<dynamic> listPointer, Map<String, dynamic> newElement) {
    final eIndex = listPointer.indexWhere((e) => e['id'] == newElement['id']);
    if (eIndex >= 0) {
      listPointer[eIndex] = newElement;
      notifyListeners();
    }
  }

  void _removeElement(List<dynamic> listPointer, String id) {
    final eIndex = listPointer.indexWhere((e) => e['id'] == int.parse(id));
    if (eIndex != -1) {
      listPointer.removeAt(eIndex);
      notifyListeners();
    }
  }

  void removeInMyQuestion(String id) {
    _removeElement(_myQuestions, id);
  }

  void removeInBookmarks(String id) {
    _removeElement(_bookmarkQuestions, id);
  }

  Future<void> deleteUser(String id) async {
    String endpoint = '${endpoints.user}$id/';

    try {
      final http.Response res =
          await http.delete(Uri.parse(endpoint), headers: _headers);
      // final decodedData = jsonDecode(res.body); // NOT DO IT, because if res.statusCode == 204, "res.body is empty" AND raise error

      if (res.statusCode == 204) {
        _removeElement(_users, id);
      } else if (jsonDecode(res.body)['detail'] != null) {
        throw HttpException(jsonDecode(res.body)['detail']);
      } else {
        throw '${jsonDecode(res.body)}';
      }
    } catch (e) {
      // print('e: $e');
      rethrow;
    }
  }

  Future<void> deleteQuestion(String id) async {
    String endpoint = '${endpoints.question}$id/';

    try {
      final http.Response res =
          await http.delete(Uri.parse(endpoint), headers: _headers);
      // final decodedData = jsonDecode(res.body); // NOT DO IT, because if res.statusCode == 204, "res.body is empty" AND raise error

      if (res.statusCode == 204) {
        _removeElement(_questions, id);
      } else if (jsonDecode(res.body)['detail'] != null) {
        throw HttpException(jsonDecode(res.body)['detail']);
      } else {
        throw '${jsonDecode(res.body)}';
      }
    } catch (e) {
      // print('e: $e');
      rethrow;
    }
  }

  Future<void> onRefreshUsers() async {
    // print("I am Run onRefreshUsers()");
    _users = [];
    _nextUsers = '';
    _filterPayloadUsers = '';
    userSearchData = null;
    fetchAndSetUsers('');
  }

  Future<void> onRefreshQuestions() async {
    // print("I am Run onRefreshUsers()");
    _questions = [];
    _nextQuestions = '';
    _filterPayloadQuestions = '';
    questionSearchData = null;
    fetchAndSetQuestions('');
  }

  Future<void> onRefreshAnsweredQuestions() async {
    // print("I am Run onRefreshAnswers()");
    _answeredQuestions = [];
    _nextAnsweredQuestions = '';
    fetchAndSetAnsweredQuestions('');
  }

  Future<void> onRefreshMyQuestions() async {
    // print("I am Run onRefreshMyQuestions()");
    _myQuestions = [];
    _nextMyQuestions = '';
    fetchAndSetMyQuestions('');
  }

  Future<void> filterUsers(String payload) async {
    _nextUsers = '';
    _users = [];
    _filterPayloadUsers = payload;
    fetchAndSetUsers('');
  }

  Future<void> filterQuestions(String payload) async {
    _nextQuestions = '';
    _questions = [];
    _filterPayloadQuestions = payload;
    fetchAndSetQuestions('');
  }

  Future<void> filterAnsweredQuestions(String payload) async {
    _nextAnsweredQuestions = '';
    _answeredQuestions = [];
    _filterPayloadAnsweredQuestions = payload;
    fetchAndSetAnsweredQuestions('');
  }

  Future<void> register(
      Map<String, dynamic> userData, bool isChangePassword) async {
    // print("userData ${userData}");
    // https://medium.com/nerd-for-tech/multipartrequest-in-http-for-sending-images-videos-via-post-request-in-flutter-e689a46471ab
    // https://dev.to/carminezacc/advanced-flutter-networking-part-1-uploading-a-file-to-a-rest-api-from-flutter-using-a-multi-part-form-data-post-request-2ekm
    // https://www.codegrepper.com/code-examples/whatever/Upload+multiple+images+in+flutter+by+multipart

    try {
      String endpoint = endpoints.user;
      String method = 'POST';

      if (userData['id'] != null) {
        endpoint += '${userData['id']}/';
        method = 'PATCH';
      }

      //for multipart request
      var request = http.MultipartRequest(method, Uri.parse(endpoint));

      //for token
      request.headers.addAll({
        if (authToken.isNotEmpty) "Authorization": "Bearer $authToken",
        "Content-type": "multipart/form-data",
      });

      // The form fields to send for this request.

      if (userData['id'] == null || isChangePassword) {
        request.fields['password'] = userData['password'];
      }
      if (!isChangePassword) {
        request.fields['username'] = userData['username'];
        request.fields['first_name'] = userData['first_name'];
        request.fields['last_name'] = userData['last_name'];
        request.fields['city'] = userData['city'].toString();
        request.fields['email'] = userData['email'];
        request.fields['is_active'] = userData['is_active'].toString();
        if (userData.containsKey('trashed_at')) {
          request.fields['trashed_at'] = userData['trashed_at'].toString();
        }
        if (userId.isNotEmpty && (loggedInIsStaff || loggedInIsSuperuser)) {
          request.fields['is_superuser'] = userData['is_superuser'].toString();
          request.fields['is_staff'] = userData['is_staff'].toString();
        }
        if (userData['note'] != null) {
          request.fields['note'] = userData['note'];
        }

        for (String item in userData['phone']) {
          request.files.add(http.MultipartFile.fromString('phone', item));
        }

        for (int item in userData['roles']) {
          request.files
              .add(http.MultipartFile.fromString('roles', item.toString()));
        }

        for (int item in userData['privileges']) {
          request.files.add(
              http.MultipartFile.fromString('privileges', item.toString()));
        }

        for (int item in userData['dialects']) {
          request.files
              .add(http.MultipartFile.fromString('dialects', item.toString()));
        }
      }

      //for completing the request
      var streamedResponse = await request.send();
      // print("streamedResponse ${streamedResponse.statusCode}");

      //for getting and decoding the response into json format
      var res = await http.Response.fromStream(streamedResponse);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      // print('decodedData$decodedData');

      if (res.statusCode == 201) {
        _addNewElement(_users, decodedData);
      } else if (res.statusCode == 200) {
        _swapEditedElement(_users, decodedData);
      } else if (decodedData['detail'] != null) {
        throw HttpException(decodedData['detail'].toString());

        /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException", BUT catch (error) in the place that call "Register() function" can't distinguish between general errors and HttpException errors
        // throw 'Registration failed';
      } else if (decodedData.toString().contains('username already exists')) {
        throw HttpException(decodedData.toString());
      } else {
        throw '$decodedData';
      }
    } catch (e) {
      print('e: $e');
      rethrow;
    }
  }

  Future<bool> editResearcherProfile(Map<String, dynamic> profileData) async {
    try {
      String endpoint = endpoints.answererProfile;
      String method = 'POST';

      if (profileData['id'] != null) {
        endpoint += '${profileData['id']}/';
        method = 'PATCH';
      }

      //for multipart request
      var request = http.MultipartRequest(method, Uri.parse(endpoint));

      //for token
      request.headers.addAll({
        "Authorization": "Bearer $authToken",
        "Content-type": "multipart/form-data",
      });

      // The form fields to send for this request.

      if (profileData['about'] != null) {
        request.fields['about'] = profileData['about'];
      }
      if (profileData['ckb_about'] != null) {
        request.fields['ckb_about'] = profileData['ckb_about'];
      }
      if (profileData['kmr_about'] != null) {
        request.fields['kmr_about'] = profileData['kmr_about'];
      }
      if (profileData['bad_about'] != null) {
        request.fields['bad_about'] = profileData['bad_about'];
      }
      if (profileData['ar_about'] != null) {
        request.fields['ar_about'] = profileData['ar_about'];
      }

      if (profileData['facebook'] != null) {
        request.fields['facebook'] = profileData['facebook'];
      }
      if (profileData['youtube'] != null) {
        request.fields['youtube'] = profileData['youtube'];
      }
      if (profileData['instagram'] != null) {
        request.fields['instagram'] = profileData['instagram'];
      }
      if (profileData['loc_lat'] != null && profileData['loc_long'] != null) {
        request.fields['loc_lat'] = profileData['loc_lat'].toString();
        request.fields['loc_long'] = profileData['loc_long'].toString();
      }
      request.fields['is_show_loc'] = profileData['is_show_loc'].toString();
      request.fields['question_threshold'] =
          profileData['question_threshold'].toString();
      request.fields['is_show_phone'] = profileData['is_show_phone'].toString();

      //for image and videos and files
      if (kIsWeb) {
        if (profileData['cover_image'] != null &&
            profileData['cover_image'] is! String) {
          request.files.add(http.MultipartFile.fromBytes(
            "cover_image",
            profileData['cover_image']['image-object'],
            // contentType: MediaType('application', 'json'),
            filename: "${profileData['cover_image']['name']}.png",
          ));
        }

        if (profileData['avatar'] != null && profileData['avatar'] is! String) {
          request.files.add(http.MultipartFile.fromBytes(
            "avatar",
            profileData['avatar']['image-object'],
            // contentType: MediaType('application', 'json'),
            filename: "${profileData['avatar']['name']}.png",
          ));
        }
      } else {
        if (profileData['cover_image'] != null &&
            p.isAbsolute(profileData['cover_image']!)) {
          request.files.add(await http.MultipartFile.fromPath(
              "cover_image", "${profileData['cover_image']}"));
        }
        if (profileData['avatar'] != null &&
            p.isAbsolute(profileData['avatar']!)) {
          /// check if a path is local path in OS filesystem JUST in syntax not really
          // final bool isAbsolutePath = !_imagePath!.contains('http://');
          // final bool isAbsolutePath = File(_imagePath!).isAbsolute; // import 'dart:io';
          // final bool isAbsolutePath = p.isAbsolute(_imagePath!);
          request.files.add(await http.MultipartFile.fromPath(
              "avatar", "${profileData['avatar']}"));
        }
      }

      //for completing the request
      var streamedResponse = await request.send();
      // print(streamedResponse.statusCode);

      //for getting and decoding the response into json format
      var res = await http.Response.fromStream(streamedResponse);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      // print('decodedData$decodedData');

      if (res.statusCode == 200) {
        return true;
        // _swapEditedElement(_users, decodedData);
      } else if (decodedData['detail'] != null) {
        throw HttpException(decodedData['detail']);

        /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException", BUT catch (error) in the place that call "Register() function" can't distinguish between general errors and HttpException errors
        // throw 'Registration failed';
      } else if (decodedData.toString().contains('username already exists')) {
        throw HttpException(decodedData.toString());
      } else {
        throw '$decodedData';
      }
    } catch (e) {
      print('e: $e');
      rethrow;
    }
  }

  Future<void> newQuestion(
      Map<String, dynamic> formData, bool isEditAnsweredQuestion) async {
    String body = jsonEncode(formData);
    String endpoint = endpoints.question;

    final Map<String, String> headers = {
      if (formData['id'] != null) "Authorization": "Bearer $authToken",
      "content-type": "application/json",
      "accept": "application/json",
    };

    late final http.Response res;

    try {
      if (formData['id'] != null) {
        endpoint += '${formData['id']}/';
        res = await http.patch(
          Uri.parse(endpoint),
          headers: headers,
          body: body,
        );
      } else {
        res = await http.post(
          Uri.parse(endpoint),
          headers: headers,
          body: body,
        );
      }

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      if (res.statusCode == 201) {
        await LocalStorageService.setNewQuestion(decodedData['id']);
      } else if (res.statusCode == 200) {
        if (isEditAnsweredQuestion) {
          // Map<String, dynamic> oldAnswerInfo =findAnsweredQuestionById(formData['id'])['answer'];
          // decodedData['answer'] = oldAnswerInfo;
          _swapEditedElement(_answeredQuestions, decodedData);
        } else {
          _swapEditedElement(_questions, decodedData);
        }
      } else if (decodedData['detail'] != null) {
        throw HttpException(decodedData['detail']);

        /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException", BUT catch (error) in the place that call "Register() function" can't distinguish between general errors and HttpException errors
        // throw 'Registration failed';
      } else if (decodedData['selected_answerer'] != null) {
        throw HttpException(decodedData['selected_answerer'][0].toString());
      } else if (decodedData['content'] != null) {
        throw HttpException(decodedData['content'][0].toString());
      }
      // else if (decodedData.toString().contains('username already exists')) {
      //   throw HttpException(decodedData.toString());
      // }
      else {
        throw '$decodedData';
      }
    } catch (e) {
      // print('e: $e');
      rethrow;
    }
  }

  Future<void> newAnswer(Map<String, dynamic> formData) async {
    // https://medium.com/nerd-for-tech/multipartrequest-in-http-for-sending-images-videos-via-post-request-in-flutter-e689a46471ab
    // https://dev.to/carminezacc/advanced-flutter-networking-part-1-uploading-a-file-to-a-rest-api-from-flutter-using-a-multi-part-form-data-post-request-2ekm
    // https://www.codegrepper.com/code-examples/whatever/Upload+multiple+images+in+flutter+by+multipart

    try {
      String endpoint = endpoints.answer;
      String method = 'POST';

      if (formData['id'] != null) {
        endpoint += '${formData['id']}/';
        method = 'PATCH';
      }

      //for multipart request
      var request = http.MultipartRequest(method, Uri.parse(endpoint));

      //for token
      request.headers.addAll({
        "Authorization": "Bearer $authToken",
        "Content-type": "multipart/form-data",
      });

      /// The form fields to send for this request.
      /// to see more look at basics.dart ==> register() method

      request.fields['question'] = formData['question'].toString();

      /// for image and videos and files

      if (formData['audio'] != null && p.isAbsolute(formData['audio']!)) {
        /// check if a path is local path in OS filesystem JUST in syntax not really
        // final bool isAbsolutePath = !_imagePath!.contains('http://');
        // final bool isAbsolutePath = File(_imagePath!).isAbsolute; // import 'dart:io';
        // final bool isAbsolutePath = p.isAbsolute(_imagePath!);
        request.files.add(
            await http.MultipartFile.fromPath("audio", "${formData['audio']}"));
      }

      //for completing the request
      var streamedResponse = await request.send();
      // print(streamedResponse.statusCode);

      //for getting and decoding the response into json format
      var res = await http.Response.fromStream(streamedResponse);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);
      // print('decodedData$decodedData');

      if (res.statusCode == 201) {
        final String qid = formData['question'];
        final Map<String, dynamic> q = findQuestionById(int.parse(qid));
        q['answer'] = decodedData;
        _addNewElement(_answeredQuestions, q);
        _removeElement(_questions, qid);
      } else if (res.statusCode == 200) {
        final Map<String, dynamic> q =
            findAnsweredQuestionById(formData['question']);
        q['answer'] = decodedData;
        _swapEditedElement(_answeredQuestions, q);
      } else if (decodedData['detail'] != null) {
        throw HttpException(decodedData['detail']);

        /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException", BUT catch (error) in the place that call "Register() function" can't distinguish between general errors and HttpException errors
        // throw 'Registration failed';
      } else if (decodedData.toString().contains('username already exists')) {
        throw HttpException(decodedData.toString());
      } else {
        throw '$decodedData';
      }
    } catch (e) {
      // print('error1: $e');
      rethrow;
    }
  }

// the following to method is called in answer_widget.dart  _runFetchAndSetInitialBasics()
  Future<void> fetchAndSetBookmarkIDs() async {
    _bookmarkIDs = await LocalStorageService.getBookmarks() ?? [];
  }

  Future<void> fetchAndSetMyQuestionIDs() async {
    _myQuestionIDs = await LocalStorageService.getMyQuestions() ?? [];
  }

  bool getBookmarkStatus(int id) {
    return _bookmarkIDs.contains(id);
  }

  bool getMyQuestionStatus(int id) {
    return _myQuestionIDs.contains(id);
  }

  Future<void> toggleBookmarkStatus(int id, bool triggerNotifyListeners) async {
    try {
      if (!getBookmarkStatus(id)) {
        await LocalStorageService.setBookmark(id);
        _bookmarkIDs.add(id);

        if (_bookmarkQuestions.isNotEmpty) {
          final Map<String, dynamic> q = findAnsweredQuestionById(id);
          // _addNewElement(_bookmarkQuestions, q);
          _bookmarkQuestions.insert(0, q); // at the start of the list
        }
      } else {
        await LocalStorageService.removeInBookmarks(id.toString());
        _bookmarkIDs.remove(id);
        // _removeElement(_bookmarkQuestions, id.toString());
        final eIndex = _bookmarkQuestions
            .indexWhere((e) => e['id'] == int.parse(id.toString()));
        if (eIndex != -1) {
          _bookmarkQuestions.removeAt(eIndex);
        }
        if (triggerNotifyListeners) {
          notifyListeners();
        }
      }
    } catch (e) {
      // print("Error: $e");
      rethrow;
    }
  }

  Future<void> fetchAndSetUsers(String options) async {
    _isLoadingUsers = true;
    if (options != '') {
      _users = [];
    }

    var endpoint = '${endpoints.user}$_filterPayloadUsers$options';
    if (_nextUsers != '' && options == '') {
      endpoint = _nextUsers;
    }
    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _users = _users..addAll(decodedData['results']);

      if (decodedData['next'] != null) {
        _nextUsers = decodedData['next'];
      } else {
        _nextUsers = '';
      }
      _isLoadingUsers = false;
      // print('decodedData: $decodedData');

      notifyListeners();
    } catch (e) {
      _isLoadingUsers = false;
      rethrow;
    }
  }

  Future<void> fetchAndSetCenterReps() async {
    //  _isLoadingCenterReps = true;
    var endpoint = endpoints.centerReps;

    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);
      _centerReps = decodedData;

      // _isLoadingCenterReps = false;
      // print('decodedData: $decodedData');

      notifyListeners();
    } catch (e) {
      //  _isLoadingCenterReps = false;
      rethrow;
    }
  }

  Future<void> fetchAndSetStats() async {
    await Future.wait([
      fetchAndSetRoleStats(),
      fetchAndSetChartStats(),
      fetchAndSetRectangleStats(),
    ]);
  }

  Future<void> fetchAndSetRoleStats() async {
    var endpoint = endpoints.rolestats;

    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _roleStats = decodedData;

      // print('decodedData: $decodedData');

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetChartStats() async {
    var endpoint = endpoints.chartStats;

    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _chartStats = decodedData;

      // print('decodedData: $decodedData');

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetRectangleStats() async {
    var endpoint = endpoints.rectangleStats;

    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _rectangleStats = decodedData;

      // print('decodedData: $decodedData');

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void removeTrashedUserInCenterReps(int id) {
    _centerReps.removeWhere((item) => item["id"] == id);
    notifyListeners();
  }

  void addRestoredUserToCenterReps(int id) {
    _centerReps.add(findUserById(id));
    notifyListeners();
  }

  Future<void> fetchAndSetQuestions(String options) async {
    _isLoadingQuestions = true;
    if (options != '') {
      _questions = [];
    }

    var endpoint = '${endpoints.question}$_filterPayloadQuestions$options';
    if (_nextQuestions != '' && options == '') {
      endpoint = _nextQuestions;
    }
    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _questions = _questions..addAll(decodedData['results']);
      if (decodedData['next'] != null) {
        _nextQuestions = decodedData['next'];
      } else {
        _nextQuestions = '';
      }
      _isLoadingQuestions = false;
      // print('Next: $_nextQuestions');

      notifyListeners();
    } catch (e) {
      _isLoadingQuestions = false;
      rethrow;
    }
  }

  Future<void> fetchAndSetAnsweredQuestions(String options) async {
    _isLoadingAnsweredQuestions = true;
    if (options != '') {
      _answeredQuestions = [];
    }

    var endpoint =
        '${endpoints.answers}$_filterPayloadAnsweredQuestions$options';
    if (_nextAnsweredQuestions != '' && options == '') {
      endpoint = _nextAnsweredQuestions;
    }
    try {
      var res = await http.get(Uri.parse(endpoint), headers: _headers);

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _answeredQuestions = _answeredQuestions..addAll(decodedData['results']);
      if (decodedData['next'] != null) {
        _nextAnsweredQuestions = decodedData['next'];
      } else {
        _nextAnsweredQuestions = '';
      }
      _isLoadingAnsweredQuestions = false;

      notifyListeners();
    } catch (e) {
      _isLoadingAnsweredQuestions = false;
      rethrow;
    }
  }

  Future<void> fetchAndSetMyQuestions(String options) async {
    if (_myQuestionIDs.isEmpty) return;

    _loadingMyQuestions = true;

    var endpoint = '${endpoints.answers}id__in=$_myQuestionIDs';
    if (_nextMyQuestions != '') {
      endpoint = _nextMyQuestions;
    }
    try {
      var res = await http.get(Uri.parse(endpoint));

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _myQuestions = _myQuestions..addAll(decodedData['results']);
      countMyQuestions = decodedData['count'];
      if (decodedData['next'] != null) {
        _nextMyQuestions = decodedData['next'];
      } else {
        _nextMyQuestions = '';
      }
      _loadingMyQuestions = false;
      notifyListeners();
    } catch (e) {
      _loadingMyQuestions = false;
      rethrow;
    }
  }

  Future<void> fetchAndSetBookmarkQuestions(String options) async {
    if (_bookmarkIDs.isEmpty) return;

    _loadingBookmarks = true;

    var endpoint = '${endpoints.answers}id__in=$_bookmarkIDs';
    if (_nextBookmarks != '') {
      endpoint = _nextBookmarks;
    }
    try {
      var res = await http.get(Uri.parse(endpoint));

      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      final decodedData = jsonDecode(utf8DecodedData);

      _bookmarkQuestions = _bookmarkQuestions..addAll(decodedData['results']);
      if (decodedData['next'] != null) {
        _nextBookmarks = decodedData['next'];
      } else {
        _nextBookmarks = '';
      }
      _loadingBookmarks = false;
      notifyListeners();
    } catch (e) {
      _loadingBookmarks = false;
      rethrow;
    }
  }
}
