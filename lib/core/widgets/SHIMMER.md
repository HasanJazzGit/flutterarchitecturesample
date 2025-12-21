# AppShimmer Documentation

## Overview

`AppShimmer` is a highly customizable shimmer loading effect widget that provides full control over shape, layout, dimensions, colors, and animation. It's perfect for creating beautiful loading states that match your app's design.

## Features

- ✅ **Multiple Shapes**: Rectangle, Rounded Rectangle, Circle
- ✅ **Multiple Layouts**: Single item, List (vertical/horizontal), Grid
- ✅ **Full Customization**: Width, height, colors, spacing, border radius
- ✅ **Theme Aware**: Automatically adapts to light/dark theme
- ✅ **Pre-built Widgets**: Ready-to-use components for common cases
- ✅ **Custom Builders**: Support for custom item builders

## Installation

The shimmer package is already included in `pubspec.yaml`:

```yaml
dependencies:
  shimmer: ^3.0.0
```

## Architecture

```
app_shimmer.dart
├── AppShimmer (Main customizable widget)
├── AppShimmerCard (Pre-built card shimmer)
├── AppShimmerList (Pre-built list shimmer)
├── AppShimmerGrid (Pre-built grid shimmer)
├── AppShimmerCircle (Pre-built circle shimmer)
└── AppShimmerText (Pre-built text shimmer)
```

## Enums

### ShimmerShape
```dart
enum ShimmerShape {
  rectangle,        // Square/rectangular shape
  roundedRectangle, // Rounded corners (default)
  circle,           // Perfect circle
}
```

### ShimmerLayout
```dart
enum ShimmerLayout {
  single,  // Single shimmer item
  list,    // List of shimmer items
  grid,    // Grid of shimmer items
}
```

### ShimmerDirection
```dart
enum ShimmerDirection {
  vertical,   // Vertical list (default)
  horizontal, // Horizontal list
}
```

## Main Widget: AppShimmer

### Basic Usage

```dart
import 'package:fluttersampleachitecture/core/widgets/app_shimmer.dart';

// Simple shimmer card
AppShimmer(
  width: 200,
  height: 100,
  borderRadius: 12,
)
```

### Parameters

#### Dimensions
- `width` (double?) - Width of shimmer item
- `height` (double?) - Height of shimmer item
- `borderRadius` (double) - Border radius for rounded rectangles (default: 8.0)

#### Shape & Layout
- `shape` (ShimmerShape) - Shape type (default: `roundedRectangle`)
- `layout` (ShimmerLayout) - Layout type (default: `single`)
- `itemCount` (int) - Number of items for list/grid (default: 3)

#### Direction & Spacing
- `direction` (ShimmerDirection) - List direction (default: `vertical`)
- `spacing` (double) - Spacing between list items (default: 8.0)
- `crossAxisSpacing` (double) - Grid cross-axis spacing (default: 8.0)
- `mainAxisSpacing` (double) - Grid main-axis spacing (default: 8.0)

#### Grid Specific
- `crossAxisCount` (int) - Number of columns (default: 2)
- `childAspectRatio` (double?) - Aspect ratio for grid items

#### Colors & Animation
- `baseColor` (Color?) - Base color (auto-detected from theme if null)
- `highlightColor` (Color?) - Highlight color (auto-detected from theme if null)
- `period` (Duration) - Animation duration (default: 1500ms)
- `enabled` (bool) - Enable/disable shimmer effect (default: true)

#### Customization
- `child` (Widget?) - Custom widget to wrap with shimmer
- `padding` (EdgeInsetsGeometry?) - Padding around shimmer
- `margin` (EdgeInsetsGeometry?) - Margin around shimmer
- `itemBuilder` (Function?) - Custom builder for list/grid items

## Pre-built Widgets

### 1. AppShimmerCard

Perfect for card-like loading states.

```dart
AppShimmerCard(
  width: double.infinity,
  height: 200,
  borderRadius: 16,
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
)
```

**Parameters:**
- `width` (double?) - Card width
- `height` (double?) - Card height
- `borderRadius` (double) - Corner radius (default: 12.0)
- `padding` (EdgeInsetsGeometry?) - Internal padding
- `margin` (EdgeInsetsGeometry?) - External margin

### 2. AppShimmerList

Perfect for list loading states.

```dart
AppShimmerList(
  itemCount: 5,
  itemHeight: 80,
  itemWidth: double.infinity,
  borderRadius: 8,
  spacing: 12,
  direction: ShimmerDirection.vertical,
)
```

**Parameters:**
- `itemCount` (int) - Number of items (default: 5)
- `itemHeight` (double?) - Height of each item
- `itemWidth` (double?) - Width of each item
- `borderRadius` (double) - Corner radius (default: 8.0)
- `spacing` (double) - Space between items (default: 12.0)
- `direction` (ShimmerDirection) - Vertical or horizontal (default: vertical)
- `padding` (EdgeInsetsGeometry?) - Internal padding
- `margin` (EdgeInsetsGeometry?) - External margin

### 3. AppShimmerGrid

Perfect for grid loading states.

```dart
AppShimmerGrid(
  itemCount: 6,
  crossAxisCount: 2,
  itemHeight: 150,
  borderRadius: 12,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 0.8,
)
```

**Parameters:**
- `itemCount` (int) - Number of items (default: 6)
- `crossAxisCount` (int) - Number of columns (default: 2)
- `itemHeight` (double?) - Height of each item
- `itemWidth` (double?) - Width of each item
- `borderRadius` (double) - Corner radius (default: 8.0)
- `crossAxisSpacing` (double) - Horizontal spacing (default: 12.0)
- `mainAxisSpacing` (double) - Vertical spacing (default: 12.0)
- `childAspectRatio` (double?) - Width/height ratio
- `padding` (EdgeInsetsGeometry?) - Internal padding
- `margin` (EdgeInsetsGeometry?) - External margin

### 4. AppShimmerCircle

Perfect for avatar/profile picture loading.

```dart
AppShimmerCircle(
  diameter: 60,
  padding: EdgeInsets.all(8),
)
```

**Parameters:**
- `diameter` (double?) - Circle diameter
- `padding` (EdgeInsetsGeometry?) - Internal padding
- `margin` (EdgeInsetsGeometry?) - External margin

### 5. AppShimmerText

Perfect for text line loading.

```dart
AppShimmerText(
  width: 200,
  height: 16,
  borderRadius: 4,
)
```

**Parameters:**
- `width` (double?) - Text width
- `height` (double) - Text height (default: 16.0)
- `borderRadius` (double) - Corner radius (default: 4.0)
- `padding` (EdgeInsetsGeometry?) - Internal padding
- `margin` (EdgeInsetsGeometry?) - External margin

## Usage Examples

### Example 1: Simple Card Shimmer

```dart
AppShimmer(
  width: double.infinity,
  height: 200,
  borderRadius: 12,
  shape: ShimmerShape.roundedRectangle,
)
```

### Example 2: Circle Avatar

```dart
AppShimmer(
  width: 60,
  height: 60,
  shape: ShimmerShape.circle,
)
```

### Example 3: Vertical List

```dart
AppShimmer(
  width: double.infinity,
  height: 80,
  layout: ShimmerLayout.list,
  itemCount: 5,
  direction: ShimmerDirection.vertical,
  spacing: 12,
)
```

### Example 4: Horizontal List

```dart
AppShimmer(
  width: 120,
  height: 120,
  layout: ShimmerLayout.list,
  itemCount: 5,
  direction: ShimmerDirection.horizontal,
  spacing: 16,
)
```

### Example 5: Grid Layout

```dart
AppShimmer(
  width: double.infinity,
  height: 150,
  layout: ShimmerLayout.grid,
  itemCount: 6,
  crossAxisCount: 2,
  crossAxisSpacing: 16,
  mainAxisSpacing: 16,
  childAspectRatio: 0.8,
)
```

### Example 6: Custom Colors

```dart
AppShimmer(
  width: 200,
  height: 100,
  baseColor: Colors.blue[100],
  highlightColor: Colors.blue[50],
  period: Duration(milliseconds: 2000),
)
```

### Example 7: Custom Child Widget

```dart
AppShimmer(
  child: Container(
    width: 200,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### Example 8: Custom Item Builder

```dart
AppShimmer(
  layout: ShimmerLayout.list,
  itemCount: 3,
  itemBuilder: (context, index) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          AppShimmerCircle(diameter: 50),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppShimmerText(width: double.infinity, height: 16),
                SizedBox(height: 8),
                AppShimmerText(width: 150, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
```

### Example 9: Real-World Card Loading

```dart
// Loading state for a product card
AppShimmer(
  width: double.infinity,
  height: 300,
  borderRadius: 16,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image placeholder
      AppShimmer(
        width: double.infinity,
        height: 200,
        borderRadius: 0,
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            AppShimmerText(width: double.infinity, height: 20),
            SizedBox(height: 8),
            // Subtitle
            AppShimmerText(width: 150, height: 16),
            SizedBox(height: 12),
            // Price
            AppShimmerText(width: 100, height: 18),
          ],
        ),
      ),
    ],
  ),
)
```

### Example 10: List Item with Avatar

```dart
AppShimmer(
  layout: ShimmerLayout.list,
  itemCount: 5,
  itemBuilder: (context, index) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          AppShimmerCircle(diameter: 50),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmerText(width: double.infinity, height: 16),
                SizedBox(height: 8),
                AppShimmerText(width: 200, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  },
)
```

## Theme Support

`AppShimmer` automatically adapts to your app's theme:

- **Light Theme**: Uses `Colors.grey[300]` (base) and `Colors.grey[100]` (highlight)
- **Dark Theme**: Uses `Colors.grey[800]` (base) and `Colors.grey[700]` (highlight)

You can override these colors:

```dart
AppShimmer(
  baseColor: Colors.blue[200],
  highlightColor: Colors.blue[50],
)
```

## Best Practices

### 1. Match Actual Content Size

✅ **Good:**
```dart
// Shimmer matches actual card size
AppShimmerCard(
  width: double.infinity,
  height: 200, // Matches actual card height
)
```

❌ **Bad:**
```dart
// Shimmer doesn't match content
AppShimmerCard(
  width: 100,
  height: 50, // Too small for actual content
)
```

### 2. Use Pre-built Widgets When Possible

✅ **Good:**
```dart
AppShimmerCard(width: 200, height: 100)
AppShimmerList(itemCount: 5)
AppShimmerCircle(diameter: 60)
```

❌ **Bad:**
```dart
// Overly complex for simple use case
AppShimmer(
  width: 200,
  height: 100,
  shape: ShimmerShape.roundedRectangle,
  layout: ShimmerLayout.single,
  borderRadius: 12,
)
```

### 3. Consistent Spacing

✅ **Good:**
```dart
AppShimmerList(
  spacing: 16, // Consistent with app spacing
  itemCount: 5,
)
```

### 4. Appropriate Item Count

✅ **Good:**
```dart
// Show 3-5 items (enough to show pattern, not overwhelming)
AppShimmerList(itemCount: 5)
```

❌ **Bad:**
```dart
// Too many items
AppShimmerList(itemCount: 20)
```

### 5. Disable When Not Needed

```dart
AppShimmer(
  enabled: isLoading, // Disable when data is loaded
  child: isLoading ? null : ActualContent(),
)
```

## Common Patterns

### Pattern 1: Full Screen List Loading

```dart
class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppShimmerList(
      itemCount: 10,
      itemHeight: 100,
      itemWidth: double.infinity,
      spacing: 12,
      padding: EdgeInsets.all(16),
    );
  }
}
```

### Pattern 2: Grid Loading

```dart
class GridLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppShimmerGrid(
      itemCount: 6,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.75,
    );
  }
}
```

### Pattern 3: Profile Loading

```dart
class ProfileLoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppShimmerCircle(diameter: 100),
        SizedBox(height: 16),
        AppShimmerText(width: 200, height: 20),
        SizedBox(height: 8),
        AppShimmerText(width: 150, height: 16),
      ],
    );
  }
}
```

### Pattern 4: Card with Multiple Elements

```dart
AppShimmer(
  width: double.infinity,
  height: 250,
  borderRadius: 16,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer(width: double.infinity, height: 150),
        SizedBox(height: 12),
        AppShimmerText(width: double.infinity, height: 18),
        SizedBox(height: 8),
        AppShimmerText(width: 200, height: 14),
        SizedBox(height: 12),
        Row(
          children: [
            AppShimmerCircle(diameter: 30),
            SizedBox(width: 8),
            AppShimmerText(width: 100, height: 14),
          ],
        ),
      ],
    ),
  ),
)
```

## Performance Considerations

1. **Limit Item Count**: Don't show too many shimmer items (3-10 is usually enough)
2. **Use ShrinkWrap**: Grid uses `shrinkWrap: true` to prevent layout issues
3. **Disable When Not Needed**: Set `enabled: false` when data is loaded
4. **Avoid Nested Shimmers**: Don't nest shimmer widgets unnecessarily

## Troubleshooting

### Issue: Shimmer not showing

**Solution:**
- Check if `enabled` is `true`
- Verify `width` and `height` are set
- Ensure widget is visible (not hidden by parent)

### Issue: Colors not visible

**Solution:**
- Check theme brightness
- Override `baseColor` and `highlightColor` explicitly
- Ensure sufficient contrast

### Issue: Grid not displaying correctly

**Solution:**
- Set `childAspectRatio` appropriately
- Check `crossAxisCount` value
- Verify `itemCount` is sufficient

### Issue: List items overlapping

**Solution:**
- Increase `spacing` value
- Check `itemHeight` is set
- Verify `direction` is correct

## See Also

- **Examples Page**: `lib/features/examples/presentation/pages/shimmer_examples_page.dart`
- **Main Widget**: `lib/core/widgets/app_shimmer.dart`
- **Shimmer Package**: [shimmer package on pub.dev](https://pub.dev/packages/shimmer)

## Summary

`AppShimmer` provides a powerful, flexible solution for creating beautiful loading states. With pre-built widgets for common cases and full customization options, you can create shimmer effects that perfectly match your app's design.

**Key Takeaways:**
- Use pre-built widgets (`AppShimmerCard`, `AppShimmerList`, etc.) for common cases
- Customize colors, spacing, and dimensions to match your design
- Theme-aware by default, but can be overridden
- Support for custom builders for complex layouts
- Performance-optimized with proper item counts and shrinkWrap
