import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/localization/app_localization_service.dart';
import '../../../products/presentation/manager/products_cubit.dart';
import '../../../products/presentation/widgets/products_list.dart';
import '../manager/dashboard_cubit.dart';
import '../manager/dashboard_state.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<DashboardCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboard),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context, cubit);
            },
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                // Welcome Card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.welcome,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${l10n.theme}: ${_getThemeModeName(context, state.themeMode)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '${l10n.language}: ${AppLocalizationService.getLocaleName(state.locale)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Tabs
                TabBar(
                  tabs: [
                    Tab(icon: const Icon(Icons.shopping_bag), text: 'Products'),
                    Tab(icon: const Icon(Icons.settings), text: l10n.settings),
                  ],
                ),
                // Tab Views
                Expanded(
                  child: TabBarView(
                    children: [
                      // Products Tab
                      BlocProvider(
                        create: (context) => sl<ProductsCubit>(),
                        child: const ProductsList(),
                      ),
                      // Settings Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Quick Actions
                            Text(
                              'Quick Actions',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.palette,
                                    title: l10n.changeTheme,
                                    onTap: () =>
                                        _showThemeDialog(context, cubit, state),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _ActionCard(
                                    icon: Icons.language,
                                    title: l10n.changeLanguage,
                                    onTap: () => _showLanguageDialog(
                                      context,
                                      cubit,
                                      state,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Theme Info Card
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.palette,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.theme,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _getThemeModeName(
                                        context,
                                        state.themeMode,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Language Info Card
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.language,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          l10n.language,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppLocalizationService.getLocaleName(
                                        state.locale,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppLocalizationService.isRTL(state.locale)
                                          ? 'RTL (Right-to-Left)'
                                          : 'LTR (Left-to-Right)',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getThemeModeName(BuildContext context, ThemeMode themeMode) {
    final l10n = AppLocalizations.of(context)!;
    switch (themeMode) {
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkTheme;
      case ThemeMode.system:
        return l10n.systemTheme;
    }
  }

  void _showThemeDialog(
    BuildContext context,
    DashboardCubit cubit,
    DashboardState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.lightTheme),
              value: ThemeMode.light,
              groupValue: state.themeMode,
              onChanged: (value) {
                if (value != null) {
                  cubit.changeTheme(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.darkTheme),
              value: ThemeMode.dark,
              groupValue: state.themeMode,
              onChanged: (value) {
                if (value != null) {
                  cubit.changeTheme(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.systemTheme),
              value: ThemeMode.system,
              groupValue: state.themeMode,
              onChanged: (value) {
                if (value != null) {
                  cubit.changeTheme(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    DashboardCubit cubit,
    DashboardState state,
  ) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppLocalizationService.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(AppLocalizationService.getLocaleName(locale)),
              value: locale,
              groupValue: state.locale,
              onChanged: (value) {
                if (value != null) {
                  cubit.changeLocale(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, DashboardCubit cubit) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text(l10n.theme),
                  subtitle: Text(_getThemeModeName(context, state.themeMode)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showThemeDialog(context, cubit, state);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l10n.language),
                  subtitle: Text(
                    AppLocalizationService.getLocaleName(state.locale),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showLanguageDialog(context, cubit, state);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
