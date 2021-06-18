import 'package:flutter/material.dart';
import 'package:guardspot/models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final UserAvatarStyle style;

  UserAvatar(
    this.user, {
    UserAvatarStyle? style,
  }) : this.style = style ?? UserAvatarStyle.medium();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: style.radius,
      backgroundColor: avatarColor,
      child: Text(
        user.initials,
        style: style.textStyle,
      ),
    );
  }

  Color get avatarColor {
    switch (user.id! % 5) {
      case 0:
        return Colors.lightBlueAccent;
      case 1:
        return Colors.deepPurpleAccent;
      case 2:
        return Colors.blueAccent;
      case 3:
        return Colors.orangeAccent;
      default:
        return Colors.tealAccent;
    }
  }
}

class UserAvatarStyle {
  final double radius;
  final TextStyle textStyle;

  UserAvatarStyle(this.radius, this.textStyle);

  factory UserAvatarStyle.micro() =>
      UserAvatarStyle(11, TextStyle(fontSize: 12));

  factory UserAvatarStyle.small() =>
      UserAvatarStyle(17, TextStyle(fontSize: 14));

  factory UserAvatarStyle.medium() =>
      UserAvatarStyle(28, TextStyle(fontSize: 19));

  factory UserAvatarStyle.large() =>
      UserAvatarStyle(60, TextStyle(fontSize: 45));
}
