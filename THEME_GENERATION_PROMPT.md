# 🎨 Theme Generation Prompt Template

A reusable prompt template for generating Flutter theme classes from provided colors.

---

## 📋 How to Use This Prompt

### Method 1: Direct Prompt (Recommended)
1. Copy the prompt template below
2. Fill in your color values
3. Provide the prompt to an AI assistant (like Cursor, ChatGPT, etc.)
4. Get generated theme code

### Method 2: Using JSON Template
1. Fill in `theme_colors_template.json` with your colors
2. Use the JSON values to fill the prompt template
3. Provide the filled prompt to an AI assistant
4. Get generated theme code

---

## 🎯 Prompt Template

```
I need you to create a Flutter theme system for my app. Please generate the following files based on the colors I provide:

1. AppThemeColors class (ThemeExtension) with all color properties
2. AppTheme class with light and dark theme configurations
3. Material 3 compatible theme setup

Here are my app colors:

### Light Theme Colors:
- Primary: [YOUR_PRIMARY_COLOR] (e.g., #6750A4)
- Secondary: [YOUR_SECONDARY_COLOR] (e.g., #625B71)
- Tertiary: [YOUR_TERTIARY_COLOR] (e.g., #7D5260)
- Error: [YOUR_ERROR_COLOR] (e.g., #BA1A1A)
- Surface: [YOUR_SURFACE_COLOR] (e.g., #FFFBFE)
- Background: [YOUR_BACKGROUND_COLOR] (e.g., #FFFBFE)
- OnPrimary: [YOUR_ON_PRIMARY_COLOR] (e.g., #FFFFFF)
- OnSecondary: [YOUR_ON_SECONDARY_COLOR] (e.g., #FFFFFF)
- OnTertiary: [YOUR_ON_TERTIARY_COLOR] (e.g., #FFFFFF)
- OnError: [YOUR_ON_ERROR_COLOR] (e.g., #FFFFFF)
- OnSurface: [YOUR_ON_SURFACE_COLOR] (e.g., #1C1B1F)
- OnBackground: [YOUR_ON_BACKGROUND_COLOR] (e.g., #1C1B1F)

### Custom Colors (Optional):
- Success: [YOUR_SUCCESS_COLOR] (e.g., #4CAF50)
- Warning: [YOUR_WARNING_COLOR] (e.g., #FF9800)
- Info: [YOUR_INFO_COLOR] (e.g., #2196F3)
- Divider: [YOUR_DIVIDER_COLOR] (e.g., #E0E0E0)
- Border: [YOUR_BORDER_COLOR] (e.g., #BDBDBD)
- Disabled: [YOUR_DISABLED_COLOR] (e.g., #9E9E9E)
- Text Primary: [YOUR_TEXT_PRIMARY_COLOR] (e.g., #212121)
- Text Secondary: [YOUR_TEXT_SECONDARY_COLOR] (e.g., #757575)
- Card Background: [YOUR_CARD_BACKGROUND_COLOR] (e.g., #FFFFFF)
- Scaffold Background: [YOUR_SCAFFOLD_BACKGROUND_COLOR] (e.g., #F5F5F5)

### Dark Theme Colors:
- Primary: [YOUR_DARK_PRIMARY_COLOR] (e.g., #D0BCFF)
- Secondary: [YOUR_DARK_SECONDARY_COLOR] (e.g., #CCC2DC)
- Tertiary: [YOUR_DARK_TERTIARY_COLOR] (e.g., #EFB8C8)
- Error: [YOUR_DARK_ERROR_COLOR] (e.g., #FFB4AB)
- Surface: [YOUR_DARK_SURFACE_COLOR] (e.g., #1C1B1F)
- Background: [YOUR_DARK_BACKGROUND_COLOR] (e.g., #1C1B1F)
- OnPrimary: [YOUR_DARK_ON_PRIMARY_COLOR] (e.g., #381E72)
- OnSecondary: [YOUR_DARK_ON_SECONDARY_COLOR] (e.g., #332D41)
- OnTertiary: [YOUR_DARK_ON_TERTIARY_COLOR] (e.g., #492532)
- OnError: [YOUR_DARK_ON_ERROR_COLOR] (e.g., #690005)
- OnSurface: [YOUR_DARK_ON_SURFACE_COLOR] (e.g., #E6E1E5)
- OnBackground: [YOUR_DARK_ON_BACKGROUND_COLOR] (e.g., #E6E1E5)

### Additional Requirements:
- Use Material 3 design system
- Include copyWith and lerp methods for ThemeExtension
- Generate both light and dark themes
- Include proper text themes
- Include component themes (buttons, cards, inputs)
- Use Color(0xFF...) format for all colors
- Make all colors const where possible

Please generate:
1. app_theme_colors.dart - ThemeExtension class with all colors
2. app_theme.dart - ThemeData configuration for light and dark themes

The code should follow Flutter best practices and Material 3 guidelines.
```

---

## 📝 Example: Filled Prompt

```
I need you to create a Flutter theme system for my app. Please generate the following files based on the colors I provide:

1. AppThemeColors class (ThemeExtension) with all color properties
2. AppTheme class with light and dark theme configurations
3. Material 3 compatible theme setup

Here are my app colors:

### Light Theme Colors:
- Primary: #2196F3 (Blue)
- Secondary: #FF9800 (Orange)
- Tertiary: #4CAF50 (Green)
- Error: #F44336 (Red)
- Surface: #FFFFFF (White)
- Background: #F5F5F5 (Light Gray)
- OnPrimary: #FFFFFF (White)
- OnSecondary: #FFFFFF (White)
- OnTertiary: #FFFFFF (White)
- OnError: #FFFFFF (White)
- OnSurface: #212121 (Dark Gray)
- OnBackground: #212121 (Dark Gray)

### Custom Colors:
- Success: #4CAF50 (Green)
- Warning: #FF9800 (Orange)
- Info: #2196F3 (Blue)
- Divider: #E0E0E0 (Light Gray)
- Border: #BDBDBD (Gray)
- Disabled: #9E9E9E (Gray)
- Text Primary: #212121 (Dark Gray)
- Text Secondary: #757575 (Medium Gray)
- Card Background: #FFFFFF (White)
- Scaffold Background: #F5F5F5 (Light Gray)

### Dark Theme Colors:
- Primary: #64B5F6 (Light Blue)
- Secondary: #FFB74D (Light Orange)
- Tertiary: #81C784 (Light Green)
- Error: #E57373 (Light Red)
- Surface: #121212 (Dark)
- Background: #000000 (Black)
- OnPrimary: #000000 (Black)
- OnSecondary: #000000 (Black)
- OnTertiary: #000000 (Black)
- OnError: #000000 (Black)
- OnSurface: #FFFFFF (White)
- OnBackground: #FFFFFF (White)

### Additional Requirements:
- Use Material 3 design system
- Include copyWith and lerp methods for ThemeExtension
- Generate both light and dark themes
- Include proper text themes
- Include component themes (buttons, cards, inputs)
- Use Color(0xFF...) format for all colors
- Make all colors const where possible

Please generate:
1. app_theme_colors.dart - ThemeExtension class with all colors
2. app_theme.dart - ThemeData configuration for light and dark themes

The code should follow Flutter best practices and Material 3 guidelines.
```

---

## 🎨 Quick Color Format Reference

### Color Formats Accepted:
- **Hex with #**: `#2196F3`
- **Hex without #**: `2196F3`
- **RGB**: `rgb(33, 150, 243)`
- **Flutter Color**: `Color(0xFF2196F3)`

### Color Conversion:
- `#2196F3` → `Color(0xFF2196F3)`
- `rgb(33, 150, 243)` → `Color(0xFF2196F3)`

---

## 📦 Generated Files Structure

After using the prompt, you should get:

```
lib/core/theme/
├── app_theme_colors.dart    # ThemeExtension with all colors
└── app_theme.dart          # ThemeData configuration
```

---

## ✅ Checklist for Generated Code

- [ ] AppThemeColors extends ThemeExtension
- [ ] Has copyWith method
- [ ] Has lerp method
- [ ] Light theme colors defined
- [ ] Dark theme colors defined
- [ ] AppTheme.lightTheme returns ThemeData
- [ ] AppTheme.darkTheme returns ThemeData
- [ ] Material 3 enabled (useMaterial3: true)
- [ ] ColorScheme.fromSeed used
- [ ] Text themes included
- [ ] Component themes included (buttons, cards, inputs)
- [ ] All colors use Color(0xFF...) format

---

## 🔧 Integration Steps

1. **Generate code** using the prompt
2. **Create files** in `lib/core/theme/`
3. **Update MaterialApp**:
   ```dart
   MaterialApp(
     theme: AppTheme.lightTheme,
     darkTheme: AppTheme.darkTheme,
     themeMode: ThemeMode.system,
   )
   ```
4. **Test** light and dark themes
5. **Customize** as needed

---

## 💡 Tips

1. **Start with Material 3 colors**: Use Material 3 color palette as base
2. **Ensure contrast**: Make sure text is readable on backgrounds
3. **Test both themes**: Always test light and dark modes
4. **Use semantic colors**: Use success, warning, error for consistency
5. **Keep it simple**: Start with essential colors, add more as needed

---

## 🎯 Minimal Prompt (Quick Start)

If you only have primary colors:

```
Create a Flutter Material 3 theme with:
- Primary color: #2196F3
- Secondary color: #FF9800
- Error color: #F44336

Generate light and dark themes automatically based on Material 3 color system.
Include AppThemeColors (ThemeExtension) and AppTheme classes.
```

---

## 📚 Color Resources

- **Material 3 Color System**: https://m3.material.io/styles/color/the-color-system/overview
- **Material Color Tool**: https://m2.material.io/design/color/the-color-system.html#tools-for-picking-colors
- **Color Contrast Checker**: https://webaim.org/resources/contrastchecker/

---

## 📄 JSON Template Usage

A JSON template file (`theme_colors_template.json`) is provided for easy color management.

### Using the JSON Template:

1. **Open** `theme_colors_template.json`
2. **Fill in** your colors in the JSON structure
3. **Reference** the JSON when filling the prompt template
4. **Copy** the filled prompt to your AI assistant

### Example JSON Structure:

```json
{
  "lightTheme": {
    "primary": "#2196F3",
    "secondary": "#FF9800",
    "error": "#F44336",
    ...
  },
  "darkTheme": {
    "primary": "#64B5F6",
    "secondary": "#FFB74D",
    "error": "#E57373",
    ...
  }
}
```

### Quick Prompt with JSON:

```
I have a JSON file with my app colors. Please generate Flutter theme classes based on this JSON:

[Paste your filled JSON here]

Generate:
1. app_theme_colors.dart - ThemeExtension class
2. app_theme.dart - ThemeData for light and dark themes

Use Material 3 design system.
```

---

**Happy Theming! 🎨**
