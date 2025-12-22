# AppImageWidget - Usage Guide

A powerful, flexible image widget that supports multiple image sources, caching, SVG detection, error handling, and customizable placeholders.

## Features

- ✅ **Multiple Image Sources**: Network URLs, Assets, SVG, File paths, Icons, Base64, and Memory images
- ✅ **Automatic Type Detection**: Automatically detects image type from path
- ✅ **Caching**: Built-in caching for network images using `CachedNetworkImage`
- ✅ **SVG Support**: Full support for SVG images (network and local)
- ✅ **Error Handling**: Customizable error widgets with fallback
- ✅ **Loading Placeholders**: Shimmer effect or custom placeholders
- ✅ **Icon Support**: Display Material Icons with customizable size and color
- ✅ **Styling Options**: Border radius, circular shape, shadows, background color
- ✅ **Advanced Options**: Alignment, repeat, filter quality, anti-aliasing
- ✅ **Full Screen View**: Tap to view image in full screen (dialog or route)
- ✅ **Hero Animations**: Smooth transitions with hero animations
- ✅ **Gesture Support**: Tap and long press callbacks
- ✅ **Memory Optimization**: Cache dimensions for reduced memory usage

## Basic Usage

### Import

```dart
import 'package:app/common/app_image_widget.dart';
```

### Network Image (with caching)

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 200,
  height: 200,
  useCache: true, // Default: true
)
```

### Asset Image

```dart
AppImageWidget(
  imagePath: "assets/images/logo.png",
  width: 150,
  height: 150,
)
```

### SVG Image

```dart
// Network SVG
AppImageWidget(
  imagePath: "https://example.com/icon.svg",
  width: 100,
  height: 100,
)

// Asset SVG
AppImageWidget(
  imagePath: "assets/icons/icon.svg",
  width: 100,
  height: 100,
)
```

### Icon

```dart
AppImageWidget(
  icon: Icons.home,
  iconColor: Colors.blue,
  iconSize: 48,
  width: 60,
  height: 60,
)
```

### File Image

```dart
AppImageWidget(
  imagePath: "/storage/emulated/0/Pictures/image.jpg",
  width: 200,
  height: 200,
)
```

## Styling Options

### Rounded Corners

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  borderRadius: 12,
  width: 200,
  height: 200,
)
```

### Circular Image

```dart
AppImageWidget(
  imagePath: "https://example.com/avatar.jpg",
  isCircular: true,
  width: 100,
  height: 100,
)
```

### With Shadow

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 200,
  height: 200,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ],
)
```

### With Background Color

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 200,
  height: 200,
  backgroundColor: Colors.grey[200],
)
```

## Loading & Error Handling

### Custom Placeholder

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  placeholder: CircularProgressIndicator(),
  showShimmer: false, // Disable shimmer
)
```

### Custom Error Widget

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  errorWidget: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error, size: 48),
      Text("Failed to load image"),
    ],
  ),
)
```

### Shimmer Loading Effect

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  showShimmer: true, // Default: true
  placeholderColor: Colors.grey[300], // Custom shimmer color
)
```

## Full Screen View

### Enable Full Screen on Tap

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  enableFullScreenOnTap: true, // Enable full screen view
  showAsDialog: true, // Show as dialog (default) or full screen route
  showCloseButton: true, // Show close button
  fullScreenBackgroundColor: Colors.black87, // Background color
)
```

### Full Screen as Dialog

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  enableFullScreenOnTap: true,
  showAsDialog: true, // Shows as modal dialog
  heroTag: "image-123", // Optional: for hero animation
)
```

### Full Screen as Route

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  enableFullScreenOnTap: true,
  showAsDialog: false, // Shows as full screen route
  heroTag: "image-123", // Optional: for hero animation
)
```

### With Custom Background

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  enableFullScreenOnTap: true,
  fullScreenBackgroundColor: Colors.black,
  showCloseButton: true,
)
```

## Advanced Options

### BoxFit Options

```dart
// BoxFit.cover - Fills container, maintains aspect ratio, may crop
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  fit: BoxFit.cover, // Best for cover images
  width: 200,
  height: 200,
  borderRadius: 8,
)

// BoxFit.contain - Fits entire image, may leave empty space
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  fit: BoxFit.contain,
  width: 200,
  height: 200,
)

// BoxFit.fill - Stretches to fill, may distort
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  fit: BoxFit.fill,
  width: 200,
  height: 200,
)
```

### Cover Image Examples

#### Basic Cover Image

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 300,
  height: 200,
  fit: BoxFit.cover, // Image covers entire area
  borderRadius: 8,
)
```

#### Cover Image with Aspect Ratio

```dart
AspectRatio(
  aspectRatio: 16 / 9, // Maintain aspect ratio
  child: AppImageWidget(
    imagePath: "https://example.com/image.jpg",
    fit: BoxFit.cover, // Fills aspect ratio container
    borderRadius: 12,
  ),
)
```

#### Cover Image in List Item

```dart
ListTile(
  leading: AppImageWidget(
    imagePath: item.imageUrl,
    width: 60,
    height: 60,
    fit: BoxFit.cover,
    borderRadius: 8,
    isCircular: false,
  ),
  title: Text(item.title),
)
```

#### Hero Cover Image

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: double.infinity,
  height: 300,
  fit: BoxFit.cover,
  borderRadius: 0,
  heroTag: "hero-image-123",
  enableFullScreenOnTap: true,
)
```

### Alignment

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  alignment: Alignment.topLeft,
  width: 200,
  height: 200,
)
```

### Image Repeat

```dart
AppImageWidget(
  imagePath: "assets/pattern.png",
  repeat: ImageRepeat.repeat,
  width: 200,
  height: 200,
)
```

### Filter Quality

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  filterQuality: FilterQuality.high, // low, medium, high
  width: 200,
  height: 200,
)
```

### Disable Caching

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  useCache: false, // Don't cache network images
  width: 200,
  height: 200,
)
```

### Fade In Duration

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  fadeInDuration: Duration(milliseconds: 500),
  width: 200,
  height: 200,
)
```

## Complete Example

```dart
AppImageWidget(
  // Image source (choose one)
  imagePath: "https://example.com/image.jpg",
  // icon: Icons.home, // Alternative: use icon instead
  
  // Size
  width: 200,
  height: 200,
  
  // Styling
  borderRadius: 12,
  isCircular: false,
  backgroundColor: Colors.grey[100],
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ],
  
  // Image options
  fit: BoxFit.cover,
  alignment: Alignment.center,
  filterQuality: FilterQuality.medium,
  isAntiAlias: true,
  
  // Caching
  useCache: true,
  fadeInDuration: Duration(milliseconds: 300),
  
  // Loading & Error
  showShimmer: true,
  placeholderColor: Colors.grey[300],
  placeholder: null, // Custom placeholder widget
  errorWidget: null, // Custom error widget
  errorIconColor: Colors.red,
)
```

## Use Cases

### Profile Avatar

```dart
AppImageWidget(
  imagePath: user.avatarUrl ?? "assets/default_avatar.png",
  isCircular: true,
  width: 80,
  height: 80,
  errorWidget: Icon(Icons.person, size: 40),
)
```

### Product Image (Cover)

```dart
AppImageWidget(
  imagePath: product.imageUrl,
  width: double.infinity,
  height: 300,
  fit: BoxFit.cover, // Image covers entire area, may crop
  borderRadius: 8,
  showShimmer: true,
)
```

### Cover Image with Border Radius

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 200,
  height: 200,
  fit: BoxFit.cover, // Fills entire container, maintains aspect ratio
  borderRadius: 12, // Rounded corners
  backgroundColor: Colors.grey[200], // Background visible if image doesn't fill
)
```

### Full Width Cover Image

```dart
AppImageWidget(
  imagePath: banner.imageUrl,
  width: double.infinity,
  height: 200,
  fit: BoxFit.cover, // Covers entire width and height
  borderRadius: 0, // No rounded corners for full width
)
```

### Cover Image in Card

```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: AppImageWidget(
      imagePath: "https://example.com/image.jpg",
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover, // Image covers card area
    ),
  ),
)
```

### Icon Button

```dart
AppImageWidget(
  icon: Icons.settings,
  iconColor: Colors.blue,
  iconSize: 24,
  width: 48,
  height: 48,
  isCircular: true,
  backgroundColor: Colors.blue[50],
)
```

### Network Image with Error Handling

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 200,
  height: 200,
  useCache: true,
  errorWidget: Container(
    color: Colors.grey[200],
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.broken_image, size: 48, color: Colors.grey),
        SizedBox(height: 8),
        Text("Image not available", style: TextStyle(color: Colors.grey)),
      ],
    ),
  ),
)
```

### SVG Logo

```dart
AppImageWidget(
  imagePath: "assets/logo.svg",
  width: 150,
  height: 50,
  fit: BoxFit.contain,
)
```

### Full Screen Image Viewer

```dart
AppImageWidget(
  imagePath: "https://example.com/image.jpg",
  width: 200,
  height: 200,
  enableFullScreenOnTap: true, // Enable tap to view full screen
  showAsDialog: true, // Show as dialog (or false for full screen route)
  heroTag: "product-image-123", // Optional: for smooth transition
  showCloseButton: true,
  fullScreenBackgroundColor: Colors.black87,
)
```

## Parameters Reference

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `imagePath` | `String?` | `null` | Image source path (URL, asset, file, or SVG) |
| `icon` | `IconData?` | `null` | Icon to display (alternative to imagePath) |
| `iconColor` | `Color?` | `null` | Color of the icon |
| `iconSize` | `double?` | `null` | Size of the icon |
| `width` | `double?` | `null` | Width of the image |
| `height` | `double?` | `null` | Height of the image |
| `fit` | `BoxFit` | `BoxFit.cover` | How the image should be fitted |
| `useCache` | `bool` | `true` | Whether to cache network images |
| `borderRadius` | `double` | `0` | Border radius for rounded corners |
| `isCircular` | `bool` | `false` | Whether to make the image circular |
| `backgroundColor` | `Color?` | `null` | Background color of the container |
| `boxShadow` | `List<BoxShadow>?` | `null` | Box shadow for elevation |
| `placeholder` | `Widget?` | `null` | Custom placeholder widget |
| `errorWidget` | `Widget?` | `null` | Custom error widget |
| `showShimmer` | `bool` | `true` | Whether to show shimmer loading effect |
| `placeholderColor` | `Color?` | `null` | Color for shimmer placeholder |
| `errorIconColor` | `Color?` | `null` | Color for error icon |
| `fadeInDuration` | `Duration` | `300ms` | Fade in duration for network images |
| `alignment` | `AlignmentGeometry?` | `Alignment.center` | Alignment of the image |
| `repeat` | `ImageRepeat` | `ImageRepeat.noRepeat` | How to repeat the image |
| `filterQuality` | `FilterQuality` | `FilterQuality.low` | Quality of image filtering |
| `isAntiAlias` | `bool` | `true` | Whether to enable anti-aliasing |
| `opacity` | `double` | `1.0` | Opacity of the image (0.0 to 1.0) |
| `colorFilter` | `ColorFilter?` | `null` | Color filter to apply to the image |
| `heroTag` | `String?` | `null` | Hero animation tag |
| `onTap` | `VoidCallback?` | `null` | Callback when image is tapped |
| `onLongPress` | `VoidCallback?` | `null` | Callback when image is long pressed |
| `semanticLabel` | `String?` | `null` | Semantic label for accessibility |
| `maxWidth` | `int?` | `null` | Maximum width for image resizing (network images) |
| `maxHeight` | `int?` | `null` | Maximum height for image resizing (network images) |
| `cacheWidth` | `int?` | `null` | Cache width for network images (for memory optimization) |
| `cacheHeight` | `int?` | `null` | Cache height for network images (for memory optimization) |
| `enableFullScreenOnTap` | `bool` | `false` | Whether to show full screen view on tap |
| `showAsDialog` | `bool` | `true` | Whether to show as dialog (true) or full screen route (false) |
| `fullScreenBackgroundColor` | `Color?` | `null` | Background color for full screen viewer |
| `showCloseButton` | `bool` | `true` | Whether to show close button in full screen view |
| `memoryImage` | `Uint8List?` | `null` | Memory image data (alternative to imagePath) |

## Notes

- Either `imagePath`, `icon`, or `memoryImage` must be provided
- Network images are automatically cached when `useCache` is `true`
- SVG images are automatically detected by `.svg` extension
- File paths must start with `/` to be recognized as file images
- Network URLs must start with `http://` or `https://`
- Base64 images are automatically detected (supports data URI format)
- All other paths are treated as asset images
- Circular images automatically calculate radius from width/height
- Error widgets are shown when image fails to load
- Placeholders are shown during image loading
- Full screen view works with all image types (network, asset, file, base64, memory)
- When `enableFullScreenOnTap` is true, `onTap` callback is overridden
- Full screen dialog can be dismissed by tapping outside or using close button

## Best Practices

1. **Always provide dimensions** for better performance and layout
2. **Use caching** for network images that don't change frequently
3. **Provide error widgets** for better user experience
4. **Use shimmer** for better loading UX
5. **Set appropriate BoxFit** based on your design needs
6. **Use circular images** for avatars and profile pictures
7. **Provide fallback images** in errorWidget for network images

