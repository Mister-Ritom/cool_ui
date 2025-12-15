# Changelog

All notable changes to this package will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project adheres to [Semantic Versioning](https://semver.org/).

## [1.0.1]

### Added

- New widget **`CoolHorizontalSliderSelector`**
  - A horizontally scrollable, center-aligned selection control.
  - Supports swipe and tap interactions with smooth snapping behavior.
  - The selected item is always visually centered.
  - Side items fade progressively using a directional opacity falloff.
  - Edge items are partially clipped with smooth gradient fading.
- New data model **`HorizontalSelectionItem`**
  - Represents a selectable item with:
    - optional `IconData`
    - optional `String` title
  - Items can render icon-only, text-only, or icon + text in a row.
- New selection callback typedef:
  ```dart
  typedef OnSelectCallback =
      void Function(int index, HorizontalSelectionItem item);
  ```

### Fixed

- CoolBadge.offset was previously ignored and had no visual effect.
- CoolBadge.position enum was not applied to layout and did not affect badge placement.
