import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/view_models/view_state_view_model.dart';
import 'package:guardspot/ui/common/widgets/adptive_input_body.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/onboarding/create_organization/create_organization_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/validators.dart';

class CreateOrganizationScreen extends StatefulWidget {
  @override
  _CreateOrganizationScreenState createState() =>
      _CreateOrganizationScreenState();
}

class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {
  late CreateOrganizationViewModel _viewModel;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.onSuccess
        .listen((_) => context.router.popAndPush(DashboardScreenRoute()));
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
      appBar: AppBar(title: Text("app_name").t(context)),
      body: AdaptiveInputBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.getString("create_organization"),
              style: TextStyles.primaryTitle(themeData),
            ),
            SizedBox(height: 40.0),
            TypedStreamBuilder(
              stream: _viewModel.data,
              builder: (ViewState viewState) => Form(
                key: _formKey,
                child: _buildForm(viewState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(ViewState viewState) {
    ThemeData themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: _viewModel.name.add,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => notEmptyValidator(value!, context),
          autofocus: true,
          decoration: InputDecoration(
            labelText: context.getString("company_name"),
            helperText: context.getString("company_name_hint"),
            prefixIcon: Icon(Icons.people),
          ),
        ),
        SizedBox(height: 40.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("create").t(context),
            onPressed: viewState is ViewStateLoading ? null : _submitForm,
          ),
        ),
        if (viewState is ViewStateError)
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text(
              context.getString(viewState.errorKey),
              style: TextStyles.errorText(themeData),
            ),
          ),
      ],
    );
  }

  void _submitForm() {
    FormState formState = _formKey.currentState!;
    if (formState.validate()) {
      _viewModel.createOrganization();
    }
  }
}
