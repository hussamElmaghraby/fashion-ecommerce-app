import 'package:fashion_ecommerce/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/l10n.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../home/presentation/widgets/product_card.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../navigation/presentation/providers/navigation_provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(productsProvider);
    final s = context.s;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          s.favorites,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (favoritesState.favoriteIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(s.clearAllFavorites),
                    content: Text(s.removeAllFavoritesConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(s.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          ref
                              .read(favoritesProvider.notifier)
                              .clearAllFavorites();
                          Navigator.pop(dialogContext);
                        },
                        child: Text(
                          s.clearAll,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              tooltip: s.clearAll,
            ),
        ],
      ),
      body: productsAsync.when(
        data: (products) {
          final favoriteProducts = products
              .where((p) => favoritesState.favoriteIds.contains(p.id))
              .toList();

          if (favoriteProducts.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.favorite_border,
              title: s.noFavoritesYet,
              subtitle: s.startAddingFavorites,
              buttonText: s.browseProducts,
              onButtonPressed: () {
                ref.read(navigationIndexProvider.notifier).goToHome();
              },
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingMD),
                child: Text(
                  '${favoriteProducts.length} ${favoriteProducts.length == 1 ? L10nKeys.item.tr(context) : L10nKeys.items.tr(context)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMD,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: AppDimensions.paddingMD,
                    mainAxisSpacing: AppDimensions.paddingMD,
                  ),
                  itemCount: favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoriteProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        context.push('/product/${product.id}');
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('${s.error}: ${error.toString()}')),
      ),
    );
  }
}
