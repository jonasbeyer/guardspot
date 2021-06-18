import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/colors.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';

class UserInfo extends StatelessWidget {
  final User user;

  UserInfo(this.user);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        UserAvatar(user, style: UserAvatarStyle.medium()),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name!, style: TextStyle(fontSize: 20.0)),
            Text(
              user.email!,
              style: TextStyle(color: AppColors.textColorSecondary(themeData)),
            ),
          ],
        )
      ],
    );
  }
}
