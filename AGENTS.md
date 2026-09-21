# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run tests
flutter test

# Run a single test file
flutter test test/some_test.dart

# Analyze / lint
flutter analyze

# Run the example app
cd example && flutter run
```

## Architecture

This is a Flutter package (`full_screen_menu`) that renders a full-screen overlay menu using Flutter's `Overlay` API.

**Entry point:** `lib/full_screen_menu.dart` — re-exports the three public symbols: `FullScreenMenu`, `FSMenuItem`, and the gradient constants.

**Display mechanism:** `FullScreenMenuUtil` (`lib/src/utils/full_screen_menu_util.dart`) holds global `OverlayState` and `OverlayEntry` singletons. `FullScreenMenu.show()` inserts an `OverlayEntry` into the current `Overlay`; `hide()` reverses the animation then calls `dismiss()` to remove it.

**Animation:** `FullScreenMenuBaseWidget` (`lib/src/widgets/full_screen_menu_base_widget.dart`) owns the `AnimationController`. On show it runs a combined `ScaleTransition` (0.9→1.0) + `FadeTransition` (0→1) over 200 ms. On hide, `FullScreenMenu` holds a reference to the controller (passed via callback) and calls `.reverse()` before dismissing.

**Background color:** `getBackgroundColor()` in `FullScreenMenuBaseWidget` has a known bug (marked `// TODO not working`) — theme detection via `widget.context` does not function correctly.

**Items:** `FSMenuItem` (`lib/src/widgets/fs_menu_item.dart`) renders a circular gradient icon + label in a `Column`. Items are laid out in a `Wrap` with `spacing: 50` and `runSpacing: 40`. Any `Widget` can be passed as an item, not just `FSMenuItem`.

**Predefined gradients:** `lib/src/models/gradients.dart` exports named `LinearGradient` constants (`orangeGradient`, `blueGradient`, `deepPurpleGradient`, etc.) for use with `FSMenuItem.gradient`.
