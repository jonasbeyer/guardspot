import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/auth/sign_in/sign_in_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/validators.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late GlobalKey<FormState> _formKey = GlobalKey();
  late SignInViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.viewStateResult.listen((destination) {
      _navigateToDestination(destination);
    }, onError: (error) {
      context.showLocalizedSnackBar(error);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TypedStreamBuilder(
        initialData: false,
        stream: _viewModel.onLoading,
        builder: (bool isLoading) => SafeArea(
          child: AdaptiveInputBody(
            alignment: Alignment.center,
            width: 550,
            child: _buildBody(isLoading),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(bool isLoading) {
    ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.getString("welcome_at_app"),
          style: TextStyles.primaryTitle(themeData),
        ),
        SizedBox(height: 10),
        Text(
          context.getString("sign_in_hint"),
          style: TextStyles.secondarySubtitle(themeData),
        ),
        SizedBox(height: 40.0),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                onChanged: _viewModel.email.add,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => emailValidator(value!, context),
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.getString("user_email"),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                onChanged: _viewModel.password.add,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: context.getString("user_password"),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("sign_in").t(context),
                  onPressed: !isLoading ? _submitForm : null,
                ),
              ),
              SizedBox(height: 10.0),
              _AccountActions(),
            ],
          ),
        ),
      ],
    );
  }

  void _submitForm() {
    FormState formState = _formKey.currentState!;
    if (formState.validate()) {
      _viewModel.signIn();
    }
  }

  void _navigateToDestination(Destination destination) {
    StackRouter router = AutoRouter.of(context);
    switch (destination) {
      case Destination.DASHBOARD:
        router.replace(DashboardScreenRoute());
        break;
      case Destination.PENDING_CONFIRMATION:
        router.replace(SignUpConfirmationScreenRoute());
    }
  }
}

class _AccountActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (kIsWeb)
          TextButton(
            child: Text("no_account_yet").t(context),
            onPressed: () => context.router.push(SignUpScreenRoute()),
          ),
        if (kIsWeb) Text("·"),
        TextButton(
          child: Text("forgot_your_password").t(context),
          onPressed: () => context.router.push(ForgotPasswordScreenRoute()),
        ),
      ],
    );
  }
}
