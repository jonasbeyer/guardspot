import 'package:auto_route/auto_route.dart';
import 'package:fimber/fimber.dart';
import 'package:guardspot/app/router.gr.dart';
import 'package:guardspot/data/user/user_store.dart';
import 'package:guardspot/inject/locator/locator.dart';

class SignedInGuard extends AutoRouteGuard {
  UserStore userStore;

  SignedInGuard({UserStore? userStore})
      : this.userStore = userStore ?? locator();

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (userStore.isAuthenticated()) {
      Fimber.d("The user is already signed in. Navigate to dashboard screen");
      router.root.push(DashboardScreenRoute());
      resolver.next(false);
    } else {
      resolver.next(true);
    }
  }
}
