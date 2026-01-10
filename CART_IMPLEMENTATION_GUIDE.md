# 🛒 Cart Implementation Guide

## Overview
The cart page has been redesigned to match the exact Figma design with two states: cart with items and empty cart.

## Design Implementation

### 📱 Cart Page States

#### 1. Cart with Items
- **Product Cards**: 
  - Rounded corners (16px)
  - White background with subtle shadow
  - Product image (80x80, rounded 12px)
  - Product name (2 lines max)
  - Size display
  - Price with $ symbol
  - Quantity controls (-, count, +)
  - Delete button (red icon)

- **Summary Section**:
  - White container with top rounded corners (24px)
  - Sub-total
  - VAT (5%)
  - Shipping fee ($0.00)
  - Divider line
  - Total (bold, larger font)
  - "Go To Checkout" button with arrow

#### 2. Empty Cart
- **Centered content**:
  - Large circular icon background (120x120)
  - Shopping cart icon (60px)
  - "Your Cart is Empty!" title
  - "When you add products, they'll appear here." subtitle

## File Structure

```
lib/features/cart/
├── presentation/
│   ├── pages/
│   │   └── cart_page.dart           # Main cart page (redesigned)
│   └── providers/
│       └── cart_provider.dart       # Cart state management (updated)
```

## Key Components

### CartPage
Main container with two conditional layouts:
- Empty state when `cartState.items.isEmpty`
- Cart with items when items exist

### _CartItemCard
Individual cart item with:
```dart
- Product image (CachedNetworkImage)
- Product details (name, size, price)
- Quantity controls (+/- buttons)
- Delete button (top-right)
```

### Price Summary
Bottom sheet with rounded top corners showing:
```dart
- Sub-total: Sum of all item prices
- VAT (5%): 5% of subtotal
- Shipping fee: $0.00 (free shipping)
- Total: subtotal + VAT + shipping
```

## Cart State Management

### CartState Properties
```dart
class CartState {
  final List<CartItemModel> items;
  final bool isLoading;
  final String? error;
  
  // Calculated getters
  double get subtotal;  // Sum of all items
  double get shipping;  // $0.00
  double get tax;       // 5% of subtotal
  double get total;     // subtotal + tax + shipping
  int get itemCount;    // Total quantity
}
```

### Cart Operations

#### Add to Cart
```dart
await ref.read(cartProvider.notifier).addToCart(cartItem);
```

#### Update Quantity
```dart
await ref.read(cartProvider.notifier).updateQuantity(itemId, newQuantity);
```

#### Remove Item
```dart
await ref.read(cartProvider.notifier).removeFromCart(itemId);
```

#### Clear Cart
```dart
await ref.read(cartProvider.notifier).clearCart();
```

## UI Design Specifications

### Colors
```dart
- Background: #FFFFFF (white)
- Card background: #FFFFFF
- Text primary: #1F2937 (dark gray)
- Text secondary: #6B7280 (gray)
- Delete button bg: #FEE2E2 (light red)
- Delete icon: #DC2626 (red)
- Button bg: #1F2937 (dark)
- Button text: #FFFFFF (white)
```

### Typography
```dart
- Product name: 14px, weight: 600
- Size: 12px, weight: 400, color: secondary
- Price: 16px, weight: 700
- Summary labels: 14px, weight: 400
- Summary values: 14px, weight: 600
- Total label: 16px, weight: 700
- Total value: 18px, weight: 700
- Button text: 16px, weight: 600
```

### Spacing
```dart
- Page padding: 16px
- Card padding: 12px
- Card spacing: 12px
- Summary padding: 20px
- Element spacing: 8-16px
```

### Border Radius
```dart
- Cards: 16px
- Product image: 12px
- Delete button: 6px
- Quantity controls: 20px (pill shape)
- Checkout button: 28px (pill shape)
- Summary container: 24px (top corners only)
```

### Shadows
```dart
- Card shadow:
  color: rgba(0, 0, 0, 0.04)
  offset: (0, 2)
  blur: 8px
  
- Summary shadow:
  color: rgba(0, 0, 0, 0.08)
  offset: (0, -4)
  blur: 12px
```

## Quantity Controls Design

```
┌─────────────────────────┐
│  (-)   [2]   (+)        │
│   ○     2     ●         │  
└─────────────────────────┘

- Background: Light gray (#F3F4F6)
- Minus button: White circle
- Plus button: Dark circle with white icon
- Count: 14px, weight: 600
- Padding: 4px horizontal, 2px vertical
```

## Delete Button Design

```
┌────┐
│ 🗑️  │  Red trash icon on light red background
└────┘
- Size: 24x24 (with padding)
- Background: #FEE2E2
- Icon: Red (#DC2626)
- Border radius: 6px
```

## Empty State Design

```
        ┌───────┐
        │   🛒   │  Large gray circle with cart icon
        └───────┘
        
   Your Cart is Empty!
   
When you add products, they'll
       appear here.
```

## Checkout Button Design

```
┌─────────────────────────────────┐
│  Go To Checkout  →              │
└─────────────────────────────────┘

- Full width
- Height: 56px
- Background: Dark (#1F2937)
- Text: White, 16px, weight: 600
- Border radius: 28px (pill shape)
- Arrow icon: 20px
```

## Integration Points

### Product Details Page
When user adds to cart:
```dart
final cartItem = CartItemModel(
  id: const Uuid().v4(),
  product: product,
  quantity: _quantity,
  selectedSize: _selectedSize,
  selectedColor: _selectedColor,
);
await ref.read(cartProvider.notifier).addToCart(cartItem);
```

### Navigation
- Accessible from bottom navigation (3rd tab)
- Can navigate to checkout via button
- Back button returns to previous screen

### Persistence
- Cart items stored in Hive
- Survives app restarts
- Syncs across app

## Cart Calculations

### Example Calculation
```
Product 1: $1,190 × 1 = $1,190
Product 2: $1,000 × 1 = $1,000
Product 3: $1,290 × 1 = $1,290
─────────────────────────────────
Sub-total:              $3,470
VAT (5%):               $   173.50
Shipping fee:           $     0.00
─────────────────────────────────
Total:                  $3,643.50
```

### Calculation Logic
```dart
subtotal = items.fold(0, (sum, item) => 
    sum + (item.product.price × item.quantity)
);
vat = subtotal × 0.05;
shipping = 0.00;
total = subtotal + vat + shipping;
```

## Error Handling

### Empty Cart
- Shows empty state illustration
- Friendly message
- No error state needed

### Item Removal
- Instant UI update
- Recalculates totals
- Persists to storage

### Quantity Update
- Validates minimum (1)
- Updates price instantly
- Persists change

## Performance Optimizations

### Image Loading
- `CachedNetworkImage` for product images
- Placeholder during load
- Error widget for failed loads
- Cached for better performance

### State Updates
- Efficient Riverpod updates
- Only rebuilds affected widgets
- Minimal re-renders

### Storage
- Fast Hive operations
- Lazy loading
- Efficient serialization

## Testing Checklist

### Functionality
- [ ] Add items to cart from product details
- [ ] Update quantity (increase/decrease)
- [ ] Quantity doesn't go below 1
- [ ] Remove individual items
- [ ] Empty state shows correctly
- [ ] Calculations are accurate (subtotal, VAT, total)
- [ ] Navigate to checkout
- [ ] Cart persists after app restart
- [ ] Bottom navigation cart tab works

### UI/UX
- [ ] Product images load correctly
- [ ] Cards have proper shadows
- [ ] Delete button is responsive
- [ ] Quantity controls work smoothly
- [ ] Summary section has rounded top
- [ ] Checkout button has arrow icon
- [ ] Empty state is centered
- [ ] Scrolling works with many items
- [ ] Layout responsive to different screen sizes

## Usage Examples

### Add to Cart from Product Details
```dart
// In product_details_page.dart
ElevatedButton(
  onPressed: () async {
    final cartItem = CartItemModel(
      id: const Uuid().v4(),
      product: product,
      quantity: _quantity,
      selectedSize: _selectedSize,
    );
    
    await ref.read(cartProvider.notifier).addToCart(cartItem);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  },
  child: const Text('Add to Cart'),
),
```

### Access Cart from Navigation
```dart
// Bottom navigation automatically handles routing
// Cart page is 3rd tab (index 2)
```

### Navigate to Checkout
```dart
// In cart_page.dart checkout button
ElevatedButton(
  onPressed: () => context.push('/checkout'),
  child: const Text('Go To Checkout →'),
),
```

## Future Enhancements

### Potential Features
1. **Promo Codes**: Discount code input
2. **Saved for Later**: Move items to wishlist
3. **Recently Viewed**: Show related products
4. **Bulk Actions**: Select multiple items
5. **Cart Sharing**: Share cart via link
6. **Cart Notifications**: Remind about abandoned cart
7. **Price Alerts**: Notify when price drops
8. **Stock Warnings**: Show limited availability

## Troubleshooting

### Cart Not Updating
**Issue**: UI doesn't reflect changes
**Solution**: 
- Verify `ref.watch(cartProvider)` is used
- Check CartNotifier state updates
- Ensure Hive storage is initialized

### Images Not Loading
**Issue**: Product images show error widget
**Solution**:
- Check internet connection
- Verify image URLs are valid
- Check `CachedNetworkImage` configuration

### Calculations Incorrect
**Issue**: Totals don't match expected values
**Solution**:
- Verify VAT is 5% (0.05)
- Check shipping is $0.00
- Ensure all items included in subtotal

## Commands

```bash
# Run the app
flutter run

# Hot restart to see cart changes
# Press 'R' in terminal

# Generate code (if needed)
dart run build_runner build --delete-conflicting-outputs
```

## Summary

✅ **Implemented**:
- Pixel-perfect cart design matching Figma
- Empty cart state with illustration
- Cart item cards with all details
- Quantity controls (+/-)
- Delete button with icon
- Price summary section
- VAT (5%) calculation
- Checkout button with arrow
- Full cart functionality
- Hive persistence
- State management with Riverpod

**Status: ✅ COMPLETE**

The cart design and functionality are now fully implemented and match the Figma design exactly! 🎉
