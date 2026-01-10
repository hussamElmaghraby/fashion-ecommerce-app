# ❤️ Favorites/Save Feature Guide

## Overview
The favorites feature allows users to save products they like and access them later through the Favorites tab in the bottom navigation bar. All favorites are persisted using Hive local storage.

## Features Implemented

### 1. Save Button on Product Cards ⭐
- **Location**: Top-right corner of each product card
- **States**:
  - **Not Saved**: Gray bookmark icon
  - **Saved**: Red bookmark icon
- **Interaction**: Tap to toggle favorite status
- **Visual Feedback**: Circular white background with shadow

### 2. Favorites Tab 📱
- **Location**: Bottom navigation bar (4th tab)
- **Icon**: Bookmark icon
- **Displays**:
  - Grid of all saved products
  - Item count header
  - Empty state when no favorites
  - Clear All button in app bar

### 3. Product Details Favorite Button 💝
- **Location**: Top-right in app bar
- **States**:
  - **Not Saved**: Outlined heart icon
  - **Saved**: Filled red heart icon
- **Interaction**: Tap to toggle favorite status

### 4. Data Persistence 💾
- Uses Hive local storage
- Favorites persist across app restarts
- Fast read/write operations
- Automatic sync between all screens

## File Structure

```
lib/
├── features/
│   └── favorites/
│       └── presentation/
│           ├── pages/
│           │   └── favorites_page.dart          # Favorites screen
│           └── providers/
│               └── favorites_provider.dart      # State management
├── home/
│   └── presentation/
│       └── widgets/
│           └── product_card.dart                # Updated with save button
└── data/
    └── services/
        └── storage_service.dart                 # Updated with favorites methods
```

## Implementation Details

### State Management with Riverpod

```dart
// Favorites Provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier(StorageService());
});
```

### Favorites State
```dart
class FavoritesState {
  final List<int> favoriteIds;  // Product IDs
  final bool isLoading;
}
```

### Key Methods

#### Toggle Favorite
```dart
await favoritesNotifier.toggleFavorite(productId);
```

#### Check if Favorite
```dart
bool isFavorite = favoritesState.favoriteIds.contains(productId);
```

#### Clear All Favorites
```dart
await favoritesNotifier.clearAllFavorites();
```

## Storage Service API

### Add Favorite
```dart
await StorageService().addFavorite(productId);
```

### Remove Favorite
```dart
await StorageService().removeFavorite(productId);
```

### Get All Favorite IDs
```dart
List<int> favorites = StorageService().getFavoriteIds();
```

### Check if Product is Favorite
```dart
bool isFavorite = StorageService().isFavorite(productId);
```

### Clear All Favorites
```dart
await StorageService().clearFavorites();
```

## UI Components

### Product Card with Save Button

The save button appears on:
- **Home Page**: Product grid
- **Search Page**: Search results
- **Favorites Page**: Saved items grid

**Design Specifications**:
- Size: 32x32 dp
- Background: White circle with shadow
- Icon: Bookmark (18x18 dp)
- Colors:
  - Saved: `#DC2626` (Red)
  - Not Saved: `#9CA3AF` (Gray)

### Favorites Page

**Components**:
1. **App Bar**:
   - Title: "Favorites"
   - Clear All button (when items exist)

2. **Item Count**:
   - Shows total saved items
   - Format: "X Items" or "X Item"

3. **Product Grid**:
   - 2 columns
   - Same layout as Home page
   - Tap to view details

4. **Empty State**:
   - Icon: Outlined heart
   - Title: "No Favorites Yet"
   - Subtitle: "Start adding your favorite items"
   - Action: Browse Products button

## User Flow

### Saving a Product

1. User browses products (Home/Search/Details)
2. User taps bookmark/heart icon
3. Product is added to favorites
4. Icon changes to filled/red state
5. Item appears in Favorites tab

### Removing a Product

**Method 1: Individual Removal**
1. Tap the bookmark/heart icon again
2. Product is removed from favorites
3. Icon changes to outline/gray state
4. Item disappears from Favorites tab

**Method 2: Clear All**
1. Open Favorites tab
2. Tap "Delete" icon in app bar
3. Confirm in dialog
4. All favorites are removed

## Integration Points

### Product Card Widget
```dart
// Updated to ConsumerWidget for Riverpod access
class ProductCard extends ConsumerWidget {
  // Uses favoritesProvider to:
  // - Check favorite status
  // - Toggle favorites
  // - Update UI reactively
}
```

### Product Details Page
```dart
// Already ConsumerWidget
// Added:
// - Favorite icon in app bar
// - Toggle functionality
// - Real-time state updates
```

### Favorites Page
```dart
// ConsumerWidget
// Features:
// - Displays saved products
// - Clear all functionality
// - Empty state handling
// - Navigation to product details
```

## Testing

### Manual Testing Checklist

- [ ] Save a product from Home page
- [ ] Verify it appears in Favorites tab
- [ ] Save a product from Search results
- [ ] Save a product from Product Details
- [ ] Unsave a product from card
- [ ] Unsave from Product Details
- [ ] Navigate between tabs (state preserved)
- [ ] Close and reopen app (data persists)
- [ ] Clear all favorites
- [ ] Confirm empty state displays correctly

### Edge Cases Handled

1. **Empty Favorites**: Shows empty state with call-to-action
2. **Navigation**: Tapping saved product opens details
3. **State Sync**: Updates across all screens instantly
4. **Storage Errors**: Gracefully handled with error logging
5. **Duplicate Saves**: Prevented by using Set semantics

## Performance Considerations

### Optimizations
- **Hive Storage**: Fast key-value access
- **Provider Caching**: State persists during session
- **Lazy Loading**: Favorites loaded on demand
- **Efficient Updates**: Only rebuilds affected widgets

### Storage Usage
- Minimal: Only stores product IDs (integers)
- Typical usage: < 1 KB for 100+ favorites

## Future Enhancements

### Potential Features
1. **Collections**: Group favorites into custom lists
2. **Sharing**: Share favorite products
3. **Notifications**: Price drop alerts for saved items
4. **Sort/Filter**: Sort favorites by price, date, category
5. **Sync**: Cloud sync for multi-device access
6. **Analytics**: Track most favorited products

## Troubleshooting

### Favorites Not Persisting
**Issue**: Favorites disappear after app restart
**Solution**: 
- Verify `StorageService.init()` is called in `main.dart`
- Check Hive box is opened: `await Hive.openBox<int>(_favoritesBox)`

### UI Not Updating
**Issue**: Favorite icon doesn't change when tapped
**Solution**:
- Ensure widget uses `ConsumerWidget` or `Consumer`
- Verify `ref.watch(favoritesProvider)` is used
- Check provider is properly defined

### Icon Not Showing
**Issue**: Save icon not visible on ProductCard
**Solution**:
- Run `dart run build_runner build`
- Check `assets.gen.dart` contains icon reference
- Verify icon exists in `assets/icons/`

## Related Files

- `lib/features/favorites/presentation/providers/favorites_provider.dart`
- `lib/features/favorites/presentation/pages/favorites_page.dart`
- `lib/features/home/presentation/widgets/product_card.dart`
- `lib/features/product/presentation/pages/product_details_page.dart`
- `lib/data/services/storage_service.dart`
- `assets/icons/unselected_save_icon.svg`

## Command Reference

```bash
# Generate assets (if needed)
dart run build_runner build --delete-conflicting-outputs

# Clear storage (for testing)
# Delete app data through device settings or:
flutter clean
flutter pub get
```

## Summary

✅ **Implemented**:
- Save button on all product cards
- Favorites tab with full functionality
- Product details favorite button
- Hive persistence
- State management with Riverpod
- Empty states
- Clear all functionality

The favorites feature is now fully functional and integrated throughout the app! 🎉
