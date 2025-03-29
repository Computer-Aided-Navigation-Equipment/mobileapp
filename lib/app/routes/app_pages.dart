import 'package:get/get.dart';

import '../modules/about-us/bindings/about_us_binding.dart';
import '../modules/about-us/views/about_us_view.dart';
import '../modules/activity-log/bindings/activity_log_binding.dart';
import '../modules/activity-log/views/activity_log_view.dart';
import '../modules/begin-path/bindings/begin_path_binding.dart';
import '../modules/begin-path/views/begin_path_view.dart';
import '../modules/contacts/bindings/contacts_binding.dart';
import '../modules/contacts/views/contacts_view.dart';
import '../modules/emergency-alerts/bindings/emergency_alerts_binding.dart';
import '../modules/emergency-alerts/views/emergency_alerts_view.dart';
import '../modules/feedback-submissions/bindings/feedback_submissions_binding.dart';
import '../modules/feedback-submissions/views/feedback_submissions_view.dart';
import '../modules/feedback/bindings/feedback_binding.dart';
import '../modules/feedback/views/feedback_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/locations/bindings/locations_binding.dart';
import '../modules/locations/views/locations_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/manage-users/bindings/manage_users_binding.dart';
import '../modules/manage-users/views/manage_users_view.dart';
import '../modules/navigation/bindings/navigation_binding.dart';
import '../modules/navigation/views/navigation_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/user-home/bindings/user_home_binding.dart';
import '../modules/user-home/views/user_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.ABOUT_US,
      page: () => const AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.USER_HOME,
      page: () => const UserHomeView(),
      binding: UserHomeBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK,
      page: () => const FeedbackView(),
      binding: FeedbackBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LOCATIONS,
      page: () => const LocationsView(),
      binding: LocationsBinding(),
    ),
    GetPage(
      name: _Paths.CONTACTS,
      page: () => const ContactsView(),
      binding: ContactsBinding(),
    ),
    GetPage(
      name: _Paths.BEGIN_PATH,
      page: () => const BeginPathView(),
      binding: BeginPathBinding(),
    ),
    GetPage(
      name: _Paths.MANAGE_USERS,
      page: () => const ManageUsersView(),
      binding: ManageUsersBinding(),
    ),
    GetPage(
      name: _Paths.ACTIVITY_LOG,
      page: () => const ActivityLogView(),
      binding: ActivityLogBinding(),
    ),
    GetPage(
      name: _Paths.EMERGENCY_ALERTS,
      page: () => const EmergencyAlertsView(),
      binding: EmergencyAlertsBinding(),
    ),
    GetPage(
      name: _Paths.FEEDBACK_SUBMISSIONS,
      page: () => const FeedbackSubmissionsView(),
      binding: FeedbackSubmissionsBinding(),
    ),
  ];
}
