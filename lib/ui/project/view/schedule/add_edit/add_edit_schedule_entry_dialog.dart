import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/app/theme/theme.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/widgets/add_edit_scaffold.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/project/view/schedule/add_edit/add_edit_schedule_entry_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/extensions/scaffold_extensions.dart';
import 'package:auto_route/auto_route.dart';
import 'package:guardspot/util/layout/adaptive.dart';

void showAddEditScheduleEntryInput({
  required BuildContext context,
  required Project project,
  ScheduleEntry? scheduleEntry,
}) {
  ScheduleEntry useScheduleEntry = scheduleEntry ??
      ScheduleEntry(
        date: DateTime.now(),
        startsAt: DateTime.now(),
        endsAt: DateTime.now().add(Duration(minutes: 30)),
        projectId: project.id,
      );

  showAdaptiveInput(
    context: context,
    dialogWidget: _AddEditScheduleEntryInput(
      project,
      useScheduleEntry,
      fullscreen: !isDisplayDesktop(context),
    ),
  );
}

class _AddEditScheduleEntryInput extends StatefulWidget {
  final Project project;
  final ScheduleEntry scheduleEntry;
  final bool fullscreen;

  _AddEditScheduleEntryInput(
    this.project,
    this.scheduleEntry, {
    this.fullscreen = true,
  });

  @override
  __AddEditScheduleEntryInputState createState() =>
      __AddEditScheduleEntryInputState();
}

class __AddEditScheduleEntryInputState
    extends State<_AddEditScheduleEntryInput> {
  late AddEditScheduleEntryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.setInitialEntry(widget.scheduleEntry);
    _viewModel.viewStateResult.listen((_) {
      context.router.pop();
      context.showLocalizedSnackBar("schedule_entry_saved");
    }, onError: (messageKey) {
      context.showLocalizedSnackBar(messageKey);
    });
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
      builder: (bool isLoading) => widget.fullscreen
          ? _buildScaffold(isLoading)
          : _buildDialog(isLoading),
    );
  }

  Widget _buildDialog(bool isSaving) {
    return AlertDialog(
      title: Text("create_schedule_entry").t(context),
      scrollable: true,
      content: SizedBox(
        width: 400,
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: AppTheme.smallInputDecorationTheme,
          ),
          child: _AddEditScheduleEntryForm(
            _viewModel,
            assignableUsers: widget.project.users,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.getString("cancel").toUpperCase()),
        ),
        ElevatedButton(
          onPressed: () => _viewModel.submit(),
          child: Text(context.getString("save").toUpperCase()),
        ),
      ],
    );
  }

  Widget _buildScaffold(bool isSaving) {
    return AddEditScaffold(
      title: context.getString("create_schedule_entry"),
      onSavePressed: () => _viewModel.submit,
      isSaving: isSaving,
      body: _AddEditScheduleEntryForm(
        _viewModel,
        assignableUsers: widget.project.users,
      ),
    );
  }
}

class _AddEditScheduleEntryForm extends StatelessWidget {
  final AddEditScheduleEntryViewModel viewModel;
  final List<User> assignableUsers;

  _AddEditScheduleEntryForm(
    this.viewModel, {
    this.assignableUsers = const [],
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    ScheduleEntry scheduleEntry = viewModel.scheduleEntry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: scheduleEntry.title,
          onChanged: (it) => viewModel.update(title: it),
          decoration: InputDecoration(
            labelText: "Titel (optional)",
            hintText: "Unbenannt",
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        SizedBox(height: 15),
        TypedStreamBuilder(
          initialData: scheduleEntry.date,
          stream: viewModel.observableScheduleEntry.map((it) => it.date!),
          builder: (DateTime dateTime) => TextFormField(
            readOnly: true,
            controller: TextEditingController(
              text: context.getString(
                "date_long",
                arguments: {"date": dateTime},
              ),
            ),
            decoration: InputDecoration(labelText: "Datum auswählen"),
            onTap: () async => viewModel.update(
              date: await showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: DateTime(2015),
                lastDate: DateTime(2300),
              ),
            ),
          ),
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypedStreamBuilder(
              initialData: scheduleEntry.startsAt,
              stream:
                  viewModel.observableScheduleEntry.map((it) => it.startsAt!),
              builder: (DateTime time) => Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: context.getString(
                    "time_long",
                    arguments: {"date": time},
                  )),
                  decoration: InputDecoration(labelText: "Startzeit"),
                  onTap: () async => viewModel.updateTime(
                    startsAt: await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.input,
                      initialTime: TimeOfDay.fromDateTime(time),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            TypedStreamBuilder(
              initialData: scheduleEntry.endsAt,
              stream: viewModel.observableScheduleEntry.map((it) => it.endsAt!),
              builder: (DateTime time) => Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: context.getString(
                    "time_long",
                    arguments: {"date": time},
                  )),
                  decoration: InputDecoration(labelText: "Endzeit"),
                  onTap: () async => viewModel.updateTime(
                    endsAt: await showTimePicker(
                      context: context,
                      initialEntryMode: TimePickerEntryMode.input,
                      initialTime: TimeOfDay.fromDateTime(time),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          initialValue: scheduleEntry.description,
          maxLines: 5,
          maxLength: 2000,
          onChanged: (it) => viewModel.update(description: it),
          decoration: InputDecoration(
            labelText: "Beschreibung (optional)",
            hintText: "Geben Sie zusätzliche Details an",
            contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        Text("PERSONEN", style: TextStyles.sectionHeader(themeData)),
        SizedBox(height: 10),
        _ScheduleUsers(
          assignedUsers: scheduleEntry.users,
          assignableUsers: assignableUsers,
          onChanged: (users) => viewModel.update(users: users),
        ),
      ],
    );
  }
}

class _ScheduleUsers extends StatefulWidget {
  final List<User> assignedUsers;
  final List<User> assignableUsers;
  final ValueChanged<List<User>>? onChanged;

  _ScheduleUsers({
    this.assignedUsers = const [],
    this.assignableUsers = const [],
    this.onChanged,
  });

  @override
  __ScheduleUsersState createState() => __ScheduleUsersState();
}

class __ScheduleUsersState extends State<_ScheduleUsers> {
  late List<User> assignedUsers;

  @override
  void initState() {
    super.initState();
    assignedUsers = widget.assignedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...assignedUsers.map((user) => Chip(
              label: Text(user.name!),
              avatar: UserAvatar(user, style: UserAvatarStyle.micro()),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )),
        ActionChip(
          label: Text("manage_project_members").t(context),
          onPressed: () => _showSelectionDialog(),
        ),
      ],
    );
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Nutzer auswählen"),
        contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        scrollable: true,
        content: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.assignableUsers.map(_buildMemberTile).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberTile(User user) {
    bool isAssigned = _isAssigned(user);
    return ListTile(
      title: Text(user.name!),
      leading: UserAvatar(user, style: UserAvatarStyle.small()),
      trailing: isAssigned ? Icon(Icons.check, size: 16.0) : null,
      onTap: () => _changeAssignment(user, isAssigned),
      contentPadding: EdgeInsets.only(left: 24, right: 15),
    );
  }

  bool _isAssigned(User user) => assignedUsers.any((it) => it.id == user.id);

  void _changeAssignment(User user, bool isAssigned) {
    List<User> newList = List.of(assignedUsers);

    if (_isAssigned(user)) {
      newList.removeWhere((it) => it.id == user.id);
    } else {
      newList.add(user);
    }

    setState(() {
      assignedUsers = newList;
      widget.onChanged?.call(assignedUsers);
    });
  }
}

// class _PeopleInputBuilder extends StatelessWidget {
//   _PeopleInputBuilder({
//     this.assignedUsers = const [],
//     this.assignableUsers = const [],
//     this.onChanged,
//   });

//   final List<User> assignedUsers;
//   final List<User> assignableUsers;
//   final ValueChanged<List<User>>? onChanged;

//   @override
//   Widget build(BuildContext context) {
//     return ChipsInput(
//       initialValue: assignedUsers,
//       decoration: InputDecoration(
//         labelText: "Personen auswählen",
//       ),
//       findSuggestions: (String query) {
//         if (query.length != 0) {
//           var lowercaseQuery = query.toLowerCase();
//           return assignableUsers.where((user) {
//             return user.name.toLowerCase().contains(query.toLowerCase());
//           }).toList(growable: false)
//             ..sort((a, b) => a.name
//                 .toLowerCase()
//                 .indexOf(lowercaseQuery)
//                 .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
//         } else {
//           return [];
//         }
//       },
//       onChanged: (data) {
//         onChanged(data.cast<User>());
//       },
//       chipBuilder: (context, state, user) {
//         return InputChip(
//           key: ObjectKey(user),
//           label: Text(user.name),
//           avatar: UserAvatar(user, style: UserAvatarStyle.small()),
//           onDeleted: () => state.deleteChip(user),
//           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//         );
//       },
//       suggestionBuilder: (context, state, user) {
//         return ListTile(
//           key: ObjectKey(user),
//           leading: UserAvatar(user, style: UserAvatarStyle.small()),
//           title: Text(user.name),
//           onTap: () => state.selectSuggestion(user),
//         );
//       },
//     );
//   }
// }
