## 1.0.0

### 🎉 Stable Release

- Introduced **cool_ui** as a complete, state-driven, animation-first UI framework
- Added two-color–derived **design system** that generates a full semantic color palette
- Implemented **CoolThemeExtension** for global theming and defaults
- Automatic **light/dark mode** adaptation
- Fully opted into **null safety**

### ✨ Core Widgets

- Layout: `CoolScaffold`, `CoolRow`, `CoolColumn`, `CoolStack`, `CoolGap`, `CoolDivider`
- Buttons: `CoolButton` (filled, outline, text), `CoolIconButton`, `CoolFloatingButton`
- Forms: `CoolTextField`
- Display: `CoolCard`, `CoolAvatar`, `CoolSkeleton`
- Navigation: `CoolBottomNavigationBar`, `CoolTabs`
- Overlays: `CoolDialog`, `CoolSheet`
- Data & Interaction: `CoolDataTable`, `CoolCollapsible`, `CoolSection`
- Advanced interactions: `CoolDraggable`, `CoolDraggableLayout`, `CoolSwipeAction`

### 🎭 Animation System

- State-based animations for idle, hover, pressed, focused, selected states
- Configurable animation curves, durations, and scale effects
- Minimum press duration to ensure visible interaction feedback

### 🎨 Styling & Customization

- Two-layer style resolution:
  - Global defaults via theme extension
  - Local widget-level overrides
- Fully customizable radius, colors, elevations, and animation configs
- Semantic color tokens exposed via context helpers

### 📦 Developer Experience

- Clean public API surface
- Fully documented example app
- Designed for composability and extensibility
