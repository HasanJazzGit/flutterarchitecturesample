import 'package:flutter/material.dart';

/// MVVM Architecture Structure Guide Page
/// Shows folder structure and how to create features
class MvvmStructureGuidePage extends StatelessWidget {
  const MvvmStructureGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MVVM Architecture Guide'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'MVVM Architecture Structure',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete guide on folder structure and file naming',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Folder Structure
            _buildSection(
              context,
              title: '📁 Folder Structure',
              content: _buildFolderStructure(context),
            ),

            const SizedBox(height: 24),

            // File Naming Convention
            _buildSection(
              context,
              title: '📝 File Naming Convention',
              content: _buildNamingConvention(context),
            ),

            const SizedBox(height: 24),

            // How to Create Feature
            _buildSection(
              context,
              title: '🚀 How to Create a Feature',
              content: _buildHowToCreate(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget content,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildFolderStructure(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileTreeItem(
              context,
              'example_mvvm/',
              isFolder: true,
              children: [
                _buildFileTreeItem(context, 'mvvm_feature_injection.dart'),
                _buildFileTreeItem(
                  context,
                  'model/',
                  isFolder: true,
                  children: [
                    _buildFileTreeItem(
                      context,
                      'models/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'mvvm_task_model.dart'),
                      ],
                    ),
                  ],
                ),
                _buildFileTreeItem(
                  context,
                  'viewmodel/',
                  isFolder: true,
                  children: [
                    _buildFileTreeItem(context, 'mvvm_task_cubit.dart'),
                    _buildFileTreeItem(context, 'mvvm_task_state.dart'),
                  ],
                ),
                _buildFileTreeItem(
                  context,
                  'view/',
                  isFolder: true,
                  children: [
                    _buildFileTreeItem(
                      context,
                      'pages/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'mvvm_task_page.dart'),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'widgets/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'mvvm_task_card.dart'),
                        _buildFileTreeItem(context, 'mvvm_task_list.dart'),
                        _buildFileTreeItem(
                          context,
                          'mvvm_task_form_bottom_sheet.dart',
                        ),
                      ],
                    ),
                  ],
                ),
                _buildFileTreeItem(
                  context,
                  'data/',
                  isFolder: true,
                  children: [
                    _buildFileTreeItem(
                      context,
                      'database/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(
                          context,
                          'tables/',
                          isFolder: true,
                          children: [
                            _buildFileTreeItem(context, 'mvvm_task_table.dart'),
                          ],
                        ),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'data_sources/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(
                          context,
                          'mvvm_task_remote_data_source.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'mvvm_task_remote_data_source_impl.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'mvvm_task_local_data_source.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'mvvm_task_local_data_source_impl.dart',
                        ),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'repositories/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(
                          context,
                          'mvvm_task_repository_impl.dart',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTreeItem(
    BuildContext context,
    String name, {
    bool isFolder = false,
    List<Widget>? children,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(left: isFolder ? 0 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFolder ? Icons.folder : Icons.description,
                size: 16,
                color: isFolder
                    ? colorScheme.primary
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: 'monospace',
                    color: isFolder
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildNamingConvention(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNamingRule(
              context,
              'Prefix:',
              'All files start with mvvm_',
              'mvvm_task_model.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Model:',
              'Data models',
              'mvvm_task_model.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'ViewModel/Cubit:',
              'Business logic and state',
              'mvvm_task_cubit.dart\nmvvm_task_state.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'View:',
              'UI components',
              'mvvm_task_page.dart\nmvvm_task_card.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Data Source:',
              'Remote and local data sources',
              'mvvm_task_remote_data_source.dart\nmvvm_task_local_data_source_impl.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Repository:',
              'Repository implementation',
              'mvvm_task_repository_impl.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Table:',
              'Database tables',
              'mvvm_task_table.dart',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNamingRule(
    BuildContext context,
    String title,
    String description,
    String example,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(description, style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            example,
            style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }

  Widget _buildHowToCreate(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStep(
              context,
              '1',
              'Create Feature Folder',
              'Create folder: lib/features/your_feature_name/',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '2',
              'Create Model Layer',
              'Create model/models/mvvm_your_model.dart',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '3',
              'Create ViewModel Layer',
              'Create viewmodel/mvvm_your_cubit.dart\nCreate viewmodel/mvvm_your_state.dart',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '4',
              'Create View Layer',
              'Create view/pages/mvvm_your_page.dart\nCreate view/widgets/mvvm_your_widgets.dart',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '5',
              'Create Data Layer',
              'Create data/data_sources/mvvm_your_data_sources.dart\nCreate data/repositories/mvvm_your_repository_impl.dart\nCreate data/database/tables/mvvm_your_table.dart (if needed)',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '6',
              'Setup Dependency Injection',
              'Create mvvm_feature_injection.dart\nRegister all dependencies in DI',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '7',
              'Add Routes',
              'Add route in app_routes.dart\nAdd route in app_router.dart',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    String number,
    String title,
    String description,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
