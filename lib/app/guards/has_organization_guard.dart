import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:guardspot/app/router.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:guardspot/inject/locator/locator.dart';

class HasOrganizationGuard extends AutoRouteGuard {
  UserStore userStore;

  HasOrganizationGuard({UserStore? userStore})
      : this.userStore = userStore ?? locator();

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (!userStore.hasOrganization()) {
      Fimber.d("No organization set up. Navigate to new organization screen");
      router.root.push(CreateOrganizationScreenRoute());
      resolver.next(false);
    } else {
      resolver.next(true);
    }
  }
}
