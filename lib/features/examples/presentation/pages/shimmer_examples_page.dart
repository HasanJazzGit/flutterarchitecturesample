import 'package:flutter/material.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Shimmer Examples Page
class ShimmerExamplesPage extends StatelessWidget {
  const ShimmerExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Shimmer Examples'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Shimmer Widget Examples',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Beautiful loading placeholders with full customization',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Example 1: Single Rounded Rectangle
            _buildExampleSection(
              context,
              title: '1. Single Rounded Rectangle',
              child: const AppShimmer(
                width: 200,
                height: 100,
                borderRadius: 12,
                shape: ShimmerShape.roundedRectangle,
              ),
            ),

            const SizedBox(height: 24),

            // Example 2: Single Circle
            _buildExampleSection(
              context,
              title: '2. Single Circle',
              child: const AppShimmer(
                width: 80,
                height: 80,
                shape: ShimmerShape.circle,
              ),
            ),

            const SizedBox(height: 24),

            // Example 3: Vertical List
            _buildExampleSection(
              context,
              title: '3. Vertical List',
              child: const AppShimmer(
                width: double.infinity,
                height: 60,
                layout: ShimmerLayout.list,
                itemCount: 5,
                direction: ShimmerDirection.vertical,
                spacing: 12,
              ),
            ),

            const SizedBox(height: 24),

            // Example 4: Horizontal List
            _buildExampleSection(
              context,
              title: '4. Horizontal List',
              child: const SizedBox(
                height: 120,
                child: AppShimmer(
                  width: 120,
                  height: 120,
                  layout: ShimmerLayout.list,
                  itemCount: 4,
                  direction: ShimmerDirection.horizontal,
                  spacing: 12,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Example 5: Grid
            _buildExampleSection(
              context,
              title: '5. Grid Layout',
              child: const AppShimmer(
                layout: ShimmerLayout.grid,
                itemCount: 6,
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
            ),

            const SizedBox(height: 24),

            // Example 6: Custom Colors
            _buildExampleSection(
              context,
              title: '6. Custom Colors',
              child: const AppShimmer(
                width: 200,
                height: 100,
                baseColor: Colors.blue,
                highlightColor: Colors.lightBlue,
              ),
            ),

            const SizedBox(height: 24),

            // Example 7: Pre-built Shimmer Card
            _buildExampleSection(
              context,
              title: '7. Pre-built Shimmer Card',
              child: const AppShimmerCard(
                width: double.infinity,
                height: 150,
                borderRadius: 16,
              ),
            ),

            const SizedBox(height: 24),

            // Example 8: Pre-built Shimmer List
            _buildExampleSection(
              context,
              title: '8. Pre-built Shimmer List',
              child: const AppShimmerList(
                itemCount: 4,
                itemHeight: 80,
                spacing: 16,
              ),
            ),

            const SizedBox(height: 24),

            // Example 9: Pre-built Shimmer Grid
            _buildExampleSection(
              context,
              title: '9. Pre-built Shimmer Grid',
              child: const AppShimmerGrid(
                itemCount: 8,
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),

            const SizedBox(height: 24),

            // Example 10: Pre-built Shimmer Circle
            _buildExampleSection(
              context,
              title: '10. Pre-built Shimmer Circle',
              child: const Row(
                children: [
                  AppShimmerCircle(diameter: 60),
                  SizedBox(width: 16),
                  AppShimmerCircle(diameter: 80),
                  SizedBox(width: 16),
                  AppShimmerCircle(diameter: 100),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Example 11: Pre-built Shimmer Text
            _buildExampleSection(
              context,
              title: '11. Pre-built Shimmer Text Lines',
              child: const Column(
                children: [
                  AppShimmerText(width: double.infinity, height: 16),
                  SizedBox(height: 8),
                  AppShimmerText(width: 250, height: 16),
                  SizedBox(height: 8),
                  AppShimmerText(width: 180, height: 16),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Example 12: Custom Item Builder (List)
            _buildExampleSection(
              context,
              title: '12. Custom Item Builder (List)',
              child: AppShimmer(
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
            ),

            const SizedBox(height: 24),

            // Example 13: Custom Item Builder (Grid)
            _buildExampleSection(
              context,
              title: '13. Custom Item Builder (Grid)',
              child: AppShimmer(
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
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
