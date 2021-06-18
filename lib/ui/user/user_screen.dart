import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/common/card/flat_card.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_avatar.dart';
import 'package:guardspot/ui/user/user_sign_out_dialog.dart';
import 'package:guardspot/ui/user/user_view_model_delegate.dart';
import 'package:guardspot/util/enum_util.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late UserViewModelDelegate _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypedValueStreamBuilder(
      stream: _viewModel.currentUserInfo,
      builder: (User? user) => Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _UserCard(user!),
              SizedBox(height: 60),
              TextButton(
                child: Text("Abmelden".toUpperCase()),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => UserSignOutDialog(_viewModel),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.delete),
                label: Text("Konto löschen".toUpperCase()),
                onPressed: () => null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;

  _UserCard(this.user);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      width: 500,
      child: FlatCard(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(user, style: UserAvatarStyle.large()),
            SizedBox(height: 25),
            Text(user.name!, style: TextStyle(fontSize: 35.0)),
            Text(user.email!, style: TextStyles.secondarySubtitle(themeData)),
            SizedBox(height: 20),
            Text("user_role.${asName(user.role)}").t(context),
          ],
          // children: [
          //   UserAvatar(user, style: UserAvatarStyle.large()),
          //   SizedBox(height: 20),
          //   TextFormField(
          //     initialValue: user.name,
          //     // onChanged: widget.viewModel.changeName,
          //     // autovalidateMode: AutovalidateMode.onUserInteraction,
          //     // validator: (value) => notEmptyValidator(value, context),
          //     // autofocus: true,
          //     decoration: InputDecoration(
          //       labelText: "Name",
          //       border: const OutlineInputBorder(),
          //     ),
          //   ),
          //   SizedBox(height: 15),
          //   TextFormField(
          //     initialValue: user.email,
          //     // onChanged: widget.viewModel.changeName,
          //     // autovalidateMode: AutovalidateMode.onUserInteraction,
          //     // validator: (value) => notEmptyValidator(value, context),
          //     // autofocus: true,
          //     decoration: InputDecoration(
          //       labelText: "Email",
          //       border: const OutlineInputBorder(),
          //     ),
          //   ),
          //   SizedBox(height: 10),
          //   Text("Passwort ändern"),
          //   ElevatedButton(
          //     child: Text("Änderungen speichern"),
          //     onPressed: () => null,
          //   )
          // ],
        ),
      ),
    );
  }
}

// class _UserInfoContent extends StatelessWidget {
//   final User user;

//   _UserInfoContent(this.user);

//   @override
//   Widget build(BuildContext context) {
//     ThemeData themeData = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             context.getString("user_information").toUpperCase(),
//             style: TextStyles.sectionHeader(themeData),
//           ),
//         ),
// //        ListTile(
// //          title: Text("user_radio_name").translate(context),
// //          subtitle: Text(
// //            team.name ?? context.getString("Nicht im Dienst"),
// //          ),
// //          leading: Icon(Icons.supervisor_account),
// //        ),
//         ListTile(
//           title: Text("user_email").t(context),
//           subtitle: Text(user.email),
//           leading: Icon(Icons.email),
//         ),
// //        ListTile(
// //          title: Text("user_address").translate(context),
// //          subtitle: Text(user.address),
// //          leading: Icon(Icons.location_on),
// //        ),
// //        ListTile(
// //          title: Text("city").translate(context),
// //          subtitle: Text(user.place),
// //          leading: Icon(Icons.location_city),
// //        ),
// //        ListTile(
// //          title: Text("user_birthday").translate(context),
// //          subtitle: Text("date_time_long")
// //              .translate(context, arguments: {"date": user.birthday}),
// //          leading: Icon(Icons.date_range),
// //        ),
// //        ListTile(
// //          title: Text("user_gender").translate(context),
// //          subtitle: Text("user_gender_value.${user.gender}").translate(context),
// //          leading: Icon(Icons.person),
// //        ),
//       ],
//     );
//   }
// }
