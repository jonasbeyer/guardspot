import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class SignUpConfirmationScreen extends StatefulWidget {
  @override
  _SignUpConfirmationScreenState createState() =>
      _SignUpConfirmationScreenState();
}

class _SignUpConfirmationScreenState extends State<SignUpConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveInputBody(
        child: _buildBody(ViewState.initial()),
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
          "Überprüfen Sie Ihre E-Mails",
          style: TextStyles.primaryTitle(themeData),
        ),
        SizedBox(height: 10),
        Text(
          "Bestätigen Sie Ihre E-Mail-Adresse, um mit GuardSpot loszulegen.",
          style: TextStyles.secondarySubtitle(themeData),
        ),
        SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("E-Mail erneut senden"),
            onPressed: viewState is! ViewStateLoading ? _submit : null,
          ),
        ),
        if (viewState is ViewStateSuccess || viewState is ViewStateError)
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: viewState is ViewStateSuccess
                ? Text(viewState.data, style: TextStyles.successText).t(context)
                : Text(
                    (viewState as ViewStateError).errorKey,
                    style: TextStyles.errorText(themeData),
                  ).t(context),
          ),
      ],
    );
  }

  void _submit() {}
}
