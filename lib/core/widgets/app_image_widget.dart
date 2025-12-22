import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Advanced image widget that supports:
/// - Network images (with caching)
/// - Asset images
/// - SVG images (network and local)
/// - Icons (IconData)
/// - File images
/// - Base64 images
/// - Memory images (Uint8List)
/// - Automatic type detection
/// - Custom placeholders and error widgets
/// - Shimmer loading effect
/// - Gesture support (tap, long press)
/// - Hero animations
/// - Image compression/resizing
class AppImageWidget extends StatelessWidget {
  /// Image source - can be:
  /// - Network URL: "https://example.com/image.png"
  /// - Asset path: "assets/images/logo.png"
  /// - SVG: "assets/icons/icon.svg" or "https://example.com/icon.svg"
  /// - File path: "/path/to/file.jpg"
  /// - Base64: "data:image/png;base64,..." or just base64 string
  /// - Memory: Use memoryImage parameter instead
  final String? imagePath;

  /// Icon data to display (alternative to imagePath)
  final IconData? icon;

  /// Memory image data (Uint8List) - alternative to imagePath
  final Uint8List? memoryImage;

  /// Icon color (only used when icon is provided)
  final Color? iconColor;

  /// Icon size (only used when icon is provided)
  final double? iconSize;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// How the image should be fitted
  final BoxFit fit;

  /// Whether to use cache for network images
  final bool useCache;

  /// Border radius for rounded corners
  final double borderRadius;

  /// Whether to make the image circular
  final bool isCircular;

  /// Background color
  final Color? backgroundColor;

  /// Box shadow
  final List<BoxShadow>? boxShadow;

  /// Custom placeholder widget
  final Widget? placeholder;

  /// Custom error widget
  final Widget? errorWidget;

  /// Whether to show shimmer effect during loading
  final bool showShimmer;

  /// Placeholder color for shimmer
  final Color? placeholderColor;

  /// Error icon color
  final Color? errorIconColor;

  /// Fade in duration for network images
  final Duration fadeInDuration;

  /// Whether to match text direction for RTL
  final bool matchTextDirection;

  /// Alignment for the image
  final AlignmentGeometry? alignment;

  /// Repeat mode for the image
  final ImageRepeat repeat;

  /// Filter quality
  final FilterQuality filterQuality;

  /// Whether to enable anti-aliasing
  final bool isAntiAlias;

  /// Opacity of the image (0.0 to 1.0)
  final double opacity;

  /// Color filter to apply to the image
  final ColorFilter? colorFilter;

  /// Hero animation tag
  final String? heroTag;

  /// Callback when image is tapped
  final VoidCallback? onTap;

  /// Callback when image is long pressed
  final VoidCallback? onLongPress;

  /// Whether to show full screen view on tap
  final bool enableFullScreenOnTap;

  /// Whether to show as dialog (true) or full screen route (false)
  final bool showAsDialog;

  /// Background color for full screen viewer
  final Color? fullScreenBackgroundColor;

  /// Whether to show close button in full screen view
  final bool showCloseButton;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Whether to exclude from semantics
  final bool excludeFromSemantics;

  /// Maximum width for image resizing (network images only)
  final int? maxWidth;

  /// Maximum height for image resizing (network images only)
  final int? maxHeight;

  /// Whether to retry loading on error
  final bool retryOnError;

  /// Maximum retry attempts
  final int maxRetries;

  /// Cache width for network images (for memory optimization)
  final int? cacheWidth;

  /// Cache height for network images (for memory optimization)
  final int? cacheHeight;

  const AppImageWidget({
    super.key,
    this.imagePath,
    this.icon,
    this.memoryImage,
    this.iconColor,
    this.iconSize,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.useCache = true,
    this.borderRadius = 0,
    this.isCircular = false,
    this.backgroundColor,
    this.boxShadow,
    this.placeholder,
    this.errorWidget,
    this.showShimmer = true,
    this.placeholderColor,
    this.errorIconColor,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.matchTextDirection = false,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = true,
    this.opacity = 1.0,
    this.colorFilter,
    this.heroTag,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.maxWidth,
    this.maxHeight,
    this.retryOnError = false,
    this.maxRetries = 3,
    this.cacheWidth,
    this.cacheHeight,
    this.enableFullScreenOnTap = false,
    this.showAsDialog = true,
    this.fullScreenBackgroundColor,
    this.showCloseButton = true,
  }) : assert(
         imagePath != null || icon != null || memoryImage != null,
         'Either imagePath, icon, or memoryImage must be provided',
       ),
       assert(
         opacity >= 0.0 && opacity <= 1.0,
         'Opacity must be between 0.0 and 1.0',
       );

  /// Check if the image path is an SVG
  bool get _isSvg =>
      imagePath != null && imagePath!.toLowerCase().endsWith('.svg');

  /// Check if the image path is a network URL
  bool get _isNetwork =>
      imagePath != null &&
      (imagePath!.startsWith('http://') || imagePath!.startsWith('https://'));

  /// Check if the image path is a base64 string
  bool get _isBase64 =>
      imagePath != null &&
      (imagePath!.startsWith('data:image') ||
          imagePath!.startsWith('base64,') ||
          (imagePath!.length > 100 &&
              RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(imagePath!)));

  /// Check if the image path is a file path
  bool get _isFile =>
      imagePath != null &&
      !_isNetwork &&
      !_isBase64 &&
      !_isAsset &&
      imagePath!.startsWith('/');

  /// Check if the image path is an asset
  bool get _isAsset =>
      imagePath != null && !_isNetwork && !_isFile && !_isBase64;

  /// Get effective alignment (memoized)
  Alignment get _effectiveAlignment {
    if (alignment is Alignment) {
      return alignment as Alignment;
    }
    return Alignment.center;
  }

  @override
  Widget build(BuildContext context) {
    final double effectiveRadius = isCircular
        ? (width ?? height ?? 40) / 2
        : borderRadius;

    // If icon is provided, display icon
    if (icon != null) {
      return _buildIconWidget(effectiveRadius);
    }

    // If memory image is provided
    if (memoryImage != null) {
      return _buildMemoryImage(effectiveRadius);
    }

    // If imagePath is empty or null, show error
    if (imagePath == null || imagePath!.isEmpty) {
      return _buildErrorWidget(effectiveRadius);
    }

    Widget imageWidget;

    try {
      if (_isBase64) {
        imageWidget = _buildBase64Image(effectiveRadius);
      } else if (_isSvg) {
        imageWidget = _buildSvgImage(effectiveRadius);
      } else if (_isFile) {
        imageWidget = _buildFileImage();
      } else if (_isNetwork) {
        imageWidget = _buildNetworkImage(effectiveRadius);
      } else {
        imageWidget = _buildAssetImage();
      }
    } catch (e) {
      imageWidget = _buildErrorWidget(effectiveRadius);
    }

    Widget wrappedWidget = _wrapWithContainer(
      child: Opacity(
        opacity: opacity,
        child: colorFilter != null
            ? ColorFiltered(colorFilter: colorFilter!, child: imageWidget)
            : imageWidget,
      ),
      radius: effectiveRadius,
    );

    // Add hero animation if tag is provided
    if (heroTag != null) {
      wrappedWidget = Hero(tag: heroTag!, child: wrappedWidget);
    }

    // Add gesture support
    if (onTap != null || onLongPress != null || enableFullScreenOnTap) {
      wrappedWidget = GestureDetector(
        onTap: enableFullScreenOnTap
            ? () => _showFullScreenView(context)
            : onTap,
        onLongPress: onLongPress,
        child: wrappedWidget,
      );
    }

    return wrappedWidget;
  }

  /// Build icon widget
  Widget _buildIconWidget(double radius) {
    return Builder(
      builder: (context) => _wrapWithContainer(
        child: Icon(
          icon,
          size: iconSize ?? (width ?? height ?? 24),
          color: iconColor ?? Theme.of(context).iconTheme.color,
          semanticLabel: semanticLabel,
        ),
        radius: radius,
      ),
    );
  }

  /// Build memory image widget
  Widget _buildMemoryImage(double radius) {
    return _wrapWithContainer(
      child: Image.memory(
        memoryImage!,
        width: width,
        height: height,
        fit: fit,
        alignment: _effectiveAlignment,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        filterQuality: filterQuality,
        isAntiAlias: isAntiAlias,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        errorBuilder: (_, __, ___) => _buildErrorWidget(radius),
      ),
      radius: radius,
    );
  }

  /// Build base64 image widget
  Widget _buildBase64Image(double radius) {
    try {
      String base64String = imagePath!;

      // Remove data URI prefix if present
      if (base64String.contains(',')) {
        base64String = base64String.split(',').last;
      }

      // Decode base64 string
      final bytes = base64Decode(base64String);

      return _wrapWithContainer(
        child: Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          alignment: _effectiveAlignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          filterQuality: filterQuality,
          isAntiAlias: isAntiAlias,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
          errorBuilder: (_, __, ___) => _buildErrorWidget(radius),
        ),
        radius: radius,
      );
    } catch (e) {
      return _buildErrorWidget(radius);
    }
  }

  /// Build SVG image widget
  Widget _buildSvgImage(double radius) {
    if (_isNetwork) {
      return SvgPicture.network(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        alignment: _effectiveAlignment,
        matchTextDirection: matchTextDirection,
        placeholderBuilder: (_) => _loadingPlaceholder(radius: radius),
        colorFilter: colorFilter,
        semanticsLabel: semanticLabel,
      );
    } else {
      return SvgPicture.asset(
        imagePath!,
        width: width,
        height: height,
        fit: fit,
        alignment: _effectiveAlignment,
        matchTextDirection: matchTextDirection,
        colorFilter: colorFilter,
        semanticsLabel: semanticLabel,
      );
    }
  }

  /// Build network image widget
  Widget _buildNetworkImage(double radius) {
    String imageUrl = imagePath!;

    // Add size parameters if maxWidth/maxHeight are specified
    if (maxWidth != null || maxHeight != null) {
      final uri = Uri.parse(imageUrl);
      final queryParams = Map<String, String>.from(uri.queryParameters);
      if (maxWidth != null) queryParams['w'] = maxWidth.toString();
      if (maxHeight != null) queryParams['h'] = maxHeight.toString();
      imageUrl = uri.replace(queryParameters: queryParams).toString();
    }

    if (useCache) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: _effectiveAlignment,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        fadeInDuration: fadeInDuration,
        filterQuality: filterQuality,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
        maxWidthDiskCache: maxWidth,
        maxHeightDiskCache: maxHeight,
        placeholder: (_, __) => _loadingPlaceholder(radius: radius),
        errorWidget: (_, __, ___) => _buildErrorWidget(radius),
      );
    } else {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        alignment: _effectiveAlignment,
        repeat: repeat,
        matchTextDirection: matchTextDirection,
        filterQuality: filterQuality,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        semanticLabel: semanticLabel,
        excludeFromSemantics: excludeFromSemantics,
        errorBuilder: (_, __, ___) => _buildErrorWidget(radius),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _loadingPlaceholder(radius: radius);
        },
      );
    }
  }

  /// Build file image widget
  Widget _buildFileImage() {
    return Image.file(
      File(imagePath!),
      width: width,
      height: height,
      fit: fit,
      alignment: _effectiveAlignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      errorBuilder: (_, __, ___) => _buildErrorWidget(0),
    );
  }

  /// Build asset image widget
  Widget _buildAssetImage() {
    return Image.asset(
      imagePath!,
      width: width,
      height: height,
      fit: fit,
      alignment: _effectiveAlignment,
      repeat: repeat,
      matchTextDirection: matchTextDirection,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      errorBuilder: (_, __, ___) => _buildErrorWidget(0),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget(double radius) {
    return errorWidget ??
        Icon(
          Icons.error_outline,
          color: errorIconColor ?? Colors.redAccent,
          size: width ?? height ?? 40,
          semanticLabel: semanticLabel ?? 'Image error',
        );
  }

  /// Loading shimmer or placeholder
  Widget _loadingPlaceholder({required double radius}) {
    if (!showShimmer) {
      return Container(
        width: width,
        height: height,
        alignment: alignment ?? Alignment.center,
        child:
            placeholder ??
            SizedBox(
              width: (width ?? 40) * 0.3,
              height: (height ?? 40) * 0.3,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  placeholderColor ?? Colors.grey.shade400,
                ),
              ),
            ),
      );
    }

    return Shimmer.fromColors(
      baseColor: placeholderColor ?? Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: placeholderColor ?? Colors.white,
          borderRadius: isCircular ? null : BorderRadius.circular(radius),
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  /// Wrap widget with container styling
  Widget _wrapWithContainer({required Widget child, required double radius}) {
    // Clip the child to ensure it fits within the border radius
    Widget clippedChild = child;

    if (isCircular) {
      clippedChild = ClipOval(
        child: SizedBox(width: width, height: height, child: child),
      );
    } else if (radius > 0) {
      clippedChild = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(width: width, height: height, child: child),
      );
    } else {
      // Even without border radius, ensure child respects container size
      clippedChild = SizedBox(width: width, height: height, child: child);
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(radius),
        boxShadow: boxShadow,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: alignment,
      child: clippedChild,
    );
  }

  /// Show full screen image viewer
  void _showFullScreenView(BuildContext context) {
    if (showAsDialog) {
      showDialog(
        context: context,
        barrierColor: fullScreenBackgroundColor ?? Colors.black87,
        barrierDismissible: true,
        builder: (context) => _FullScreenImageViewer(
          imagePath: imagePath,
          memoryImage: memoryImage,
          icon: icon,
          heroTag: heroTag,
          showCloseButton: showCloseButton,
          backgroundColor: fullScreenBackgroundColor,
          isDialog: true,
        ),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => _FullScreenImageViewer(
            imagePath: imagePath,
            memoryImage: memoryImage,
            icon: icon,
            heroTag: heroTag,
            showCloseButton: showCloseButton,
            backgroundColor: fullScreenBackgroundColor,
            isDialog: false,
          ),
        ),
      );
    }
  }
}

/// Full screen image viewer widget
class _FullScreenImageViewer extends StatelessWidget {
  final String? imagePath;
  final Uint8List? memoryImage;
  final IconData? icon;
  final String? heroTag;
  final bool showCloseButton;
  final Color? backgroundColor;
  final bool isDialog;

  const _FullScreenImageViewer({
    this.imagePath,
    this.memoryImage,
    this.icon,
    this.heroTag,
    this.showCloseButton = true,
    this.backgroundColor,
    required this.isDialog,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.black87;

    Widget imageWidget = AppImageWidget(
      imagePath: imagePath,
      memoryImage: memoryImage,
      icon: icon,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      heroTag: heroTag,
      enableFullScreenOnTap: false, // Disable nested full screen
    );

    final closeButton = showCloseButton
        ? Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: isDialog ? 16 : null,
            left: isDialog ? null : 16,
            child: SafeArea(
              child: IconButton(
                icon: Icon(
                  isDialog ? Icons.close : Icons.arrow_back,
                  color: Colors.white,
                  size: 32,
                ),
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black26,
                  shape: const CircleBorder(),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();

    if (isDialog) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: bgColor,
            child: Stack(
              children: [
                // Full screen image
                Center(
                  child: GestureDetector(
                    onTap: () {}, // Prevent closing when tapping image
                    child: imageWidget,
                  ),
                ),
                // Close button
                closeButton,
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: bgColor,
        extendBodyBehindAppBar: true,
        appBar: showCloseButton
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : null,
        body: Center(child: imageWidget),
      );
    }
  }
}
