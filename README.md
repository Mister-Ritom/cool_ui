# cooler_ui

A state-driven, animation-first Flutter UI framework that derives an entire visual language from two colors supplied by the user.

## ✨ Features

- **🎨 Two-Color Design System**: Generate a complete color palette from just primary and secondary colors
- **🎭 State-Driven Animations**: Every interaction state (idle, hover, pressed, focused, selected) has smooth, configurable animations
- **🌓 Full Theme Support**: Automatic light/dark mode with dynamic color adaptation
- **🎯 Two-Layer Customization**: Global defaults via Theme Extension + local overrides via widget styles
- **⚡ Interaction-First**: Minimum press duration ensures every tap is visually perceptible
- **🎪 Comprehensive Widget Set**: Buttons, cards, text fields, navigation, overlays, and more
- **🔧 Fully Customizable**: Every visual property and animation is configurable

## 📦 Installation

Add `cooler_ui` to your `pubspec.yaml`:

```yaml
dependencies:
  cooler_ui: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Setup Theme Extension

```dart
import 'package:flutter/material.dart';
import 'package:cooler_ui/cooler_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create theme extension with your brand colors
    final coolTheme = CoolThemeExtension(
      primaryColor: const Color(0xFF6366F1),   // Your primary color
      secondaryColor: const Color(0xFFEC4899),  // Your secondary color
      themeMode: ThemeMode.system,              // or ThemeMode.light/dark
    );

    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        useMaterial3: true,
        extensions: [coolTheme],
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        extensions: [coolTheme],
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
```

### 2. Use Widgets

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CoolScaffold(
      body: CoolColumn(
        children: [
          // Buttons
          CoolButton.filled(
            label: 'Primary Action',
            onPressed: () => print('Pressed!'),
          ),

          CoolButton.outline(
            label: 'Secondary',
            onPressed: () {},
          ),

          // Cards
          CoolCard(
            child: Text('Card content'),
          ),

          // Text Field
          CoolTextField(
            hintText: 'Enter text',
            onChanged: (value) => print(value),
          ),
        ],
      ),
    );
  }
}
```

## 🎨 Core Concepts

### Theme Extension

The `CoolThemeExtension` is the heart of the framework. It:

- Generates a complete color system from your two colors
- Provides default styles for all widgets
- Handles light/dark mode automatically
- Allows global customization of animations, radius, and more

### Style System

Every widget supports two customization layers:

1. **Global Defaults** (via Theme Extension):

```dart
final coolTheme = CoolThemeExtension(
  primaryColor: Colors.blue,
  secondaryColor: Colors.purple,
  themeMode: ThemeMode.system,
  defaultRadius: 12.0,  // Global radius
  defaultButtonStyle: CoolButtonStyle(
    radius: 16.0,
    animationConfig: customAnimationConfig,
  ),
);
```

2. **Local Overrides** (via widget style parameter):

```dart
CoolButton.filled(
  label: 'Custom',
  style: CoolButtonStyle(
    radius: 20.0,  // Override global default
    backgroundColor: Colors.red,
  ),
  onPressed: () {},
)
```

### Style Resolution Order

For every property, the framework resolves values in this order:

1. Widget `style` parameter
2. Theme Extension default style
3. Internal fallback (matches current behavior)

## 📚 Widget Examples

### Layout Utilities

```dart
// Gap for spacing
CoolColumn(
  children: [
    Text('Item 1'),
    CoolGap(size: 16),  // Vertical gap
    Text('Item 2'),
    CoolGap.horizontal(size: 20),  // Horizontal gap
  ],
)
```

### Collapsible Content

```dart
// Basic collapsible
CoolCollapsible(
  isExpanded: _isExpanded,
  expandedChild: Text('Expanded content'),
)

// Section with header
CoolSection(
  title: 'Settings',
  subtitle: 'Manage preferences',
  initialExpanded: false,
  child: Text('Section content'),
)
```

### Data Tables

```dart
CoolDataTable(
  columns: [
    CoolDataTableColumn(label: 'Name', width: 100),
    CoolDataTableColumn(label: 'Age', width: 60),
  ],
  rows: [
    CoolDataTableRow(
      cells: [Text('Alice'), Text('25')],
      isSelected: true,
    ),
  ],
  onRowTap: (index) => print('Row $index tapped'),
)
```

### Drag & Drop

```dart
// Draggable item
CoolDraggable(
  data: 'Item data',
  onDragStart: () => print('Drag started'),
  child: CoolCard(child: Text('Drag me')),
)

// Draggable layout
CoolDraggableLayout(
  children: [/* draggable items */],
  onReorder: (index) => print('Reordered'),
)
```

### Swipe Actions

```dart
CoolSwipeAction(
  leftActions: [
    CoolSwipeActionItem(
      label: 'Edit',
      icon: Icons.edit,
      onTap: () => print('Edit'),
    ),
  ],
  rightActions: [
    CoolSwipeActionItem(
      label: 'Delete',
      icon: Icons.delete,
      onTap: () => print('Delete'),
    ),
  ],
  child: CoolCard(child: Text('Swipe me')),
)
```

### Skeleton Loading

```dart
// Text skeleton
CoolSkeleton.text(width: 200, height: 16)

// Avatar skeleton
CoolSkeleton.avatar(width: 40, height: 40)

// Card skeleton
CoolSkeleton.card(width: double.infinity, height: 100)
```

### Buttons

```dart
// Filled button
CoolButton.filled(
  label: 'Primary',
  onPressed: () {},
)

// Outline button
CoolButton.outline(
  label: 'Secondary',
  onPressed: () {},
)

// Text button
CoolButton.text(
  label: 'Tertiary',
  onPressed: () {},
)

// Icon button
CoolIconButton(
  icon: Icons.favorite,
  onPressed: () {},
)

// Floating action button
CoolFloatingButton(
  icon: Icons.add,
  onPressed: () {},
)
```

### Cards

```dart
// Basic card
CoolCard(
  child: Text('Content'),
)

// Card with elevation
CoolCard(
  elevation: 2,
  child: Text('Elevated'),
)

// Tappable card
CoolCard(
  onTap: () => print('Tapped'),
  child: Text('Click me'),
)
```

### Forms

```dart
CoolTextField(
  hintText: 'Enter email',
  labelText: 'Email',
  prefixIcon: Icon(Icons.email),
  onChanged: (value) {},
)
```

### Navigation

```dart
CoolBottomNavigationBar(
  items: [
    CoolBottomNavItem(icon: Icons.home, label: 'Home'),
    CoolBottomNavItem(icon: Icons.search, label: 'Search'),
    CoolBottomNavItem(icon: Icons.person, label: 'Profile'),
  ],
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
)
```

### Overlays

```dart
// Dialog
CoolDialog.show(
  context: context,
  title: 'Confirm',
  content: Text('Are you sure?'),
  actions: [
    CoolButton.text(label: 'Cancel', onPressed: () {}),
    CoolButton.filled(label: 'Confirm', onPressed: () {}),
  ],
)

// Bottom sheet
CoolSheet.show(
  context: context,
  child: Text('Sheet content'),
)
```

### Selectors

```dart
CoolHorizontalSliderSelector(
  items: [
    HorizontalSelectionItem(icon: Icons.home, title: 'Home'),
    HorizontalSelectionItem(icon: Icons.search, title: 'Search'),
    HorizontalSelectionItem(icon: Icons.notifications, title: 'Alerts'),
    HorizontalSelectionItem(icon: Icons.person, title: 'Profile'),
  ],
)
```

## 🎛️ Customization

### Custom Animation Config

```dart
final customConfig = CoolAnimationConfig(
  pressed: CoolStateAnimationConfig(
    scale: 0.95,
    duration: Duration(milliseconds: 200),
  ),
  hover: CoolStateAnimationConfig(
    scale: 1.05,
  ),
  pressCurve: Curves.easeOut,
  releaseCurve: Curves.easeIn,
  minPressDuration: Duration(milliseconds: 150),
);

// Apply globally
final coolTheme = CoolThemeExtension(
  primaryColor: Colors.blue,
  secondaryColor: Colors.purple,
  themeMode: ThemeMode.system,
  defaultButtonStyle: CoolButtonStyle(
    animationConfig: customConfig,
  ),
);

// Or per widget
CoolButton.filled(
  label: 'Custom',
  style: CoolButtonStyle(animationConfig: customConfig),
  onPressed: () {},
)
```

### Custom Colors

```dart
// Access color system
final colors = context.coolColors;

// Use semantic tokens
Container(
  color: colors?.resolve(CoolColorToken.primary),
  child: Text(
    'Text',
    style: TextStyle(
      color: colors?.resolve(CoolColorToken.onPrimary),
    ),
  ),
)
```

## 📖 Available Widgets

### Layout

- `CoolScaffold` - Scaffold with theme integration
- `CoolLayout` - Container with blur + tint surface
- `CoolRow` / `CoolColumn` - Layout widgets with spacing
- `CoolStack` - Stack with theme support
- `CoolDivider` - Themed divider
- `CoolGap` - Spacing utility (vertical or horizontal)

### Buttons

- `CoolButton` - Filled, outline, and text variants
- `CoolIconButton` - Icon-only button
- `CoolFloatingButton` - Floating action button

### Forms

- `CoolTextField` - Text input with state animations

### Data Display

- `CoolCard` - Card with elevation and blur support
- `CoolAvatar` - Avatar with fallback colors
- `CoolDataTable` - Structured data table with row selection
- `CoolCollapsible` - Base collapsible widget with animated expand/collapse
- `CoolSection` / `CoolSectionHeader` - Collapsible sections with headers

### Navigation

- `CoolBottomNavigationBar` - Bottom navigation with animations
- `CoolTabs` - Tab bar with state management

### Feedback

- `CoolProgressIndicator` - Progress indicator
- `CoolAlert` - Alert/notification widget
- `CoolSkeleton` - Skeleton loading widget with shimmer animation

### Overlays

- `CoolDialog` - Modal dialog
- `CoolSheet` - Bottom sheet

### Menus

- `CoolMenuButton` - Three-dot menu button
- `CoolPopupMenu` - Anchored popup menu

### Interactions

- `CoolDraggable` - Draggable item with animated feedback
- `CoolDraggableLayout` - Container for drag-and-drop interactions
- `CoolSwipeAction` - Swipe-to-reveal action buttons

### Selectors

- `CoolHorizontalSliderSelector` - Centered horizontal selector with swipe and tap support

## 🎯 Philosophy

**cooler_ui** is not just a widget pack—it's a complete design system that:

- **Prioritizes Interaction**: Every tap, hover, and press is visually meaningful
- **Derives from Colors**: Two colors generate an entire visual language
- **Animates by Default**: State changes are always smooth and perceptible
- **Customizes at Every Level**: Global defaults + local overrides = full control
- **Respects Theme**: Light/dark mode works automatically and correctly

## 📝 Requirements

- Flutter SDK: `>=3.3.0`
- Dart SDK: `^3.9.2`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

MIT License

---

**Built with ❤️ for Flutter developers who care about interaction and design.**
