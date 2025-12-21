import 'package:flutter/material.dart';

/// Clean Architecture Structure Guide Page
/// Shows folder structure and how to create features
class CleanStructureGuidePage extends StatelessWidget {
  const CleanStructureGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture Guide'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Clean Architecture Structure',
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFileTreeItem(
              context,
              'example_clean/',
              isFolder: true,
              children: [
                _buildFileTreeItem(context, 'clean_feature_injection.dart'),
                _buildFileTreeItem(
                  context,
                  'domain/',
                  isFolder: true,
                  children: [
                    _buildFileTreeItem(
                      context,
                      'entities/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'clean_note_entity.dart'),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'repositories/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(
                          context,
                          'clean_note_repository.dart',
                        ),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'use_cases/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(
                          context,
                          'clean_create_note_use_case.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'clean_get_notes_use_case.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'clean_update_note_use_case.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'clean_delete_note_use_case.dart',
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
                      'models/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'clean_note_model.dart'),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'mappers/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'clean_note_mapper.dart'),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'data_sources/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(
                          context,
                          'clean_note_remote_data_source.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'clean_note_remote_data_source_impl.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'clean_note_local_data_source.dart',
                        ),
                        _buildFileTreeItem(
                          context,
                          'clean_note_local_data_source_impl.dart',
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
                          'clean_note_repository_impl.dart',
                        ),
                      ],
                    ),
                  ],
                ),
                _buildFileTreeItem(
                  context,
                  'presentation/',
                  isFolder: true,
                  children: [
                    _buildFileTreeItem(
                      context,
                      'cubit/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'clean_notes_cubit.dart'),
                        _buildFileTreeItem(context, 'clean_notes_state.dart'),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'pages/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'clean_notes_page.dart'),
                      ],
                    ),
                    _buildFileTreeItem(
                      context,
                      'widgets/',
                      isFolder: true,
                      children: [
                        _buildFileTreeItem(context, 'clean_note_card.dart'),
                        _buildFileTreeItem(context, 'clean_notes_list.dart'),
                        _buildFileTreeItem(
                          context,
                          'clean_note_form_bottom_sheet.dart',
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
              'All files start with clean_',
              'clean_note_entity.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Entity:',
              'Domain entities',
              'clean_note_entity.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Model:',
              'Data models',
              'clean_note_model.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Mapper:',
              'Entity/Model mappers',
              'clean_note_mapper.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Repository:',
              'Repository interfaces and implementations',
              'clean_note_repository.dart\nclean_note_repository_impl.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Use Case:',
              'Business logic use cases',
              'clean_create_note_use_case.dart\nclean_get_notes_use_case.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Cubit/State:',
              'State management',
              'clean_notes_cubit.dart\nclean_notes_state.dart',
            ),
            const SizedBox(height: 16),
            _buildNamingRule(
              context,
              'Page/Widget:',
              'UI components',
              'clean_notes_page.dart\nclean_note_card.dart',
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
              'Create Domain Layer',
              'Create domain/entities/clean_your_entity.dart\nCreate domain/repositories/clean_your_repository.dart\nCreate domain/use_cases/clean_your_use_cases.dart',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '3',
              'Create Data Layer',
              'Create data/models/clean_your_model.dart\nCreate data/mappers/clean_your_mapper.dart\nCreate data/data_sources/clean_your_data_sources.dart\nCreate data/repositories/clean_your_repository_impl.dart',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '4',
              'Create Presentation Layer',
              'Create presentation/cubit/clean_your_cubit.dart\nCreate presentation/cubit/clean_your_state.dart\nCreate presentation/pages/clean_your_page.dart\nCreate presentation/widgets/clean_your_widgets.dart',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '5',
              'Setup Dependency Injection',
              'Create clean_feature_injection.dart\nRegister all dependencies in DI',
            ),
            const SizedBox(height: 16),
            _buildStep(
              context,
              '6',
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
