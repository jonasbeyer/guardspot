import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/auth/password_reset/forgot_password/forgot_password_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late ForgotPasswordViewModel _viewModel;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey();
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
      appBar: AppBar(),
      body: TypedStreamBuilder(
        initialData: ViewState.initial(),
        stream: _viewModel.data,
        builder: (ViewState state) =>
            AdaptiveInputBody(child: _buildBody(state)),
      ),
    );
  }

  Widget _buildBody(ViewState viewState) {
    ThemeData themeData = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.getString("forgot_your_password"),
            style: TextStyles.primaryTitle(themeData),
          ),
          SizedBox(height: 10),
          Text(
            context.getString("forgot_your_password_hint"),
            style: TextStyles.secondarySubtitle(themeData),
          ),
          SizedBox(height: 50),
          TextFormField(
            onChanged: _viewModel.email.add,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => emailValidator(value!, context),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: context.getString("user_email"),
              hintText: context.getString("user_email_hint"),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text("reset_password").t(context),
              onPressed: viewState is! ViewStateLoading ? _submit : null,
            ),
          ),
          if (viewState is ViewStateSuccess || viewState is ViewStateError)
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: viewState is ViewStateSuccess
                  ? Text(viewState.data, style: TextStyles.successText)
                      .t(context)
                  : Text(
                      (viewState as ViewStateError).errorKey,
                      style: TextStyles.errorText(themeData),
                    ).t(context),
            ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _viewModel.requestPasswordReset();
    }
  }
}
