import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.gr.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/auth/password_reset/change_password/change_password_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/validators.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String code;
  final String? email;

  ChangePasswordScreen({
    @QueryParam("reset_code") this.code = "",
    @QueryParam("email") this.email,
  });

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ChangePasswordViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("app_name").t(context)),
      body: AdaptiveInputBody(
        child: TypedStreamBuilder(
          initialData: ViewState.initial(),
          stream: _viewModel.data,
          builder: (ViewState state) => state is ViewStateSuccess
              ? _PasswordChangeSuccessful()
              : _buildBody(state),
        ),
      ),
    );
  }

  Widget _buildBody(ViewState viewState) {
    ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.getString("reset_password"),
          style: TextStyles.primaryTitle(themeData),
        ),
        SizedBox(height: 10),
        Text(
          context.getString(
            "reset_password_hint",
            arguments: {"email": widget.email ?? ""},
          ),
          style: TextStyles.secondarySubtitle(themeData),
        ),
        SizedBox(height: 50),
        TextFormField(
          onChanged: _viewModel.password.add,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => passwordValidator(value!, context),
          obscureText: true,
          decoration: InputDecoration(
            labelText: context.getString("user_password"),
            helperText: context.getString("user_password_requirement"),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("change_password").t(context),
            onPressed: viewState is! ViewStateLoading
                ? () => _viewModel.submitPassword(widget.code)
                : null,
          ),
        ),
        if (viewState is ViewStateError)
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              viewState.errorKey,
              style: TextStyles.errorText(themeData),
            ).t(context),
          ),
      ],
    );
  }
}

class _PasswordChangeSuccessful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.getString("password_changed"),
          style: TextStyles.primaryTitle(themeData),
        ),
        SizedBox(height: 10),
        Text(
          context.getString("password_changed_hint"),
          style: TextStyles.secondarySubtitle(themeData),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("sign_in").t(context),
            onPressed: () => context.router.navigate(SignInScreenRoute()),
          ),
        ),
      ],
    );
  }
}
