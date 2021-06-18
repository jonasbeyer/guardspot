import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/dimens.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/app/theme/theme.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/location.dart';
import 'package:guardspot/models/prediction.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/widgets/add_edit_scaffold.dart';
import 'package:guardspot/ui/project/add_edit/add_edit_project_view_model.dart';
import 'package:guardspot/ui/project/add_edit/autocomplete_dialog.dart';
import 'package:guardspot/ui/common/map/location_map.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';
import 'package:guardspot/util/uuid.dart';
import 'package:guardspot/util/validators.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

void showAddEditProjectInput(
  BuildContext context, {
  Project? project,
}) {
  showAdaptiveInput(
    context: context,
    dialogWidget: _AddEditProjectDialog(project),
    scaffoldWidget: _AddEditProjectScreen(project),
  );
}

class _AddEditProjectScreen extends StatefulWidget {
  final Project? project;

  _AddEditProjectScreen(this.project);

  @override
  _AddEditProjectScreenState createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<_AddEditProjectScreen> {
  late AddEditProjectViewModel _viewModel;
  late GlobalKey<_AddEditProjectFormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setInitialProject(widget.project);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedStreamBuilder(
      initialData: false,
      stream: _viewModel.onLoading,
      builder: (bool isLoading) => AddEditScaffold(
        title: context
            .getString(widget.project != null ? "edit_project" : "add_project"),
        onSavePressed: () => _formKey.currentState!.submit(),
        isSaving: isLoading,
        padding: EdgeInsets.only(
          bottom: isDisplayDesktop(context)
              ? AppDimens.verticalPaddingDesktop
              : AppDimens.verticalPadding,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypedValueStreamBuilder(
              stream: _viewModel.location,
              builder: (Location location) => SizedBox(
                height: 200,
                child: LocationMap(location, interactive: true),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: _AddEditProjectForm(_viewModel, key: _formKey),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddEditProjectDialog extends StatefulWidget {
  final Project? project;

  _AddEditProjectDialog(this.project);

  @override
  _AddEditProjectDialogState createState() => _AddEditProjectDialogState();
}

class _AddEditProjectDialogState extends State<_AddEditProjectDialog> {
  late AddEditProjectViewModel _viewModel;
  late GlobalKey<_AddEditProjectFormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setInitialProject(widget.project);
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project != null ? "edit_project" : "add_project")
          .t(context),
      contentPadding: EdgeInsets.only(top: 22.0, bottom: 5.0),
      content: Scrollbar(
        isAlwaysShown: true,
        child: Padding(
          padding: EdgeInsets.only(left: 24.0, right: 40.0),
          child: SizedBox(
            width: 900,
            height: 450,
            child: _buildDialogContent(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.getString("cancel").toUpperCase()),
        ),
        ElevatedButton(
          onPressed: () => _formKey.currentState!.submit(),
          child: Text(context.getString("save").toUpperCase()),
        ),
      ],
    );
  }

  Widget _buildDialogContent() {
    ThemeData formThemeData = Theme.of(context)
        .copyWith(inputDecorationTheme: AppTheme.smallInputDecorationTheme);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TypedStreamBuilder(
          initialData: _viewModel.project.location,
          stream: _viewModel.location,
          builder: (Location location) => Container(
            width: 325,
            child: _buildCard(location),
          ),
        ),
        SizedBox(width: 40),
        Expanded(
          child: TypedStreamBuilder(
            initialData: false,
            stream: _viewModel.onLoading,
            builder: (bool isLoading) => isLoading
                ? Center(child: CircularProgressIndicator())
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 2.5),
                      child: Theme(
                        data: formThemeData,
                        child: _AddEditProjectForm(_viewModel, key: _formKey),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Location l) {
    ThemeData themeData = Theme.of(context);
    String url = "https://google.com/maps/place/${l.latitude},${l.longitude}";

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 250,
            child: LocationMap(l, interactive: true),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Google Maps".toUpperCase(),
                  style: TextStyles.sectionHeader(themeData),
                ),
                SizedBox(height: 8),
                InkWell(
                  onTap: () => launch(url),
                  child: Text(url, style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddEditProjectForm extends StatefulWidget {
  final AddEditProjectViewModel viewModel;
  final GlobalKey<_AddEditProjectFormState>? key;

  _AddEditProjectForm(this.viewModel, {this.key});

  @override
  _AddEditProjectFormState createState() => _AddEditProjectFormState();
}

class _AddEditProjectFormState extends State<_AddEditProjectForm> {
  late AddEditProjectViewModel _viewModel;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.viewStateResult.listen((_) {
      Navigator.of(context).pop();
      context.showLocalizedSnackBar("project_saved");
    }, onError: (error) {
      context.showLocalizedSnackBar(error);
    });

    _formKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    Project project = _viewModel.project;
    ThemeData themeData = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: project.name,
            onChanged: (it) => _viewModel.update(name: it),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => notEmptyValidator(value!, context),
            maxLength: 100,
            autofocus: true,
            decoration: InputDecoration(
              labelText: context.getString("project_name"),
              hintText: context.getString("project_name_hint"),
              counterText: "",
              contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          SizedBox(height: 20),
          ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: true),
            child: TextFormField(
              initialValue: project.description,
              onChanged: (it) => _viewModel.update(description: it),
              maxLines: 7,
              maxLength: 5000,
              decoration: InputDecoration(
                labelText: context.getString("project_description"),
                hintText: context.getString("project_description_hint"),
                contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          SizedBox(height: 15),
          Text(
            context.getString("project_location").toUpperCase(),
            style: TextStyles.sectionHeader(themeData),
          ),
          SizedBox(height: 5),
          Text(
            context.getString("project_location_description"),
            style: themeData.textTheme.caption,
          ),
          SizedBox(height: 15),
          TypedValueStreamBuilder(
            stream: _viewModel.observableProject,
            builder: (Project project) => _buildAddressFields(project),
          ),
          SizedBox(height: 15),
          Text(
            context.getString("project_client").toUpperCase(),
            style: TextStyles.sectionHeader(themeData),
          ),
          SizedBox(height: 5),
          Text(
            context.getString("project_client_description"),
            style: themeData.textTheme.caption,
          ),
          SizedBox(height: 15),
          TextFormField(
            initialValue: project.clientName,
            onChanged: (it) => _viewModel.update(clientName: it),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => notEmptyValidator(value!, context),
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: context.getString("project_client_name"),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: project.clientPhone,
            onChanged: (it) => _viewModel.update(clientPhone: it),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => notEmptyValidator(value!, context),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: context.getString("project_client_phone"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressFields(Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          readOnly: true,
          controller: TextEditingController(text: project.address),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => notEmptyValidator(value!, context),
          onTap: () => _showAddressAutocompleteDialog(),
          decoration:
              InputDecoration(labelText: context.getString("project_address")),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextFormField(
                enabled: false,
                controller: TextEditingController(text: project.postalCode),
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: context.getString("project_postal_code"),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                enabled: false,
                controller: TextEditingController(text: project.city),
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: context.getString("project_city"),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          enabled: false,
          controller: TextEditingController(text: project.countryCode),
          decoration:
              InputDecoration(labelText: context.getString("project_country")),
        ),
      ],
    );
  }

  Future<void> _showAddressAutocompleteDialog() async {
    String sessionToken = Uuid().generateV4();
    Prediction? prediction = await showDialog(
      context: context,
      builder: (context) => AutocompleteDialog(
        viewModel: _viewModel,
        sessionToken: sessionToken,
        startText: _viewModel.project.address,
        language: "de",
      ),
    );

    if (prediction != null) {
      _viewModel.updateLocation(prediction, sessionToken);
    }
  }

  void submit() {
    FormState formState = _formKey.currentState!;
    if (formState.validate()) {
      _viewModel.submit();
    }
  }
}
