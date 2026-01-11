import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider = StateNotifierProvider<NavigationNotifier, int>(
  (ref) => NavigationNotifier(),
);

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }

  void goToHome() => state = 0;
  void goToSearch() => state = 1;
  void goToCart() => state = 2;
  void goToFavorites() => state = 3;
  void goToProfile() => state = 4;
}
