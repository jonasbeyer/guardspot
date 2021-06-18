import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/models/schedule_entry.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/project/view/schedule/add_edit/add_edit_schedule_entry_dialog.dart';
import 'package:guardspot/ui/project/view/schedule/delete/delete_schedule_entry_dialog.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class ScheduleEntryItem extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  ScheduleEntryItem(this.scheduleEntry);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return FlatCard(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    scheduleEntry.title ?? "Unbenannt",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.cardTitleText(themeData),
                  ),
                  SizedBox(width: 5),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...scheduleEntry.users.map((user) =>
                          UserAvatar(user, style: UserAvatarStyle.small())),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 5),
              Text("${context.getString("time_long", arguments: {
                    "date": scheduleEntry.startsAt!
                  })} - ${context.getString("time_long", arguments: {
                    "date": scheduleEntry.endsAt!
                  })}")
            ],
          ),
          ScheduleEntryActionsButton(scheduleEntry),
        ],
      ),
    );
  }
}

class ScheduleEntryActionsButton extends StatelessWidget {
  final ScheduleEntry scheduleEntry;

  ScheduleEntryActionsButton(this.scheduleEntry);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => value == 0
          ? showAddEditScheduleEntryInput(
              context: context,
              project: Project(),
              scheduleEntry: scheduleEntry,
            )
          : showDialog(
              context: context,
              builder: (_) => DeleteScheduleEntryDialog(scheduleEntry),
            ),
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(child: Text("edit").t(context), value: 0),
        PopupMenuItem(child: Text("delete").t(context), value: 1),
      ],
    );
  }
}
