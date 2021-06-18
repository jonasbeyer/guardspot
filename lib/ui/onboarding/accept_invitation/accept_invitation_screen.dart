import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/onboarding/accept_invitation/accept_invitation_view_model.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/auth/sign_up/sign_up_screen.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class AcceptInvitationScreen extends StatefulWidget {
  final String secret;

  AcceptInvitationScreen({
    @pathParam required this.secret,
  });

  @override
  _AcceptInvitationScreenState createState() => _AcceptInvitationScreenState();
}

class _AcceptInvitationScreenState extends State<AcceptInvitationScreen> {
  late AcceptInvitationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.acceptJoinUrl(widget.secret);
    _viewModel.onSuccess
        .listen((_) => context.router.replace(DashboardScreenRoute()));
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return !_viewModel.isSignedIn()
        ? SignUpScreen(urlInviteCode: widget.secret)
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("app_name").t(context),
            ),
            body: TypedStreamBuilder(
              stream: _viewModel.onError,
              builder: (_) => AdaptiveInputBody(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.getString("link_expired"),
                      style: TextStyles.primaryTitle(themeData),
                    ),
                    SizedBox(height: 10),
                    Text(
                      context.getString("link_expired_hint"),
                      style: TextStyles.secondarySubtitle(themeData),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
