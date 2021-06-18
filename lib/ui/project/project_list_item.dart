import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.gr.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/models/project.dart';
import 'package:guardspot/ui/common/card/ink_card.dart';
import 'package:guardspot/ui/common/map/location_map.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  ProjectCard(this.project);

  @override
  Widget build(BuildContext context) {
    return InkCard(
      header: !kIsWeb ? LocationMap(project.location!) : null,
      body: _buildBody(context),
      onTap: () =>
          context.router.push(ProjectDetailsScreenRoute(id: project.id!)),
    );
  }

  Widget _buildBody(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          project.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.cardTitleText(themeData),
        ),
        SizedBox(height: 5.0),
        Text(
          // Add line breaks to prevent empty space
          project.description ?? "" + "\n\n",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.cardDescriptionText(themeData),
        ),
        SizedBox(height: 20.0),
        ProjectUsers(project, avatarStyle: UserAvatarStyle.small()),
      ],
    );
  }
}

class ProjectUsers extends StatelessWidget {
  final Project project;
  final bool compact;
  final UserAvatarStyle? avatarStyle;

  ProjectUsers(
    this.project, {
    this.compact = true,
    this.avatarStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...project.users.map(
          (user) => compact
              ? UserAvatar(user, style: avatarStyle)
              : Chip(
                  label: Text(user.name!),
                  avatar: UserAvatar(user, style: UserAvatarStyle.micro()),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
        ),
      ],
    );
  }
}
