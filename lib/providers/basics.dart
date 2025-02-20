import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../utils/services/local_storage_service.dart';
import 'package:uuid/uuid.dart';
import '/constants/api_path.dart' as endpoints;
import 'package:http/http.dart' as http;

class Basics with ChangeNotifier {
  static String authToken = '';
  String _userId = '';

  List<dynamic> certifications = [];
  Map<String, dynamic> _salary = {};
  List<dynamic> scientificTitles = [];
  List<dynamic> thanksLetters = [];
  List<dynamic> attendance = [];
  List<dynamic> attendanceStatuses = [];
  List<dynamic> leaves = [];
  Map<String, dynamic> leaveStatistic = {};
  List<dynamic> operates = [];
  List<dynamic> deputations = [];
  List<dynamic> punishments = [];
  List<dynamic> committees = [];
  List<dynamic> rewards = [];
  List<dynamic> researches = [];
  List<dynamic> _searchedDocTrackingData = [];

  static List<dynamic> _branches = [];

  List<dynamic> get branches => [..._branches];

  Map<String, dynamic> salarySearchData = {
    "month": DateTime.now().month,
    "year": DateTime.now().year,
  };

  Map<String, String> docSearchData = {
    "refNo": "",
    "refDate": "",
    "branchId": "",
  };

  Map<String, dynamic> get salary => {..._salary};
  List<dynamic> get searchedDocTrackingData =>
      [..._searchedDocTrackingData.reversed];

  void update(String t, String u) async {
    authToken = t;
    if (_userId != u) {
      _userId = u;
      initialBasicsFetchAndSet().then((_) => notifyListeners());
    }
    _userId = u;
  }

  String? get userId {
    if (_userId != '') {
      return _userId;
    }
    return null;
  }

  // Map<String, String>? get _headers {
  //   return authToken.isNotEmpty ? {'Authorization': 'Bearer $authToken'} : null;
  // }

  Future<void> fetchAndSetCertifications() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoints.certifications),
      );

      request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      certifications = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetSalary(String? month, String? year) async {
    String m = month ?? salarySearchData['month'].toString();
    String y = year ?? salarySearchData['year'].toString();
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.salary}$userId/$m/$y'),
      );

      // request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _salary = jsonDecode(utf8DecodedData);
      notifyListeners();
    } catch (e) {
      salarySearchData = {
        "month": DateTime.now().month,
        "year": DateTime.now().year,
      };
      rethrow;
    }
  }

  Future<void> fetchAndSetScientificTitle() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.scientificTitles}$userId/'),
      );

      // request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      scientificTitles = jsonDecode(utf8DecodedData);
      scientificTitles.removeWhere((element) => element['docDate'] == null);

      // Sort the list by docDate, ignoring the time part
      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      scientificTitles.sort((a, b) {
        // Handle null values for startDate
        if (a['docDate'] == null && b['docDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['docDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['docDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['docDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['docDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetThanksLetter() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.thanksTitles}$userId/'),
      );

      // request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      thanksLetters = jsonDecode(utf8DecodedData);
      thanksLetters.removeWhere((element) => element['docDate'] == null);

      // Sort the list by docDate, ignoring the time part
      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      thanksLetters.sort((a, b) {
        // Handle null values for startDate
        if (a['docDate'] == null && b['docDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['docDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['docDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['docDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['docDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetAttendance(
      DateTime startDate, DateTime endDate, String attendanceTypeId) async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoints.attendance),
      );
      request.fields['statusId'] = attendanceTypeId;
      request.fields['fromDate'] = startDate.toString();
      request.fields['toDate'] = endDate.toString();
      request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      attendance = jsonDecode(utf8DecodedData);
      // print(attendance[5]);

      // thanksLetters.removeWhere((element) => element['docDate'] == null);

      // Sort the list by docDate, ignoring the time part
      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      attendance.sort((a, b) {
        // Handle null values for startDate
        if (a['date'] == null && b['date'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['date'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['date'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['date'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['date'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetAttendanceStatuses() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse(endpoints.attendanceStatuses),
      );

      // request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      attendanceStatuses = jsonDecode(utf8DecodedData)['attendanceStatuses'];
      attendanceStatuses.add({
        "id": "00000000-0000-0000-0000-000000000000",
        "name": "گشت",
        "sort": "4"
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetLeave(
      DateTime startDate, DateTime endDate, String leaveTypeId) async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoints.leave),
      );

      request.fields['pageNumber'] = "1";
      request.fields['pageSize'] = "1000";
      request.fields['leaveTypeId'] = leaveTypeId;
      request.fields['fromDate'] = startDate.toString();
      request.fields['toDate'] = endDate.toString();
      request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters

      leaves = jsonDecode(utf8DecodedData)['employeeLeaves'];
      // thanksLetters.removeWhere((element) => element['docDate'] == null);

      // Sort the list by docDate, ignoring the time part
      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      leaves.sort((a, b) {
        // Handle null values for startDate
        if (a['startDate'] == null && b['startDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['startDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['startDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['startDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['startDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetLeaveStatistic() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(endpoints.leaveStatistic),
      );

      request.fields['employeeId'] = userId!;

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters

      leaveStatistic = jsonDecode(utf8DecodedData)[0];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetOperate() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.operate}$userId/'),
      );

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      operates = jsonDecode(utf8DecodedData);
      // print("HHH: $operates");

      // thanksLetters.removeWhere((element) => element['docDate'] == null);

      // Sort the list by docDate, ignoring the time part
      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      operates.sort((a, b) {
        // Handle null values for startDate
        if (a['date'] == null && b['date'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['date'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['date'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['date'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['date'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetDeputation() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.deputation}$userId/'),
      );

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      deputations = jsonDecode(utf8DecodedData);
      // print(attendance[5]);

      // thanksLetters.removeWhere((element) => element['docDate'] == null);

      // Sort the list by docDate, ignoring the time part
      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      deputations.sort((a, b) {
        // Handle null values for startDate
        if (a['startDate'] == null && b['startDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['startDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['startDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['startDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['startDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetPunishments() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.punishment}$userId/'),
      );

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      punishments = jsonDecode(utf8DecodedData);

      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      punishments.sort((a, b) {
        // Handle null values for startDate
        if (a['startDate'] == null && b['startDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['startDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['startDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['startDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['startDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetCommittees() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.committee}$userId/'),
      );

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      committees = jsonDecode(utf8DecodedData);

      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      committees.sort((a, b) {
        // Handle null values for startDate
        if (a['startDate'] == null && b['startDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['startDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['startDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['startDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['startDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetRewards() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.reward}$userId/'),
      );

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      rewards = jsonDecode(utf8DecodedData);

      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      rewards.sort((a, b) {
        // Handle null values for startDate
        if (a['docDate'] == null && b['docDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['docDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['docDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['docDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['docDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetResearchs() async {
    try {
      http.MultipartRequest request = http.MultipartRequest(
        'GET',
        Uri.parse('${endpoints.research}$userId/'),
      );

      // Sending the request and waiting for the response
      final streamedResponse = await request.send();

      // Convert the streamed response into a normal Response object
      final http.Response res =
          await http.Response.fromStream(streamedResponse);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      researches = jsonDecode(utf8DecodedData);

      // Define a date format
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");

      // Sort the list by docDate, ignoring the time part
      researches.sort((a, b) {
        // Handle null values for startDate
        if (a['docDate'] == null && b['docDate'] == null) {
          return 0; // Both are null, so they are equal
        } else if (a['docDate'] == null) {
          return 1; // a is null, so b comes first
        } else if (b['docDate'] == null) {
          return -1; // b is null, so a comes first
        } else {
          // Both are non-null, compare dates
          DateTime dateA = dateFormat.parse(a['docDate'].split(' ')[0]);
          DateTime dateB = dateFormat.parse(b['docDate'].split(' ')[0]);
          return dateB
              .compareTo(dateA); // Sort in descending order (newest first)
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> searchDoc(Map<String, dynamic> dsd) async {
    try {
      // Set up the request
      final Uri url = Uri.parse(endpoints.docTrack);
      final request = http.MultipartRequest('POST', url);

      // Prepare request fields
      docSearchData = {
        'id': dsd.containsKey('id') ? dsd['id'].toString() : '',
        'refNo': dsd['refNo'].toString(),
        'refDate': dsd['refDate'].toString(),
        'branchId': dsd['branchId'].toString(),
      };
      final fieldsToSend = Map<String, String>.from(docSearchData);
      fieldsToSend.remove('id');
      request.fields.addAll(fieldsToSend);

      // Send the request and wait for the response
      final streamedResponse = await request.send();

      // Convert streamed response to a standard Response
      final http.Response response =
          await http.Response.fromStream(streamedResponse);

      // Decode response body as UTF-8 to handle special characters
      final String utf8DecodedData = utf8.decode(response.bodyBytes);
      final Map<String, dynamic> decodedData = jsonDecode(utf8DecodedData);

      // Handle response status and data
      if (decodedData['state'] == -1) {
        throw decodedData['msg'] ?? 'An unknown error occurred.';
      }

      // Assign decoded data to _searchedDocTrackingData
      _searchedDocTrackingData = decodedData['data'] ?? [];
      notifyListeners();
    } on FormatException {
      // Handle JSON decoding issues
      throw Exception('Error decoding the server response.');
    } on http.ClientException {
      // Handle connection issues
      throw Exception('Failed to connect to the server.');
    } catch (e) {
      // General error handler
      throw e;
    }
  }

  Future<void> fetchAndSetBranches() async {
    try {
      // final http.Response res = await http.get(Uri.parse(endpoints.branch));
      final http.Response res = await http.get(Uri.parse(
          'https://test.erp.mohe.gov.krd/Mobile/Default/all-branches'));
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _branches = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isAnyAnswererAvailable(List<int> dialects) async {
    String endpoint = '${endpoints.isAnyAnswererAvailable}?dialects=$dialects';
    try {
      final http.Response res = await http.get(Uri.parse(endpoint));
      return jsonDecode(res.body);
    } catch (e) {
      // print("Error: $e");
      rethrow;
    }
  }

  Future<List<dynamic>> fetchAvailableUsers(List<int> dialects) async {
    String endpoint = '${endpoints.availableAnswerers}?dialects=$dialects';
    try {
      final http.Response res = await http.get(Uri.parse(endpoint));
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      return jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> initialBasicsFetchAndSet() async {
    /// Multiple concurrent http Requests
    // https://medium.com/app-dev-community/how-to-use-await-with-multiple-requests-concurrency-in-flutter-and-dart-part-1-50dbde503f6b
    // https://stackoverflow.com/questions/50027632/optimal-way-to-make-multiple-independent-requests-to-server-in-dart
    // https://pub.dev/packages/http

    await Future.wait([
      fetchAndSetBranches(),
      // fetchAndSetRoles(),
      // fetchAndSetPrivileges(),
      // fetchAndSetDialects(),
      // fetchAndSetCityTypes(),
      // fetchAndSetCities(),
      // fetchAndSetCategories(),
      // fetchAndSetTopics(),
      // fetchAndSetSubjects()
    ]);
  }

  List<Map<String, dynamic>> _docHistoryMaps = [];
  List<Map<String, dynamic>> get docHistoryMaps => [..._docHistoryMaps];

  Future<void> fetchAndSetDocHistoryMaps() async {
    _docHistoryMaps = await LocalStorageService.getDocHistory() ?? [];
  }

  bool getDocHistoryStatus(Map<String, String> data) {
    return _docHistoryMaps.any((element) =>
        element['refNo'] == data['refNo'] &&
        element['refDate'] == data['refDate'] &&
        element['branchId'] == data['branchId']);
  }

  Future<void> toggleDocHistoryStatus(
      Map<String, String> data, bool triggerNotifyListeners) async {
    try {
      if (!getDocHistoryStatus(data)) {
        data['id'] = const Uuid().v4(); // Add id to the map with uuid
        await LocalStorageService.setDocHistory(data);
        _docHistoryMaps.add(data);
      } else {
        await LocalStorageService.removeInDocHistory(data);
        _docHistoryMaps.removeWhere((element) => element['id'] == data['id']);
      }
      if (triggerNotifyListeners) {
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchDocHistorys() async {
    try {
      _docHistoryMaps = await LocalStorageService.getDocHistory() ?? [];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
