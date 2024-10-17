import 'package:flutter/widgets.dart';

import '../screens/contact_information_screen.dart';
import '../screens/core/auth/forgot_password/forgot_password_screen.dart';
import '../screens/core/settings/account_preferences_screen.dart';
import '../screens/core/settings/settings_screen.dart';
import '../screens/dashboard/components/new_category_screen.dart';
import '../screens/dashboard/components/new_dialect_screen.dart';
import '../screens/dashboard/components/new_city_type_screen.dart';
import '../screens/dashboard/components/new_city_screen.dart';
import '../screens/dashboard/components/new_privilege_screen.dart';
import '../screens/dashboard/components/new_role_screen.dart';
import '../screens/dashboard/components/new_subject_screen.dart';
import '../screens/dashboard/components/new_topic_screen.dart';
import '../screens/equipment_detail_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/help_login_screen.dart';
import '../screens/help_screen.dart';

import '../screens/core/auth/login/login_screen.dart';
import '../screens/core/auth/register/register_screen.dart';

import '../screens/mohe-app/attendance_screen.dart';
import '../screens/mohe-app/certification_screen.dart';
import '../screens/mohe-app/committee_screen.dart';
import '../screens/mohe-app/deputation_screen.dart';
import '../screens/mohe-app/document_tracking_screen.dart';
import '../screens/mohe-app/leave_screen.dart';
import '../screens/mohe-app/me_screen.dart';
import '../screens/mohe-app/operate_screen.dart';
import '../screens/mohe-app/punishment_screen.dart';
import '../screens/mohe-app/research_screen.dart';
import '../screens/mohe-app/reward_screen.dart';
import '../screens/mohe-app/salary_screen.dart';
import '../screens/mohe-app/scientific_title_screen.dart';
import '../screens/mohe-app/thanks_letter_screen.dart';
import '../screens/myquestions_screen.dart';
import '../screens/new_equipment_screen.dart';
import '../screens/new_question_screen.dart';
import '../screens/user_detail_screen.dart';
import '../screens/answerer_profile_screen.dart';
import '../screens/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  MainScreen.routeName: (context) => const MainScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  UserDetailScreen.routeName: (context) => const UserDetailScreen(),
  CertificationsScreen.routeName: (context) => const CertificationsScreen(),
  MeScreen.routeName: (context) => const MeScreen(),
  SalaryScreen.routeName: (context) => const SalaryScreen(),
  ScientificTitleScreen.routeName: (context) => const ScientificTitleScreen(),
  ThanksLetterScreen.routeName: (context) => const ThanksLetterScreen(),
  AttendanceScreen.routeName: (context) => const AttendanceScreen(),
  LeaveScreen.routeName: (context) => const LeaveScreen(),
  OperateScreen.routeName: (context) => const OperateScreen(),
  DeputationScreen.routeName: (context) => const DeputationScreen(),
  PunishmentScreen.routeName: (context) => const PunishmentScreen(),
  CommitteeScreen.routeName: (context) => const CommitteeScreen(),
  RewardScreen.routeName: (context) => const RewardScreen(),
  ResearchScreen.routeName: (context) => const ResearchScreen(),
  DocumentTrackingScreen.routeName: (context) => const DocumentTrackingScreen(),
  EquipmentDetailScreen.routeName: (context) => const EquipmentDetailScreen(),
  AnswererProfileScreen.routeName: (context) => const AnswererProfileScreen(),
  HelpScreen.routeName: (context) => const HelpScreen(),
  ContactInformationScreen.routeName: (context) =>
      const ContactInformationScreen(),
  HelpLoginScreen.routeName: (context) => const HelpLoginScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  AccountPreferencesScreen.routeName: (context) =>
      const AccountPreferencesScreen(),
  MyQuestionsScreen.routeName: (context) => const MyQuestionsScreen(),
  NewQuestionScreen.routeName: (context) => const NewQuestionScreen(),
  NewRoleScreen.routeName: (context) => const NewRoleScreen(),
  NewPrivilegeScreen.routeName: (context) => const NewPrivilegeScreen(),
  NewDialectScreen.routeName: (context) => const NewDialectScreen(),
  NewCityTypeScreen.routeName: (context) => const NewCityTypeScreen(),
  NewCityScreen.routeName: (context) => const NewCityScreen(),
  NewCategoryScreen.routeName: (context) => const NewCategoryScreen(),
  NewSubjectScreen.routeName: (context) => const NewSubjectScreen(),
  NewTopicScreen.routeName: (context) => const NewTopicScreen(),
  NewEquipmentScreen.routeName: (context) => const NewEquipmentScreen(),
};
