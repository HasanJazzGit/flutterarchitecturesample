import 'package:flutter/material.dart';
import 'app_shimmer.dart';

/// Example usage of AppShimmer widget
///
/// This file demonstrates various ways to use the AppShimmer widget
/// with different configurations.

class AppShimmerExamples extends StatelessWidget {
  const AppShimmerExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shimmer Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example 1: Single rounded rectangle
            const Text('1. Single Rounded Rectangle:'),
            const SizedBox(height: 8),
            const AppShimmer(
              width: 200,
              height: 100,
              borderRadius: 12,
              shape: ShimmerShape.roundedRectangle,
            ),
            const SizedBox(height: 24),

            // Example 2: Single circle
            const Text('2. Single Circle:'),
            const SizedBox(height: 8),
            const AppShimmer(width: 80, height: 80, shape: ShimmerShape.circle),
            const SizedBox(height: 24),

            // Example 3: Vertical list
            const Text('3. Vertical List:'),
            const SizedBox(height: 8),
            const AppShimmer(
              width: double.infinity,
              height: 60,
              layout: ShimmerLayout.list,
              itemCount: 5,
              direction: ShimmerDirection.vertical,
              spacing: 12,
            ),
            const SizedBox(height: 24),

            // Example 4: Horizontal list
            const Text('4. Horizontal List:'),
            const SizedBox(height: 8),
            const AppShimmer(
              width: 120,
              height: 120,
              layout: ShimmerLayout.list,
              itemCount: 4,
              direction: ShimmerDirection.horizontal,
              spacing: 12,
            ),
            const SizedBox(height: 24),

            // Example 5: Grid
            const Text('5. Grid Layout:'),
            const SizedBox(height: 8),
            const AppShimmer(
              layout: ShimmerLayout.grid,
              itemCount: 6,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            const SizedBox(height: 24),

            // Example 6: Custom colors
            const Text('6. Custom Colors:'),
            const SizedBox(height: 8),
            const AppShimmer(
              width: 200,
              height: 100,
              baseColor: Colors.blue,
              highlightColor: Colors.lightBlue,
            ),
            const SizedBox(height: 24),

            // Example 7: Using pre-built widgets - Card
            const Text('7. Pre-built Shimmer Card:'),
            const SizedBox(height: 8),
            const AppShimmerCard(
              width: double.infinity,
              height: 150,
              borderRadius: 16,
            ),
            const SizedBox(height: 24),

            // Example 8: Using pre-built widgets - List
            const Text('8. Pre-built Shimmer List:'),
            const SizedBox(height: 8),
            const AppShimmerList(itemCount: 4, itemHeight: 80, spacing: 16),
            const SizedBox(height: 24),

            // Example 9: Using pre-built widgets - Grid
            const Text('9. Pre-built Shimmer Grid:'),
            const SizedBox(height: 8),
            const AppShimmerGrid(
              itemCount: 8,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            const SizedBox(height: 24),

            // Example 10: Using pre-built widgets - Circle
            const Text('10. Pre-built Shimmer Circle:'),
            const SizedBox(height: 8),
            const Row(
              children: [
                AppShimmerCircle(diameter: 60),
                SizedBox(width: 16),
                AppShimmerCircle(diameter: 80),
                SizedBox(width: 16),
                AppShimmerCircle(diameter: 100),
              ],
            ),
            const SizedBox(height: 24),

            // Example 11: Using pre-built widgets - Text
            const Text('11. Pre-built Shimmer Text Lines:'),
            const SizedBox(height: 8),
            const Column(
              children: [
                AppShimmerText(width: double.infinity, height: 16),
                SizedBox(height: 8),
                AppShimmerText(width: 250, height: 16),
                SizedBox(height: 8),
                AppShimmerText(width: 180, height: 16),
              ],
            ),
            const SizedBox(height: 24),

            // Example 12: Custom item builder for list
            const Text('12. Custom Item Builder (List):'),
            const SizedBox(height: 8),
            AppShimmer(
              layout: ShimmerLayout.list,
              itemCount: 3,
              direction: ShimmerDirection.vertical,
              spacing: 12,
              itemBuilder: (context, index) {
                return const Row(
                  children: [
                    AppShimmerCircle(diameter: 50),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppShimmerText(width: double.infinity, height: 16),
                          SizedBox(height: 8),
                          AppShimmerText(width: 150, height: 14),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Example 13: Custom item builder for grid
            const Text('13. Custom Item Builder (Grid):'),
            const SizedBox(height: 8),
            AppShimmer(
              layout: ShimmerLayout.grid,
              itemCount: 4,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              itemBuilder: (context, index) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer(
                      width: double.infinity,
                      height: 120,
                      shape: ShimmerShape.roundedRectangle,
                      borderRadius: 8,
                    ),
                    SizedBox(height: 8),
                    AppShimmerText(width: double.infinity, height: 14),
                    SizedBox(height: 4),
                    AppShimmerText(width: 100, height: 12),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
