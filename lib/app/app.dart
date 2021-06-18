import 'package:flutter/material.dart' hide Router;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18next/i18next.dart';
import 'package:intl/intl.dart';
import 'package:guardspot/app/guards/auth_guard.dart';
import 'package:guardspot/app/guards/has_organization_guard.dart';
import 'package:guardspot/app/guards/signed_in_guard.dart';
import 'package:guardspot/app/router.gr.dart';
import 'package:guardspot/app/theme/theme.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:guardspot/inject/locator/locator.dart';
import 'package:guardspot/ui/common/view_models/theme_view_model.dart';
import 'package:guardspot/ui/common/widgets/typed_stream_builder.dart';
import 'package:guardspot/util/extensions/locale_extensions.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final UserStore userStore;
  final List<Locale> supportedLocales = [Locale("de")];

  App({UserStore? userStore}) : this.userStore = userStore ?? locator();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late ThemeViewModel _viewModel;
  late Router _router;

  @override
  void initState() {
    super.initState();
    _viewModel = locator();
    _router = Router(
      hasOrganizationGuard: HasOrganizationGuard(),
      signedInGuard: SignedInGuard(),
      authGuard: AuthGuard(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _viewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _viewModel,
      child: TypedStreamBuilder(
        initialData: _viewModel.currentThemeMode,
        stream: _viewModel.observableThemeMode,
        builder: (ThemeMode themeMode) => MaterialApp.router(
          routerDelegate: _router.delegate(),
          routeInformationParser: _router.defaultRouteParser(),
          debugShowCheckedModeBanner: false,
          onGenerateTitle: _generateTitle,
          theme: AppTheme.lightThemeData,
          darkTheme: AppTheme.darkThemeData,
          themeMode: themeMode,
          supportedLocales: widget.supportedLocales,
          localizationsDelegates: [
            I18NextLocalizationDelegate(
              locales: widget.supportedLocales,
              dataSource: AssetBundleLocalizationDataSource(
                bundlePath: "assets/localizations",
              ),
              options: I18NextOptions(
                formatter: _formatter,
                fallbackNamespace: "strings",
              ),
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
        ),
      ),
    );
  }

  String _formatter(Object value, String? format, Locale locale) {
    if (value is DateTime) {
      return DateFormat(format, locale.toString()).format(value);
    } else {
      return value.toString();
    }
  }

  String _generateTitle(BuildContext context) {
    return context.getString("app_name");
  }
}
