import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Enum for shimmer shape types
enum ShimmerShape { rectangle, roundedRectangle, circle }

/// Enum for shimmer layout types
enum ShimmerLayout { single, list, grid }

/// Enum for shimmer direction
enum ShimmerDirection { vertical, horizontal }

/// A highly customizable shimmer widget with full control over appearance and layout
class AppShimmer extends StatelessWidget {
  /// Width of the shimmer item
  final double? width;

  /// Height of the shimmer item
  final double? height;

  /// Border radius for rounded rectangles (ignored for circle shape)
  final double borderRadius;

  /// Shape of the shimmer item
  final ShimmerShape shape;

  /// Layout type: single item, list, or grid
  final ShimmerLayout layout;

  /// Number of items to show (for list and grid layouts)
  final int itemCount;

  /// Direction for list layout (vertical or horizontal)
  final ShimmerDirection direction;

  /// Spacing between items (for list and grid layouts)
  final double spacing;

  /// Cross axis spacing for grid layout
  final double crossAxisSpacing;

  /// Main axis spacing for grid layout
  final double mainAxisSpacing;

  /// Number of columns for grid layout
  final int crossAxisCount;

  /// Aspect ratio for grid items
  final double? childAspectRatio;

  /// Base color for shimmer effect
  final Color? baseColor;

  /// Highlight color for shimmer effect
  final Color? highlightColor;

  /// Duration of the shimmer animation
  final Duration period;

  /// Custom child widget (if provided, will be wrapped with shimmer)
  final Widget? child;

  /// Padding around the shimmer
  final EdgeInsetsGeometry? padding;

  /// Margin around the shimmer
  final EdgeInsetsGeometry? margin;

  /// Whether to show shimmer effect
  final bool enabled;

  /// Custom builder for each shimmer item (for list and grid layouts)
  final Widget Function(BuildContext context, int index)? itemBuilder;

  const AppShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.shape = ShimmerShape.roundedRectangle,
    this.layout = ShimmerLayout.single,
    this.itemCount = 3,
    this.direction = ShimmerDirection.vertical,
    this.spacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.crossAxisCount = 2,
    this.childAspectRatio,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.child,
    this.padding,
    this.margin,
    this.enabled = true,
    this.itemBuilder,
  }) : assert(itemCount > 0, 'Item count must be greater than 0'),
       assert(crossAxisCount > 0, 'Cross axis count must be greater than 0');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBaseColor =
        baseColor ??
        (theme.brightness == Brightness.dark
            ? Colors.grey[800]!
            : Colors.grey[300]!);
    final effectiveHighlightColor =
        highlightColor ??
        (theme.brightness == Brightness.dark
            ? Colors.grey[700]!
            : Colors.grey[100]!);

    final shimmerWidget = Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      period: period,
      enabled: enabled,
      child: _buildShimmerContent(context),
    );

    if (margin != null) {
      return Container(margin: margin, child: shimmerWidget);
    }

    return shimmerWidget;
  }

  Widget _buildShimmerContent(BuildContext context) {
    if (child != null) {
      return Padding(padding: padding ?? EdgeInsets.zero, child: child!);
    }

    switch (layout) {
      case ShimmerLayout.single:
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: _buildSingleShimmer(),
        );
      case ShimmerLayout.list:
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: _buildListShimmer(),
        );
      case ShimmerLayout.grid:
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: _buildGridShimmer(),
        );
    }
  }

  Widget _buildSingleShimmer() {
    return _buildShimmerItem();
  }

  Widget _buildListShimmer() {
    if (itemBuilder != null) {
      return Builder(
        builder: (context) {
          return direction == ShimmerDirection.vertical
              ? Column(
                  children: List.generate(
                    itemCount,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index < itemCount - 1 ? spacing : 0,
                      ),
                      child: itemBuilder!(context, index),
                    ),
                  ),
                )
              : Row(
                  children: List.generate(
                    itemCount,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        right: index < itemCount - 1 ? spacing : 0,
                      ),
                      child: itemBuilder!(context, index),
                    ),
                  ),
                );
        },
      );
    }

    return direction == ShimmerDirection.vertical
        ? Column(
            children: List.generate(
              itemCount,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index < itemCount - 1 ? spacing : 0,
                ),
                child: _buildShimmerItem(),
              ),
            ),
          )
        : Row(
            children: List.generate(
              itemCount,
              (index) => Padding(
                padding: EdgeInsets.only(
                  right: index < itemCount - 1 ? spacing : 0,
                ),
                child: _buildShimmerItem(),
              ),
            ),
          );
  }

  Widget _buildGridShimmer() {
    if (itemBuilder != null) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          childAspectRatio: childAspectRatio ?? 1.0,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) => itemBuilder!(context, index),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    Widget shimmerBox = Container(
      width: width,
      height: height,
      color: Colors.white,
    );

    switch (shape) {
      case ShimmerShape.rectangle:
        shimmerBox = Container(
          width: width,
          height: height,
          color: Colors.white,
        );
        break;
      case ShimmerShape.roundedRectangle:
        shimmerBox = Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
        break;
      case ShimmerShape.circle:
        shimmerBox = Container(
          width: width ?? height ?? 50,
          height: height ?? width ?? 50,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        );
        break;
    }

    return shimmerBox;
  }
}

/// Pre-built shimmer widgets for common use cases

/// Shimmer for a card-like item
class AppShimmerCard extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppShimmerCard({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 12.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      shape: ShimmerShape.roundedRectangle,
      layout: ShimmerLayout.single,
      padding: padding,
      margin: margin,
    );
  }
}

/// Shimmer for a list of items
class AppShimmerList extends StatelessWidget {
  final int itemCount;
  final double? itemHeight;
  final double? itemWidth;
  final double borderRadius;
  final double spacing;
  final ShimmerDirection direction;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight,
    this.itemWidth,
    this.borderRadius = 8.0,
    this.spacing = 12.0,
    this.direction = ShimmerDirection.vertical,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: itemWidth,
      height: itemHeight,
      borderRadius: borderRadius,
      shape: ShimmerShape.roundedRectangle,
      layout: ShimmerLayout.list,
      itemCount: itemCount,
      direction: direction,
      spacing: spacing,
      padding: padding,
      margin: margin,
    );
  }
}

/// Shimmer for a grid of items
class AppShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double? itemHeight;
  final double? itemWidth;
  final double borderRadius;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppShimmerGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.itemHeight,
    this.itemWidth,
    this.borderRadius = 8.0,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.childAspectRatio,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: itemWidth,
      height: itemHeight,
      borderRadius: borderRadius,
      shape: ShimmerShape.roundedRectangle,
      layout: ShimmerLayout.grid,
      itemCount: itemCount,
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      childAspectRatio: childAspectRatio,
      padding: padding,
      margin: margin,
    );
  }
}

/// Shimmer for a circular avatar
class AppShimmerCircle extends StatelessWidget {
  final double? diameter;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppShimmerCircle({super.key, this.diameter, this.padding, this.margin});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: diameter,
      height: diameter,
      shape: ShimmerShape.circle,
      layout: ShimmerLayout.single,
      padding: padding,
      margin: margin,
    );
  }
}

/// Shimmer for a text line
class AppShimmerText extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppShimmerText({
    super.key,
    this.width,
    this.height = 16.0,
    this.borderRadius = 4.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      shape: ShimmerShape.roundedRectangle,
      layout: ShimmerLayout.single,
      padding: padding,
      margin: margin,
    );
  }
}
