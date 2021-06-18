import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/onboarding/confirm_email/confirm_email_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ConfirmEmailScreen extends StatefulWidget {
  final String code;
  final String? urlJoinCode;

  const ConfirmEmailScreen({
    @QueryParam("code") this.code = "",
    @QueryParam("url_join_code") this.urlJoinCode,
  });

  @override
  _ConfirmEmailScreenState createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
  late ConfirmEmailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.confirmEmail(widget.code);
    _viewModel.onSuccess.listen((_) {
      String? secret = widget.urlJoinCode;
      final destination = secret != null
          ? AcceptInvitationScreenRoute(secret: secret)
          : CreateOrganizationScreenRoute();

      context.router.replace(destination as PageRouteInfo);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
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
