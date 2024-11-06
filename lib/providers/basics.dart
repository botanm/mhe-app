import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../utils/services/local_storage_service.dart';
import '/constants/api_path.dart' as endpoints;
import 'package:http/http.dart' as http;

import '../utils/services/http_exception.dart';

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

  static List<dynamic> _roles = [];
  static List<dynamic> _privileges = [];
  static List<dynamic> _dialects = [];
  static List<dynamic> _cityTypes = [];
  static List<dynamic> _cities = [];
  static List<dynamic> _categories = [];
  static List<dynamic> _topics = [];
  static List<dynamic> _subjects = [];

  Map<String, dynamic> getTypeInfo(String type) {
    Map<String, dynamic> info = {};
    switch (type) {
      case "role":
        {
          info = {
            "name": "role",
            "endpoint": endpoints.role,
            "container": _roles
          };
        }
        break;

      case "privilege":
        {
          info = {
            "name": "privilege",
            "endpoint": endpoints.privilege,
            "container": _privileges
          };
        }
        break;

      case "dialect":
        {
          info = {
            "name": "dialect",
            "endpoint": endpoints.dialect,
            "container": _dialects
          };
        }
        break;

      case "cityType":
        {
          info = {
            "name": "cityType",
            "endpoint": endpoints.cityType,
            "container": _cityTypes
          };
        }
        break;

      case "city":
        {
          info = {
            "name": "city",
            "endpoint": endpoints.city,
            "container": _cities
          };
        }
        break;

      case "category":
        {
          info = {
            "name": "category",
            "endpoint": endpoints.category,
            "container": _categories
          };
        }
        break;

      case "topic":
        {
          info = {
            "name": "topic",
            "endpoint": endpoints.topic,
            "container": _topics
          };
        }
        break;

      case "subject":
        {
          info = {
            "name": "subject",
            "endpoint": endpoints.subject,
            "container": _subjects
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

  Map<String, String>? get _headers {
    return authToken.isNotEmpty ? {'Authorization': 'Bearer $authToken'} : null;
  }

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
      // print(attendance[5]);

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
        'refNo': dsd['refNo'].toString(),
        'refDate': dsd['refDate'].toString(),
        'branchId': dsd['branchId'].toString(),
      };
      request.fields.addAll(docSearchData);

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
      final http.Response res = await http.get(Uri.parse(endpoints.branch));
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _branches = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  List<dynamic> get roles => [..._roles];
  List<dynamic> get privileges => [..._privileges];
  List<dynamic> get dialects => [..._dialects];
  List<dynamic> get cityTypes => [..._cityTypes];
  List<dynamic> get cities => [..._cities];
  List<dynamic> get categories => [..._categories];
  List<dynamic> get topics => [..._topics];
  List<dynamic> get subjects => [..._subjects];

  Map<String, dynamic> findBasicById(String bn, int id) {
    final Map<String, dynamic> epi = getTypeInfo(bn);
    List<dynamic> container = epi['container'];
    return container.firstWhere((e) => e['id'] == id, orElse: () => null) ?? {};
  }

  void _addNewElement(
      List<dynamic> listPointer, Map<String, dynamic> newElement) {
    listPointer.add(newElement);
    // _listPointer.insert(0, _newElement); // at the start of the list, BUT IF apply " getPrioritizedElements(_provider.users);" on the showing screen, it would be reordered there not in provider class
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
    listPointer.removeAt(eIndex);

    notifyListeners();
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

  Future<void> fetchAndSetRoles() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.role), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _roles = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetPrivileges() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.privilege), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _privileges = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetDialects() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.dialect), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _dialects = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetCityTypes() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.cityType), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _cityTypes = jsonDecode(utf8DecodedData);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetCities() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.city), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _cities = jsonDecode(utf8DecodedData);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetCategories() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.category), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _categories = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetTopics() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.topic), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _topics = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchAndSetSubjects() async {
    try {
      final http.Response res =
          await http.get(Uri.parse(endpoints.subject), headers: _headers);
      final String utf8DecodedData = utf8.decode(res.bodyBytes);
      // final decodedData = jsonDecode(res.body); // can't decode arabic or kurdish or Latin characters
      _subjects = jsonDecode(utf8DecodedData);
    } catch (e) {
      rethrow;
    }
  }

  // void removeTrashedUserInOrganizations(int id) {
  //   for (Map<String, dynamic> org in _cities) {
  //     org["reps"].remove(id);
  //   }
  //   notifyListeners();
  // }

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

  Future<void> newBasic(String bn, Map<String, dynamic> formData) async {
    String body = jsonEncode(formData);
    final Map<String, dynamic> epi = getTypeInfo(bn);
    String endpoint = epi['endpoint'];
    List<dynamic> container = epi['container'];

    final Map<String, String> headers = {
      "Authorization": "Bearer $authToken",
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

      // print('decodedData$decodedData');
      if (res.statusCode == 201) {
        _addNewElement(container, decodedData);
      } else if (res.statusCode == 200) {
        _swapEditedElement(container, decodedData);
      } else if (decodedData['detail'] != null) {
        throw HttpException(decodedData['detail']);

        /// you can throw 'Text'; base on a list of conditions WITHOUT using "HttpException", BUT catch (error) in the place that call "Register() function" can't distinguish between general errors and HttpException errors
        // throw 'Registration failed';
      }
      // else if (decodedData.toString().contains('username already exists')) {
      //   throw HttpException(decodedData.toString());
      // }
      else {
        throw '$decodedData';
      }
    } catch (e) {
      print('ee: $e');
      rethrow;
    }
  }

  Future<void> deleteBasic(String bn, String id) async {
    final Map<String, dynamic> epi = getTypeInfo(bn);
    String endpoint = epi['endpoint'] + '$id/';
    List<dynamic> container = epi['container'];

    final Map<String, String> headers = {
      "Authorization": "Bearer $authToken",
      "content-type": "application/json",
      "accept": "application/json",
    };

    try {
      final http.Response res =
          await http.delete(Uri.parse(endpoint), headers: headers);
      // final decodedData = jsonDecode(res.body); // NOT DO IT, because if res.statusCode == 204, "res.body is empty" AND raise error

      if (res.statusCode == 204) {
        _removeElement(container, id);
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

  List<Map<String, dynamic>> _docHistoryMaps = [];
  List<Map<String, dynamic>> get docHistoryMaps => [..._docHistoryMaps];

  Future<void> fetchAndSetDocHistoryMaps() async {
    _docHistoryMaps = await LocalStorageService.getDocHistory() ?? [];
    print('data:fetch ${await LocalStorageService.getDocHistory()}');
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
        await LocalStorageService.setDocHistory(data);
        _docHistoryMaps.add(data);
      } else {
        await LocalStorageService.removeInDocHistory(data);
        _docHistoryMaps.removeWhere((element) =>
            element['refNo'] == data['refNo'] &&
            element['refDate'] == data['refDate'] &&
            element['branchId'] == data['branchId']);
      }
      if (triggerNotifyListeners) {
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
