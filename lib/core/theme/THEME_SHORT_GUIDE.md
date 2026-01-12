# Theme Quick Guide

Short reference for theming, adding new colors, and using ThemeExtension.

---

## Files
- `lib/core/theme/app_theme.dart` — builds light/dark `ThemeData` and attaches extensions.
- `lib/core/theme/app_theme_colors.dart` — defines `AppColors` ThemeExtension.

---

## Use theme in UI
```dart
final theme = Theme.of(context);
final colors = theme.colorScheme;            // Material colors
final appColors = theme.extension<AppColors>(); // Custom colors

Container(
  color: colors.surface,
  child: Text(
    'Hello',
    style: theme.textTheme.titleMedium?.copyWith(
      color: appColors?.textPrimary,
    ),
  ),
);
```

---

## Add a new custom color (ThemeExtension)
1) Add field to `AppColors`:
```dart
final Color? badge;

const AppColors({
  // existing...
  this.badge,
});
```

2) Add values in light/dark:
```dart
static const AppColors light = AppColors(
  // existing...
  badge: Color(0xFFE91E63),
);

static const AppColors dark = AppColors(
  // existing...
  badge: Color(0xFFF06292),
);
```

3) Update `copyWith` and `lerp`:
```dart
badge: badge ?? this.badge,
badge: Color.lerp(badge, other.badge, t),
```

4) Use it:
```dart
final appColors = Theme.of(context).extension<AppColors>();
Container(color: appColors?.badge);
```

---

## Add a Material color (ColorScheme)
In `AppTheme.lightTheme` / `darkTheme`, update `ColorScheme.fromSeed` or set properties:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: AppColors.light.primary,
  brightness: Brightness.light,
).copyWith(
  surfaceTint: Colors.transparent,
  // add overrides here
),
```

---

## Theme switching (light/dark/system)
`MaterialApp`:
```dart
MaterialApp.router(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: state.themeMode, // e.g., ThemeMode.system
);
```

Switch in cubit:
```dart
await _appPref.setThemeMode('dark'); // persist
emit(state.copyWith(themeMode: ThemeMode.dark));
```

---

## Quick checklist
- Use `ColorScheme` for Material colors.
- Use `AppColors` extension for custom colors.
- Provide both light and dark values.
- Persist theme choice if user-selectable.
- Access via `Theme.of(context)` and `ThemeExtension`.
