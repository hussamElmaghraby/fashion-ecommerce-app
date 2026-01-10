import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../data/models/cart_item_model.dart';
import '../../../home/presentation/providers/product_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../favorites/presentation/providers/favorites_provider.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final int productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  int _currentImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailsProvider(widget.productId));
    final isFavorite = ref
        .watch(favoritesProvider)
        .favoriteIds
        .contains(widget.productId);
    final favoritesNotifier = ref.read(favoritesProvider.notifier);

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          _selectedSize ??= product.sizes?.first;
          _selectedColor ??= product.colors?.first;

          return CustomScrollView(
            slivers: [
              // App Bar with Image
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: isFavorite
                          ? const Icon(Icons.favorite, color: Color(0xFFDC2626))
                          : const Icon(
                              Icons.favorite_border,
                              color: AppColors.textPrimary,
                            ),
                    ),
                    onPressed: () {
                      favoritesNotifier.toggleFavorite(widget.productId);
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemCount: product.images?.length ?? 1,
                    itemBuilder: (context, index) {
                      final imageUrl = product.images?[index] ?? product.image;
                      return CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.backgroundGrey,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.backgroundGrey,
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Product Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Indicators
                      if (product.images != null && product.images!.length > 1)
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              product.images!.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingXS,
                                ),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentImageIndex == index
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: AppDimensions.paddingMD),

                      // Product Title & Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: AppDimensions.fontTitle,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: AppDimensions.fontTitle,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingSM),

                      // Category & Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingSM,
                              vertical: AppDimensions.paddingXS,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundGrey,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSM,
                              ),
                            ),
                            child: Text(
                              product.category.toUpperCase(),
                              style: const TextStyle(
                                fontSize: AppDimensions.fontSM,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimensions.paddingMD),
                          const Icon(Icons.star, size: 20, color: Colors.amber),
                          const SizedBox(width: AppDimensions.paddingXS),
                          Text(
                            '${product.rating.rate} (${product.rating.count} reviews)',
                            style: const TextStyle(
                              fontSize: AppDimensions.fontMD,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),

                      // Stock Status
                      Row(
                        children: [
                          Icon(
                            product.inStock ? Icons.check_circle : Icons.cancel,
                            size: 20,
                            color: product.inStock
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          const SizedBox(width: AppDimensions.paddingXS),
                          Text(
                            product.inStock
                                ? L10nKeys.inStock.tr(context)
                                : L10nKeys.outOfStock.tr(context),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: product.inStock
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),

                      // Size Selection
                      if (product.sizes != null &&
                          product.sizes!.isNotEmpty) ...[
                        Text(
                          L10nKeys.selectSize.tr(context),
                          style: const TextStyle(
                            fontSize: AppDimensions.fontLG,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSM),
                        Wrap(
                          spacing: AppDimensions.paddingSM,
                          runSpacing: AppDimensions.paddingSM,
                          children: product.sizes!.map((size) {
                            final isSelected = _selectedSize == size;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSize = size;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingMD,
                                  vertical: AppDimensions.paddingSM,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.backgroundGrey,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSM,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontSize: AppDimensions.fontMD,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.textWhite
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                      ],

                      // Color Selection
                      if (product.colors != null &&
                          product.colors!.isNotEmpty) ...[
                        Text(
                          L10nKeys.selectColor.tr(context),
                          style: const TextStyle(
                            fontSize: AppDimensions.fontLG,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.paddingSM),
                        Wrap(
                          spacing: AppDimensions.paddingSM,
                          children: product.colors!.map((color) {
                            final isSelected = _selectedColor == color;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = color;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 2,
                                  ),
                                ),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: _getColorFromString(color),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppDimensions.paddingLG),
                      ],

                      // Quantity Selector
                      Text(
                        L10nKeys.quantity.tr(context),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontLG,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSM),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_quantity > 1) {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            iconSize: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingMD,
                            ),
                            child: Text(
                              _quantity.toString(),
                              style: const TextStyle(
                                fontSize: AppDimensions.fontXL,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            iconSize: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.paddingLG),

                      // Description
                      Text(
                        L10nKeys.description.tr(context),
                        style: const TextStyle(
                          fontSize: AppDimensions.fontLG,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingSM),
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: AppDimensions.fontMD,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXXL),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(productDetailsProvider(widget.productId));
          },
        ),
      ),
      bottomNavigationBar: productAsync.when(
        data: (product) => Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                offset: const Offset(0, -2),
                blurRadius: 8,
              ),
            ],
          ),
          child: SafeArea(
            child: CustomButton(
              text: L10nKeys.addToCart.tr(context),
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: AppColors.textWhite,
              ),
              onPressed: product.inStock
                  ? () {
                      final cartItem = CartItemModel(
                        id: const Uuid().v4(),
                        product: product,
                        quantity: _quantity,
                        selectedSize: _selectedSize,
                        selectedColor: _selectedColor,
                      );
                      ref.read(cartProvider.notifier).addToCart(cartItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart'),
                          duration: Duration(seconds: 2),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  : null,
            ),
          ),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'pink':
        return Colors.pink;
      case 'orange':
        return Colors.orange;
      case 'brown':
        return Colors.brown;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }
}
