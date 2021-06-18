import 'package:auto_route/auto_route.dart';
import 'package:guardspot/app/guards/auth_guard.dart';
import 'package:guardspot/app/guards/has_organization_guard.dart';
import 'package:guardspot/app/guards/signed_in_guard.dart';
import 'package:guardspot/ui/onboarding/accept_invitation/accept_invitation_screen.dart';
import 'package:guardspot/ui/common/not_found_screen.dart';
import 'package:guardspot/ui/onboarding/confirm_email/confirm_email_screen.dart';
import 'package:guardspot/ui/onboarding/create_organization/create_organization_screen.dart';
import 'package:guardspot/ui/dashboard_screen.dart';
import 'package:guardspot/ui/link_sharing/link_sharing_screen.dart';
import 'package:guardspot/ui/location/location_screen.dart';
import 'package:guardspot/ui/schedule/schedule_screen.dart';
import 'package:guardspot/ui/auth/password_reset/change_password/change_password_screen.dart';
import 'package:guardspot/ui/auth/password_reset/forgot_password/forgot_password_screen.dart';
import 'package:guardspot/ui/organization/organization_screen.dart';
import 'package:guardspot/ui/project/view/project_details_screen.dart';
import 'package:guardspot/ui/project/view/reports/view/report_screen.dart';
import 'package:guardspot/ui/project/view/uploads/view/upload_screen.dart';
import 'package:guardspot/ui/project/project_list_screen.dart';
import 'package:guardspot/ui/settings/settings_screen.dart';
import 'package:guardspot/ui/auth/sign_in/sign_in_screen.dart';
import 'package:guardspot/ui/auth/sign_up/sign_up_confirmation_screen.dart';
import 'package:guardspot/ui/auth/sign_up/sign_up_screen.dart';
import 'package:guardspot/ui/user/user_screen.dart';

export 'router.gr.dart';

@MaterialAutoRouter(
  routes: [
    AutoRoute(
      path: "/",
      page: DashboardScreen,
      guards: [HasOrganizationGuard],
      children: [
        AutoRoute(path: "location", page: LocationScreen),
        AutoRoute(path: "projects", page: ProjectListScreen),
        AutoRoute(path: "schedule", page: ScheduleScreen),
        AutoRoute(path: "organization", page: OrganizationScreen),
        AutoRoute(path: "profile", page: UserScreen),
        AutoRoute(path: "settings", page: SettingsScreen)
      ],
    ),
    AutoRoute(
      path: "/projects/:id",
      page: ProjectDetailsScreen,
      guards: [HasOrganizationGuard],
    ),
    AutoRoute(
      path: "/projects/:projectId/uploads/:uploadId",
      page: UploadScreen,
      guards: [HasOrganizationGuard],
    ),
    AutoRoute(
      path: "/projects/:projectId/reports/:reportId",
      page: ReportScreen,
      guards: [HasOrganizationGuard],
    ),
    AutoRoute(
      path: "/sign_up",
      page: SignUpScreen,
      guards: [SignedInGuard],
    ),
    AutoRoute(
      path: "/sign_up_confirmation",
      page: SignUpConfirmationScreen,
    ),
    AutoRoute(
      path: "/sign_in",
      page: SignInScreen,
      guards: [SignedInGuard],
    ),
    AutoRoute(
      path: "/create_organization",
      page: CreateOrganizationScreen,
      guards: [AuthGuard],
    ),
    AutoRoute(path: "/forgot_password", page: ForgotPasswordScreen),
    AutoRoute(path: "/recover", page: ChangePasswordScreen),
    AutoRoute(path: "/confirm_email", page: ConfirmEmailScreen),
    AutoRoute(path: "/join/:secret", page: AcceptInvitationScreen),
    AutoRoute(path: "/public/:secret", page: LinkSharingScreen),
    AutoRoute(path: "*", page: NotFoundScreen),
  ],
)
class $Router {}
