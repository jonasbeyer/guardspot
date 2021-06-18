import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/models/comment.dart';
import 'package:guardspot/ui/project/view/common/comment/delete/delete_comment_dialog.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserAvatar(comment.creator!, style: UserAvatarStyle.small()),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Text(comment.content!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.creator!.name!,
              style: themeData.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              context.getString("date_time_long",
                  arguments: {"date": comment.createdAt!}),
              style: TextStyle(color: AppColors.textColorSecondary(themeData)),
            ),
          ],
        ),
        CommentActionsButton(comment),
      ],
    );
  }
}

class CommentActionsButton extends StatelessWidget {
  final Comment comment;

  CommentActionsButton(this.comment);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => value == 0
          ? showDialog(
              context: context,
              builder: (_) => DeleteCommentDialog(comment),
            )
          : showDialog(
              context: context,
              builder: (_) => DeleteCommentDialog(comment),
            ),
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => [
        PopupMenuItem(child: Text("edit").t(context), value: 0),
        PopupMenuItem(child: Text("delete").t(context), value: 1),
      ],
    );
  }
}
