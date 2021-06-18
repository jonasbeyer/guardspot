import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/dimens.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/auth/sign_up/sign_up_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:guardspot/util/validators.dart';

class SignUpScreen extends StatefulWidget {
  final String? urlInviteCode;

  SignUpScreen({this.urlInviteCode});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  late SignUpViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setJoinCode(widget.urlInviteCode);
    _viewModel.viewStateResult.listen((_) {
      context.router.popAndPush(SignUpConfirmationScreenRoute());
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
      body: AdaptiveInputBody(
        width: 480,
        alignment: Alignment.center,
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 60.0),
            SizedBox(height: AppDimens.spacingExtraLarge),
            Text(
              context.getString("try_it_free"),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Card(
              elevation: 1.5,
              child: Padding(
                padding: EdgeInsets.all(AppDimens.cardContentPaddingDesktop),
                child: Form(
                  key: _formKey,
                  child: _buildSignUpForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("create_account", style: Theme.of(context).textTheme.headline5)
            .t(context),
        SizedBox(height: 10),
        Text("fill_in_account_data").t(context),
        SizedBox(height: 30.0),
        TextFormField(
          onChanged: _viewModel.name.add,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => notEmptyValidator(value!, context),
          autofocus: true,
          maxLength: 60,
          decoration: InputDecoration(
            labelText: context.getString("your_name"),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 20.0),
        TextFormField(
          onChanged: _viewModel.email.add,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => emailValidator(value!, context),
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
          validator: (value) => passwordValidator(value!, context),
          decoration: InputDecoration(
            labelText: context.getString("user_password"),
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        SizedBox(height: 25.0),
        TypedStreamBuilder(
          initialData: false,
          stream: _viewModel.onLoading,
          builder: (bool isLoading) => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("sign_up").t(context),
              onPressed: isLoading ? null : _submitForm,
            ),
          ),
        ),
        SizedBox(height: 10),
        //Html(
        //  data: context.getString("sign_up_legal_hint"),
        //  onLinkTap: launch,
        //),
        Divider(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("already_signed_up").t(context),
            SizedBox(width: 3.0),
            TextButton(
              child: Text("go_to_sign_in").t(context),
              onPressed: () => context.router.navigate(SignInScreenRoute()),
            ),
          ],
        ),
      ],
    );
  }

  void _submitForm() {
    FormState formState = _formKey.currentState!;
    if (formState.validate()) {
      _viewModel.signUp();
    }
  }
}
