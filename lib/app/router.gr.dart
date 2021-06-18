// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import '../ui/auth/password_reset/change_password/change_password_screen.dart'
    as _i15;
import '../ui/auth/password_reset/forgot_password/forgot_password_screen.dart'
    as _i14;
import '../ui/auth/sign_in/sign_in_screen.dart' as _i12;
import '../ui/auth/sign_up/sign_up_confirmation_screen.dart' as _i11;
import '../ui/auth/sign_up/sign_up_screen.dart' as _i10;
import '../ui/common/not_found_screen.dart' as _i19;
import '../ui/dashboard_screen.dart' as _i6;
import '../ui/link_sharing/link_sharing_screen.dart' as _i18;
import '../ui/location/location_screen.dart' as _i20;
import '../ui/onboarding/accept_invitation/accept_invitation_screen.dart'
    as _i17;
import '../ui/onboarding/confirm_email/confirm_email_screen.dart' as _i16;
import '../ui/onboarding/create_organization/create_organization_screen.dart'
    as _i13;
import '../ui/organization/organization_screen.dart' as _i23;
import '../ui/project/project_list_screen.dart' as _i21;
import '../ui/project/view/project_details_screen.dart' as _i7;
import '../ui/project/view/reports/view/report_screen.dart' as _i9;
import '../ui/project/view/uploads/view/upload_screen.dart' as _i8;
import '../ui/schedule/schedule_screen.dart' as _i22;
import '../ui/settings/settings_screen.dart' as _i25;
import '../ui/user/user_screen.dart' as _i24;
import 'guards/auth_guard.dart' as _i5;
import 'guards/has_organization_guard.dart' as _i3;
import 'guards/signed_in_guard.dart' as _i4;

class Router extends _i1.RootStackRouter {
  Router(
      {_i2.GlobalKey<_i2.NavigatorState>? navigatorKey,
      required this.hasOrganizationGuard,
      required this.signedInGuard,
      required this.authGuard})
      : super(navigatorKey);

  final _i3.HasOrganizationGuard hasOrganizationGuard;

  final _i4.SignedInGuard signedInGuard;

  final _i5.AuthGuard authGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    DashboardScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.DashboardScreen();
        }),
    ProjectDetailsScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<ProjectDetailsScreenRouteArgs>(
              orElse: () =>
                  ProjectDetailsScreenRouteArgs(id: pathParams.getInt('id')));
          return _i7.ProjectDetailsScreen(id: args.id);
        }),
    UploadScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<UploadScreenRouteArgs>(
              orElse: () => UploadScreenRouteArgs(
                  projectId: pathParams.getInt('projectId'),
                  uploadId: pathParams.getInt('uploadId')));
          return _i8.UploadScreen(
              projectId: args.projectId, uploadId: args.uploadId);
        }),
    ReportScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<ReportScreenRouteArgs>(
              orElse: () => ReportScreenRouteArgs(
                  projectId: pathParams.getInt('projectId'),
                  reportId: pathParams.getInt('reportId')));
          return _i9.ReportScreen(
              projectId: args.projectId, reportId: args.reportId);
        }),
    SignUpScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SignUpScreenRouteArgs>(
              orElse: () => const SignUpScreenRouteArgs());
          return _i10.SignUpScreen(urlInviteCode: args.urlInviteCode);
        }),
    SignUpConfirmationScreenRoute.name: (routeData) =>
        _i1.MaterialPageX<dynamic>(
            routeData: routeData,
            builder: (_) {
              return _i11.SignUpConfirmationScreen();
            }),
    SignInScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i12.SignInScreen();
        }),
    CreateOrganizationScreenRoute.name: (routeData) =>
        _i1.MaterialPageX<dynamic>(
            routeData: routeData,
            builder: (_) {
              return _i13.CreateOrganizationScreen();
            }),
    ForgotPasswordScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i14.ForgotPasswordScreen();
        }),
    ChangePasswordScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final queryParams = data.queryParams;
          final args = data.argsAs<ChangePasswordScreenRouteArgs>(
              orElse: () => ChangePasswordScreenRouteArgs(
                  code: queryParams.getString('reset_code', ""),
                  email: queryParams.optString('email')));
          return _i15.ChangePasswordScreen(code: args.code, email: args.email);
        }),
    ConfirmEmailScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final queryParams = data.queryParams;
          final args = data.argsAs<ConfirmEmailScreenRouteArgs>(
              orElse: () => ConfirmEmailScreenRouteArgs(
                  code: queryParams.getString('code', ""),
                  urlJoinCode: queryParams.optString('url_join_code')));
          return _i16.ConfirmEmailScreen(
              code: args.code, urlJoinCode: args.urlJoinCode);
        }),
    AcceptInvitationScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<AcceptInvitationScreenRouteArgs>(
              orElse: () => AcceptInvitationScreenRouteArgs(
                  secret: pathParams.getString('secret')));
          return _i17.AcceptInvitationScreen(secret: args.secret);
        }),
    LinkSharingScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (data) {
          final pathParams = data.pathParams;
          final args = data.argsAs<LinkSharingScreenRouteArgs>(
              orElse: () => LinkSharingScreenRouteArgs(
                  secret: pathParams.getString('secret')));
          return _i18.LinkSharingScreen(secret: args.secret);
        }),
    NotFoundScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i19.NotFoundScreen();
        }),
    LocationScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i20.LocationScreen();
        }),
    ProjectListScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i21.ProjectListScreen();
        }),
    ScheduleScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i22.ScheduleScreen();
        }),
    OrganizationScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i23.OrganizationScreen();
        }),
    UserScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i24.UserScreen();
        }),
    SettingsScreenRoute.name: (routeData) => _i1.MaterialPageX<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i25.SettingsScreen();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(DashboardScreenRoute.name, path: '/', guards: [
          hasOrganizationGuard
        ], children: [
          _i1.RouteConfig(LocationScreenRoute.name, path: 'location'),
          _i1.RouteConfig(ProjectListScreenRoute.name, path: 'projects'),
          _i1.RouteConfig(ScheduleScreenRoute.name, path: 'schedule'),
          _i1.RouteConfig(OrganizationScreenRoute.name, path: 'organization'),
          _i1.RouteConfig(UserScreenRoute.name, path: 'profile'),
          _i1.RouteConfig(SettingsScreenRoute.name, path: 'settings')
        ]),
        _i1.RouteConfig(ProjectDetailsScreenRoute.name,
            path: '/projects/:id', guards: [hasOrganizationGuard]),
        _i1.RouteConfig(UploadScreenRoute.name,
            path: '/projects/:projectId/uploads/:uploadId',
            guards: [hasOrganizationGuard]),
        _i1.RouteConfig(ReportScreenRoute.name,
            path: '/projects/:projectId/reports/:reportId',
            guards: [hasOrganizationGuard]),
        _i1.RouteConfig(SignUpScreenRoute.name,
            path: '/sign_up', guards: [signedInGuard]),
        _i1.RouteConfig(SignUpConfirmationScreenRoute.name,
            path: '/sign_up_confirmation'),
        _i1.RouteConfig(SignInScreenRoute.name,
            path: '/sign_in', guards: [signedInGuard]),
        _i1.RouteConfig(CreateOrganizationScreenRoute.name,
            path: '/create_organization', guards: [authGuard]),
        _i1.RouteConfig(ForgotPasswordScreenRoute.name,
            path: '/forgot_password'),
        _i1.RouteConfig(ChangePasswordScreenRoute.name, path: '/recover'),
        _i1.RouteConfig(ConfirmEmailScreenRoute.name, path: '/confirm_email'),
        _i1.RouteConfig(AcceptInvitationScreenRoute.name,
            path: '/join/:secret'),
        _i1.RouteConfig(LinkSharingScreenRoute.name, path: '/public/:secret'),
        _i1.RouteConfig(NotFoundScreenRoute.name, path: '*')
      ];
}

class DashboardScreenRoute extends _i1.PageRouteInfo {
  const DashboardScreenRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'DashboardScreenRoute';
}

class ProjectDetailsScreenRoute
    extends _i1.PageRouteInfo<ProjectDetailsScreenRouteArgs> {
  ProjectDetailsScreenRoute({required int id})
      : super(name,
            path: '/projects/:id',
            args: ProjectDetailsScreenRouteArgs(id: id),
            rawPathParams: {'id': id});

  static const String name = 'ProjectDetailsScreenRoute';
}

class ProjectDetailsScreenRouteArgs {
  const ProjectDetailsScreenRouteArgs({required this.id});

  final int id;
}

class UploadScreenRoute extends _i1.PageRouteInfo<UploadScreenRouteArgs> {
  UploadScreenRoute({required int projectId, required int uploadId})
      : super(name,
            path: '/projects/:projectId/uploads/:uploadId',
            args:
                UploadScreenRouteArgs(projectId: projectId, uploadId: uploadId),
            rawPathParams: {'projectId': projectId, 'uploadId': uploadId});

  static const String name = 'UploadScreenRoute';
}

class UploadScreenRouteArgs {
  const UploadScreenRouteArgs(
      {required this.projectId, required this.uploadId});

  final int projectId;

  final int uploadId;
}

class ReportScreenRoute extends _i1.PageRouteInfo<ReportScreenRouteArgs> {
  ReportScreenRoute({required int projectId, required int reportId})
      : super(name,
            path: '/projects/:projectId/reports/:reportId',
            args:
                ReportScreenRouteArgs(projectId: projectId, reportId: reportId),
            rawPathParams: {'projectId': projectId, 'reportId': reportId});

  static const String name = 'ReportScreenRoute';
}

class ReportScreenRouteArgs {
  const ReportScreenRouteArgs(
      {required this.projectId, required this.reportId});

  final int projectId;

  final int reportId;
}

class SignUpScreenRoute extends _i1.PageRouteInfo<SignUpScreenRouteArgs> {
  SignUpScreenRoute({String? urlInviteCode})
      : super(name,
            path: '/sign_up',
            args: SignUpScreenRouteArgs(urlInviteCode: urlInviteCode));

  static const String name = 'SignUpScreenRoute';
}

class SignUpScreenRouteArgs {
  const SignUpScreenRouteArgs({this.urlInviteCode});

  final String? urlInviteCode;
}

class SignUpConfirmationScreenRoute extends _i1.PageRouteInfo {
  const SignUpConfirmationScreenRoute()
      : super(name, path: '/sign_up_confirmation');

  static const String name = 'SignUpConfirmationScreenRoute';
}

class SignInScreenRoute extends _i1.PageRouteInfo {
  const SignInScreenRoute() : super(name, path: '/sign_in');

  static const String name = 'SignInScreenRoute';
}

class CreateOrganizationScreenRoute extends _i1.PageRouteInfo {
  const CreateOrganizationScreenRoute()
      : super(name, path: '/create_organization');

  static const String name = 'CreateOrganizationScreenRoute';
}

class ForgotPasswordScreenRoute extends _i1.PageRouteInfo {
  const ForgotPasswordScreenRoute() : super(name, path: '/forgot_password');

  static const String name = 'ForgotPasswordScreenRoute';
}

class ChangePasswordScreenRoute
    extends _i1.PageRouteInfo<ChangePasswordScreenRouteArgs> {
  ChangePasswordScreenRoute({String code = "", String? email})
      : super(name,
            path: '/recover',
            args: ChangePasswordScreenRouteArgs(code: code, email: email),
            rawQueryParams: {'reset_code': code, 'email': email});

  static const String name = 'ChangePasswordScreenRoute';
}

class ChangePasswordScreenRouteArgs {
  const ChangePasswordScreenRouteArgs({this.code = "", this.email});

  final String code;

  final String? email;
}

class ConfirmEmailScreenRoute
    extends _i1.PageRouteInfo<ConfirmEmailScreenRouteArgs> {
  ConfirmEmailScreenRoute({String code = "", String? urlJoinCode})
      : super(name,
            path: '/confirm_email',
            args: ConfirmEmailScreenRouteArgs(
                code: code, urlJoinCode: urlJoinCode),
            rawQueryParams: {'code': code, 'url_join_code': urlJoinCode});

  static const String name = 'ConfirmEmailScreenRoute';
}

class ConfirmEmailScreenRouteArgs {
  const ConfirmEmailScreenRouteArgs({this.code = "", this.urlJoinCode});

  final String code;

  final String? urlJoinCode;
}

class AcceptInvitationScreenRoute
    extends _i1.PageRouteInfo<AcceptInvitationScreenRouteArgs> {
  AcceptInvitationScreenRoute({required String secret})
      : super(name,
            path: '/join/:secret',
            args: AcceptInvitationScreenRouteArgs(secret: secret),
            rawPathParams: {'secret': secret});

  static const String name = 'AcceptInvitationScreenRoute';
}

class AcceptInvitationScreenRouteArgs {
  const AcceptInvitationScreenRouteArgs({required this.secret});

  final String secret;
}

class LinkSharingScreenRoute
    extends _i1.PageRouteInfo<LinkSharingScreenRouteArgs> {
  LinkSharingScreenRoute({required String secret})
      : super(name,
            path: '/public/:secret',
            args: LinkSharingScreenRouteArgs(secret: secret),
            rawPathParams: {'secret': secret});

  static const String name = 'LinkSharingScreenRoute';
}

class LinkSharingScreenRouteArgs {
  const LinkSharingScreenRouteArgs({required this.secret});

  final String secret;
}

class NotFoundScreenRoute extends _i1.PageRouteInfo {
  const NotFoundScreenRoute() : super(name, path: '*');

  static const String name = 'NotFoundScreenRoute';
}

class LocationScreenRoute extends _i1.PageRouteInfo {
  const LocationScreenRoute() : super(name, path: 'location');

  static const String name = 'LocationScreenRoute';
}

class ProjectListScreenRoute extends _i1.PageRouteInfo {
  const ProjectListScreenRoute() : super(name, path: 'projects');

  static const String name = 'ProjectListScreenRoute';
}

class ScheduleScreenRoute extends _i1.PageRouteInfo {
  const ScheduleScreenRoute() : super(name, path: 'schedule');

  static const String name = 'ScheduleScreenRoute';
}

class OrganizationScreenRoute extends _i1.PageRouteInfo {
  const OrganizationScreenRoute() : super(name, path: 'organization');

  static const String name = 'OrganizationScreenRoute';
}

class UserScreenRoute extends _i1.PageRouteInfo {
  const UserScreenRoute() : super(name, path: 'profile');

  static const String name = 'UserScreenRoute';
}

class SettingsScreenRoute extends _i1.PageRouteInfo {
  const SettingsScreenRoute() : super(name, path: 'settings');

  static const String name = 'SettingsScreenRoute';
}
