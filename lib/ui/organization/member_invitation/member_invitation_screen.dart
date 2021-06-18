import 'package:flutter/material.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/widgets/read_only_url_info.dart';
import 'package:guardspot/ui/organization/member_invitation/member_invitation_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class MemberInvitationScreen extends StatefulWidget {
  @override
  _MemberInvitationScreenState createState() => _MemberInvitationScreenState();
}

class _MemberInvitationScreenState extends State<MemberInvitationScreen> {
  late MemberInvitationViewModel _viewModel;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 600,
          child: FutureBuilder(
            future: _viewModel.fetchJoinUrl(),
            builder: (_, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return InvitationUrlCard(snapshot.data!);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}

class InvitationUrlCard extends StatelessWidget {
  final String url;

  InvitationUrlCard(this.url);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "share_team_invite_link",
              style: Theme.of(context).textTheme.headline5,
            ).t(context),
            SizedBox(height: 5),
            Text("team_invite_link_explanation").t(context),
            SizedBox(height: 15),
            ReadOnlyUrlInfo(url),
            SizedBox(height: 30),
            Text("disable_team_invite_link_hint").t(context),
          ],
        ),
      ),
    );
  }
}
