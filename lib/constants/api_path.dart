// https://medium.com/nerd-for-tech/flutter-defining-constants-the-right-way-321d33185b41
// https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/constants.dart

const String serverAddress = 'https://erp.mohe.gov.krd';

// const String serverAddressWeb = 'http://127.0.0.1:8000';
// const String serverAddressMobile = 'http://10.0.2.2:8000';

// String serverAddress = kIsWeb ? serverAddressWeb : serverAddressMobile;

String buildApi(String api) {
  // if the environment is not production then add the environment name to the api
  if (const bool.fromEnvironment('dart.vm.product') == false) {
    return '$serverAddress$api';
  }

  return '$serverAddress$api';
}

String login = buildApi('/api/mobile/auth/login/');
String refresh = buildApi('/api/token/refresh/');
String getOTP = buildApi('/api/forgot-otp/');
String registerFirstStepORgetEmployeeId =
    buildApi('/api/mobile/auth/registerfirstStep');
String registerSecondStepSetPassword =
    buildApi('/api/mobile/auth/registersecondStep');
String verifyOTP = buildApi('/api/verify-otp/');
String resetPassword = buildApi('/api/reset-password/');
String photo = buildApi('/api/FileViewr/?fileName=hrms/EmployeePhoto/');
String certifications = buildApi('/api/Mobile/Certifications');
String salary = buildApi('/api/Mobile/Employee/GetEmployeeSalaries/');
String scientificTitles =
    buildApi('/api/Mobile/Employee/GetEmployeeScientificTitles/');
String thanksTitles = buildApi('/api/Mobile/Employee/GetEmployeeThankLetters/');
String attendance = buildApi('/api/Mobile/Attendances');
String attendanceStatuses =
    buildApi('/api/Mobile/Attendances/GetAttendanceSearch');
String leave = buildApi('/api/Mobile/Leaves');
String leaveStatistic = buildApi('/api/Mobile/Leaves/GetEmployeeLeaveBalances');
String operate = buildApi('/api/Mobile/Employee/GetEmployeeOperates/');
String deputation = buildApi('/api/Mobile/Employee/GetEmployeeDeputations/');
String punishment = buildApi('/api/Mobile/Employee/GetEmployeePunishments/');
String committee = buildApi('/api/Mobile/Employee/GetEmployeeCommittees/');
String reward = buildApi('/api/Mobile/Employee/GetEmployeeRewards/');
String research = buildApi('/api/Mobile/Employee/GetEmployeeResearches/');
String docTrack = buildApi('/api/Mobile/Tracks/');
String branch = buildApi('/api/mobile/default/all-branches');
String user = buildApi('/api/user/');
String centerReps = buildApi('/api/centerReps/');
String me = buildApi('/api/Mobile/Default/GetEmployeeInfo/');
String answererProfile = buildApi('/api/answerer-profile/');
String equipment = buildApi('/api/equipment/');
String role = buildApi('/api/role/');
String rolestats = buildApi('/api/role-stats/');
String chartStats = buildApi('/api/category-questions-stats/');
String rectangleStats = buildApi('/api/subject-questions-stats/');
String privilege = buildApi('/api/privilege/');
String dialect = buildApi('/api/dialect/');
String cityType = buildApi('/api/city-type/');
String city = buildApi('/api/city/');
String category = buildApi('/api/category/');
String topic = buildApi('/api/topic/');
String subject = buildApi('/api/subject/');
String isAnyAnswererAvailable =
    buildApi('/api/user/is-any-answerer-available/');
String availableAnswerers = buildApi('/api/user/available-answerers/');
String question = buildApi('/api/question/');
String answers = buildApi('/api/question/answered-questions/');
String answer = buildApi('/api/answer/');
