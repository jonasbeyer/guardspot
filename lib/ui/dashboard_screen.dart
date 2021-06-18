import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/fcm/handler/navigation_intent.dart';
import 'package:guardspot/fcm/handler/notification_handler.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/main.dart';
import 'package:guardspot/models/user.dart';
import 'package:guardspot/ui/project/add_edit/add_edit_project_screen.dart';
import 'package:guardspot/ui/common/widgets/destination.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/ui/common/user/user_info.dart';
import 'package:guardspot/ui/user/user_view_model_delegate.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:guardspot/util/layout/adaptive.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late UserViewModelDelegate _viewModel;
  late NotificationHandler _notificationHandler;

  List<Destination> _destinations = [
    Destination(
      icon: Icons.list,
      titleKey: "title_project_list",
      route: ProjectListScreenRoute(),
    ),
    Destination(
      icon: Icons.people,
      titleKey: "title_organization",
      route: OrganizationScreenRoute(),
    ),
    Destination(
      icon: Icons.calendar_today,
      titleKey: "title_project_schedule",
      route: ScheduleScreenRoute(),
    ),
    Destination(
      icon: Icons.account_circle,
      titleKey: "title_user_profile",
      route: UserScreenRoute(),
    ),
    Destination(
      icon: Icons.settings,
      titleKey: "title_settings",
      route: SettingsScreenRoute(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _notificationHandler = locator();
    _notificationHandler.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kIsWeb) {
      _setUpNotificationSelectedListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: _destinations.map((it) => it.route!).toList(),
      builder: (BuildContext context, Widget child, _) {
        TabsRouter router = context.tabsRouter;
        return isDisplayDesktop(context)
            ? _buildDesktopScaffold(child, router)
            : _buildMobileScaffold(child, router);
      },
    );
  }

  Widget _buildMobileScaffold(Widget child, TabsRouter router) {
    int index = router.activeIndex;
    return Scaffold(
      appBar: AppBar(title: Text(_destinations[index].titleKey).t(context)),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (index) => router.setActiveIndex(index),
        selectedFontSize: 11.5,
        unselectedFontSize: 11.5,
        type: BottomNavigationBarType.fixed,
        items: _destinations.map((it) {
          return BottomNavigationBarItem(
            icon: Icon(it.icon),
            label: context.getString(it.titleKey),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDesktopScaffold(Widget child, TabsRouter router) {
    Color color = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(
        title: Text("app_name").t(context),
        elevation: 0,
        backgroundColor: ElevationOverlay.applyOverlay(context, color, 4.0),
      ),
      body: Row(
        children: [
          TypedValueStreamBuilder(
            stream: _viewModel.currentUserInfo,
            builder: (User? user) => _Sidebar(
              user: user!,
              destinations: _destinations,
              selectedIndex: router.activeIndex,
              onDestinationSelected: (index) => router.setActiveIndex(index),
            ),
          ),
          Divider(),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _setUpNotificationSelectedListener() {
    notificationSelected!.forEach((String payload) {
      NavigationIntent intent = NavigationIntent.fromJson(jsonDecode(payload));
      NavigatorState navigator = Navigator.of(context);

      navigator.pushNamed(intent.route, arguments: intent.data);
    });
  }
}

class _Sidebar extends StatelessWidget {
  final User user;
  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  _Sidebar({
    required this.user,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(width: 270),
      child: Material(
        elevation: 2.0,
        child: ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 16.0, 16.0, 16.0),
              child: UserInfo(user),
            ),
            Divider(height: 15),
            ...destinations
                .mapIndexed((index, destination) => _SidebarDestination(
                      destination: destination as Destination,
                      selected: index == selectedIndex,
                      onSelected: () => onDestinationSelected?.call(index),
                    ))
                .toList(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              child: FloatingActionButton.extended(
                heroTag: "add_project_fab",
                label: Text("add_project").t(context),
                onPressed: () => showAddEditProjectInput(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarDestination extends StatelessWidget {
  final Destination destination;
  final bool selected;
  final VoidCallback? onSelected;

  _SidebarDestination({
    required this.destination,
    this.selected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).colorScheme.primary;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () => onSelected?.call(),
        borderRadius: BorderRadius.circular(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: selected ? selectedColor.withOpacity(0.12) : null,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(destination.icon, color: selected ? selectedColor : null),
                SizedBox(width: 28),
                Text(
                  context.getString(destination.titleKey),
                  style: TextStyle(
                    fontSize: 15.0,
                    color: selected ? selectedColor : null,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
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
