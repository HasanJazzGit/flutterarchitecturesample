import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/locale_bottom_sheet.dart';
import '../widgets/theme_bottom_sheet.dart';

/// Examples page showcasing all features of the project
class ExamplesPage extends StatelessWidget {
  const ExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Project Examples'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Flutter Sample Architecture',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore all features and examples',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),

            // Architecture Examples
            _buildSection(
              context,
              title: 'Architecture Patterns',
              icon: Icons.architecture,
              color: Colors.blue,
              examples: [
                _ExampleItem(
                  title: 'MVVM Pattern',
                  description:
                      'Complete MVVM implementation with Model, ViewModel, View, Data, and Repository',
                  route: AppRoutes.exampleMvvm,
                  icon: Icons.view_module,
                ),
                _ExampleItem(
                  title: 'Clean Architecture',
                  description:
                      'Complete example with Domain, Data, and Presentation layers - Notes feature',
                  route: AppRoutes.exampleClean,
                  icon: Icons.layers,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // UI Components
            _buildSection(
              context,
              title: 'UI Components',
              icon: Icons.widgets,
              color: Colors.purple,
              examples: [
                _ExampleItem(
                  title: 'Shimmer Effects',
                  description:
                      'Beautiful loading shimmer widgets with full customization',
                  route: AppRoutes.shimmerExamples,
                  icon: Icons.auto_awesome,
                ),
                _ExampleItem(
                  title: 'Custom Buttons',
                  description: 'Custom button widgets with loading states',
                  route: null,
                  icon: Icons.touch_app,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Custom buttons are used throughout the app',
                        ),
                      ),
                    );
                  },
                ),
                _ExampleItem(
                  title: 'Custom Text Fields',
                  description: 'Enhanced text fields with validation',
                  route: null,
                  icon: Icons.text_fields,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Custom text fields are used in login page',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Features
            _buildSection(
              context,
              title: 'Features',
              icon: Icons.star,
              color: Colors.orange,
              examples: [
                _ExampleItem(
                  title: 'Authentication',
                  description:
                      'Login with email/password, state management with Cubit',
                  route: AppRoutes.login,
                  icon: Icons.lock,
                ),
                _ExampleItem(
                  title: 'Products',
                  description:
                      'Product listing with API integration, offline support, and state management',
                  route: AppRoutes.products,
                  icon: Icons.shopping_bag,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // State Management
            _buildSection(
              context,
              title: 'State Management',
              icon: Icons.settings,
              color: Colors.green,
              examples: [
                _ExampleItem(
                  title: 'BLoC/Cubit',
                  description: 'State management using flutter_bloc and Cubit',
                  route: null,
                  icon: Icons.account_tree,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'BLoC pattern used in Auth, Dashboard, and Products',
                        ),
                      ),
                    );
                  },
                ),
                _ExampleItem(
                  title: 'Freezed States',
                  description: 'Immutable state classes generated with Freezed',
                  route: null,
                  icon: Icons.code,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'All states use Freezed for immutability',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Data Layer
            _buildSection(
              context,
              title: 'Data Layer',
              icon: Icons.storage,
              color: Colors.teal,
              examples: [
                _ExampleItem(
                  title: 'Repository Pattern',
                  description:
                      'Data abstraction with repository implementation',
                  route: null,
                  icon: Icons.folder,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Repository pattern used in all features',
                        ),
                      ),
                    );
                  },
                ),
                _ExampleItem(
                  title: 'Data Sources',
                  description:
                      'Remote data sources with API client integration',
                  route: null,
                  icon: Icons.cloud,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Remote data sources handle API calls'),
                      ),
                    );
                  },
                ),
                _ExampleItem(
                  title: 'Mock API Responses',
                  description: 'Debug mode mock data for testing',
                  route: null,
                  icon: Icons.bug_report,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mock responses enabled in debug mode'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Utilities
            _buildSection(
              context,
              title: 'Utilities & Tools',
              icon: Icons.build,
              color: Colors.indigo,
              examples: [
                _ExampleItem(
                  title: 'Dependency Injection',
                  description:
                      'GetIt service locator for dependency management',
                  route: null,
                  icon: Icons.inventory,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('GetIt used for DI throughout the app'),
                      ),
                    );
                  },
                ),
                _ExampleItem(
                  title: 'Navigation',
                  description: 'GoRouter for type-safe navigation',
                  route: null,
                  icon: Icons.navigation,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('GoRouter handles all navigation'),
                      ),
                    );
                  },
                ),
                _ExampleItem(
                  title: 'Localization',
                  description: 'Multi-language support with English and Urdu',
                  route: null,
                  icon: Icons.language,
                  onTap: () {
                    LocaleBottomSheet.show(context);
                  },
                ),
                _ExampleItem(
                  title: 'Theme Management',
                  description: 'Light, Dark, and System theme modes',
                  route: null,
                  icon: Icons.palette,
                  onTap: () {
                    ThemeBottomSheet.show(context);
                  },
                ),
                _ExampleItem(
                  title: 'Error Handling',
                  description: 'Comprehensive error handling with Either type',
                  route: null,
                  icon: Icons.error_outline,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Either<Error, Success> pattern used'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<_ExampleItem> examples,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...examples.map((example) => _ExampleCard(example: example)),
      ],
    );
  }
}

class _ExampleItem {
  final String title;
  final String description;
  final String? route;
  final IconData icon;
  final VoidCallback? onTap;

  _ExampleItem({
    required this.title,
    required this.description,
    this.route,
    required this.icon,
    this.onTap,
  });
}

class _ExampleCard extends StatelessWidget {
  final _ExampleItem example;

  const _ExampleCard({required this.example});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (example.route != null) {
            context.push(AppRoutes.path(example.route!));
          } else if (example.onTap != null) {
            example.onTap!();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  example.icon,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      example.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
