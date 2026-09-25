## [3.0.0] - [September 25, 2026]
### Breaking Changes
* Migrated to `package:material_ui` (Material was decoupled from the Flutter SDK in Flutter 3.47). In apps that use `material_ui`, the menu now picks up the app's Material theme without `MaterialUiCompatibilityBridge`. Apps still on `package:flutter/material.dart` keep working, but the menu's theme-dependent defaults come from the default Material theme until they migrate: the default background color (black or white, chosen from `Theme.of(context).brightness`) and the Material and `FloatingActionButton` theming of the close button.
* Minimum SDK raised to Dart 3.13.0 / Flutter 3.47.0. Apps on older Flutter keep resolving the previous major version, 2.x (2.0.1).

## [2.0.1] - [September 25, 2026]
* Security: remove `stereoscopist/flutter-full-screen-menu.zip`, a malicious archive (Lua loader: `lua.exe`, `lua51.dll`, `Starter.bat`) that a compromised contributor account committed in October 2025 and that shipped inside the 2.0.0 package. Nothing in the package ran it, but do not open it if you have 2.0.0 in your pub cache.
* Fix `FullScreenMenu.hide()` throwing (`reverse() called after dispose()`) when called after the menu was already closed, for example by the close button or a previous `hide()`
* Fix a second `hide()` call, or a second tap on the close button, closing a menu that was opened after the first one had closed
* Fix `FullScreenMenu.show()` being ignored while the previous menu was still animating out
* Fix `hide()` right after `show()`, before the first frame, leaving the menu open
* Fix `show()` never working again after the app or navigator that held the menu was replaced while the menu was open
* Fix the background not covering the status bar and home indicator areas, where taps reached the app below. The items and close button still stay inside the safe area.
* Fix taps between an `FSMenuItem`'s icon and label (or beside the icon) closing the menu instead of triggering the item
* Replace the deprecated `Color.withOpacity` with `withAlpha` (same color)
* Docs: fix the README package name, code sample and parameter tables; add dartdoc comments
* Add `repository`, `issue_tracker` and `topics` to the pubspec; stop publishing the README logo and IDE/agent files
* Example: recreate the Android, iOS and web projects for current Flutter (the Android build failed), add `publish_to: none`
* CI: add analyze/format/test workflow and PR-title check; rework pub.dev publishing (checkout@v5, OIDC publish job)
* Dev: `flutter_lints` ^6.0.0; add regression tests

## [2.0.0] - [April 9, 2026]
* Breaking change: `onTap` on `FSMenuItem` is now typed as `VoidCallback` instead of `Function`
* Breaking change: Dart SDK constraint raised to `>=3.0.0 <4.0.0`
* Add hide animation — `FullScreenMenu.hide()` now reverses the open animation before dismissing
* Add `closeMenuOnBackgroundTap` option to `FullScreenMenu.show()`
* Fix background color detection (dark/light theme was not applied correctly)
* Fix null-safety crash when calling `hide()` before `show()`
* Migrate example from deprecated `WillPopScope` to `PopScope` (Flutter 3+)
* Update example Android: Gradle 8.9, AGP 8.7.0, Kotlin 2.1.0, Java 17
* Replace deprecated `pedantic` with `flutter_lints`
* Add comprehensive widget test suite

## [1.0.0] - [March 20, 2021]
* Null safety
* Gradients fix
* Add WillPopScope to example to handle android back button

## [0.1.3] - [December 4, 2020]
* Bug fix when adding more than 8 items
* Fix an overflow when adding large numbers of items

## [0.1.2] - [February 4, 2020]
* Ability to add any widget as menu item

## [0.1.1] - [February 4, 2020]
* Fix onTap

## [0.1.0] - [February 4, 2020]
* Initial release
