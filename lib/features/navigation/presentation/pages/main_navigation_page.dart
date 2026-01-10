import 'package:flutter/material.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/utils/s.dart';


class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    CartPage(),
    FavoritesPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  label: L10nKeys.home.tr(context),
                  selectedIcon: Assets.icons.selectedHomeIcon,
                  unselectedIcon: Assets.icons.selectedHomeIcon, // Use same, change color
                ),
                _buildNavItem(
                  index: 1,
                  label: L10nKeys.search.tr(context),
                  selectedIcon: Assets.icons.unselectedSearchIcon,
                  unselectedIcon: Assets.icons.unselectedSearchIcon,
                ),
                _buildNavItem(
                  index: 2,
                  label: L10nKeys.card.tr(context),
                  selectedIcon: Assets.icons.unselectedCardIcon,
                  unselectedIcon: Assets.icons.unselectedCardIcon,
                ),
                _buildNavItem(
                  index: 3,
                  label: L10nKeys.favorites.tr(context),
                  selectedIcon: Assets.icons.unselectedSavesIcon,
                  unselectedIcon: Assets.icons.unselectedSavesIcon,
                ),
                _buildNavItem(
                  index: 4,
                  label: L10nKeys.account.tr(context),
                  selectedIcon: Assets.icons.unselectedAccountIcon,
                  unselectedIcon: Assets.icons.unselectedAccountIcon,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required SvgGenImage selectedIcon,
    required SvgGenImage unselectedIcon,
  }) {
    final isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            (isSelected ? selectedIcon : unselectedIcon).svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF111827) : const Color(0xFF9CA3AF),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
