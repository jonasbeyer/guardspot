import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/models/organization.dart';
import 'package:guardspot/ui/common/widgets/destination.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/organization/billing/billing_screen.dart';
import 'package:guardspot/ui/organization/edit/edit_organization_dialog.dart';
import 'package:guardspot/ui/organization/member_invitation/member_invitation_screen.dart';
import 'package:guardspot/ui/organization/member_list/member_list_screen.dart';
import 'package:guardspot/ui/organization/organization_view_model.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';

class OrganizationScreen extends StatefulWidget {
  final List<Destination> destinations = [
    Destination(
      titleKey: "members_title",
      widget: MemberListScreen(),
    ),
    Destination(
      titleKey: "invitation_title",
      widget: MemberInvitationScreen(),
    ),
    if (kIsWeb)
      Destination(
        titleKey: "billing_title",
        widget: BillingScreen(),
      ),
  ];

  @override
  _OrganizationScreenState createState() => _OrganizationScreenState();
}

class _OrganizationScreenState extends State<OrganizationScreen> {
  late OrganizationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _viewModel.fetchOrganizationDetails();
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return TypedStreamBuilder(
      stream: _viewModel.data,
      builder: (Organization organization) => DefaultTabController(
        length: widget.destinations.length,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  organization.name,
                  style: TextStyles.primaryTitle(themeData),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  child: Text("edit_organization").t(context),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => EditOrganizationDialog(
                      initialName: organization.name,
                    ),
                  ),
                ),
                Divider(height: 30.0),
                TabBar(
                  isScrollable: true,
                  tabs: widget.destinations
                      .map((d) => Tab(
                            text: context.getString(d.titleKey).toUpperCase(),
                          ))
                      .toList(),
                ),
                SizedBox(height: 15.0),
                Expanded(
                  child: Container(
                    width: 900,
                    child: TabBarView(
                      children:
                          widget.destinations.map((d) => d.widget!).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
