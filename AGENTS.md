# AGENTS.md

This file provides guidance to coding agents when working with code in this repository.

## Commands

```bash
# Get dependencies (also resolves example/)
flutter pub get

# Run tests
flutter test

# Run a single test file
flutter test test/regression_test.dart

# Analyze / lint (CI runs exactly this)
flutter analyze lib/ test/ example/

# Format (CI enforces this — run before committing)
dart format .

# Run the example app
cd example && flutter run
```

## Architecture

This is a Flutter package (`full_screen_menu`) that renders a full-screen overlay menu using Flutter's `Overlay` API.

**Entry point:** `lib/full_screen_menu.dart` — re-exports the three public symbols: `FullScreenMenu`, `FSMenuItem`, and the gradient constants.

**Display mechanism:** `FullScreenMenuUtil` (`lib/src/utils/full_screen_menu_util.dart`) holds global `OverlayState` and `OverlayEntry` singletons. `isVisible` is only true while that overlay is still mounted. `FullScreenMenu.show()` inserts an `OverlayEntry` into the current `Overlay`; `hide()` reverses the animation, waits 200 ms, then calls `dismiss()` — but only if the entry it started hiding is still the current one (so a stale hide never removes a newer menu). `show()` during a `hide()` removes the closing menu immediately and opens the new one.

**Animation:** `FullScreenMenuBaseWidget` (`lib/src/widgets/full_screen_menu_base_widget.dart`) owns the `AnimationController`. On show it runs a combined `ScaleTransition` (0.9→1.0) + `FadeTransition` (0→1) over 200 ms. `FullScreenMenu` keeps a reference to the current controller (passed via callback, reset on every `show()`). The close button ignores repeat presses and skips `onHide` once the widget is unmounted.

**Layout:** the background (color at alpha 217 ≈ 85%, blur) covers the whole screen; a `SafeArea` inside it keeps the items and close button clear of the status bar and home indicator.

**Background color:** `backgroundColor` if given, otherwise black in a dark `Theme` and white otherwise.

**Items:** `FSMenuItem` (`lib/src/widgets/fs_menu_item.dart`) renders a circular gradient icon + label in a `Column`; its whole box is tappable (`HitTestBehavior.opaque`). Items are laid out in a `Wrap` with `spacing: 50` and `runSpacing: 40`. Any `Widget` can be passed as an item, not just `FSMenuItem`.

**Predefined gradients:** `lib/src/models/gradients.dart` exports named `LinearGradient` constants (`orangeGradient`, `blueGradient`, `deepPurpleGradient`, etc.) for use with `FSMenuItem.gradient`.

## Release

Bump `version` in `pubspec.yaml`, add a CHANGELOG entry, then push a matching tag (`git tag vX.Y.Z && git push origin vX.Y.Z`). `.github/workflows/publish.yml` tests and publishes to pub.dev via OIDC.
