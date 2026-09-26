# Full Screen Menu for Flutter

[![Pub Version](https://img.shields.io/pub/v/full_screen_menu?color=blueviolet)](https://pub.dev/packages/full_screen_menu)

<p align="center">
  <img src="https://raw.githubusercontent.com/yako-dev/flutter-full-screen-menu/master/assets/full_screen_menu_logo.png" height="400px">
</p>


## Installing:

Requirements: Flutter 3.47+ (the package uses [`material_ui`](https://pub.dev/packages/material_ui)).
On older Flutter versions, use `full_screen_menu: ^2.0.1`.

1. Add the dependency in your `pubspec.yaml` file.
```yaml
dependencies:
  full_screen_menu: ^3.1.0
```

2. Import the `full_screen_menu` package.
```dart
import 'package:full_screen_menu/full_screen_menu.dart';
```


## Basic Usage:
```dart
FullScreenMenu.show(
  context,
  items: [
    Image.asset('assets/image.png'),
    FSMenuItem(
      icon: const Icon(Icons.ac_unit, color: Colors.white),
      text: const Text('Make colder'),
      gradient: blueGradient,
      onTap: () => print('The weather is colder now'),
    ),
    FSMenuItem(
      icon: const Icon(Icons.wb_sunny, color: Colors.white),
      text: const Text('Make hotter'),
      gradient: orangeGradient,
      onTap: () => print('The weather is hotter now'),
    ),
  ],
);
```

Close the menu from code with `FullScreenMenu.hide()`, and check whether it is
open with `FullScreenMenu.isVisible`.

The Android back button and back gesture close the menu and keep the screen
open, with `MaterialApp` and `MaterialApp.router` (for example go_router), so you
don't need a `PopScope` for it. One you added for this in earlier versions still
works and can be removed. This applies to the screen (route) of the `context`
passed to `show`. A `PopScope` with `canPop: false` on that screen still gets
the back first, as with a `Drawer`: call `FullScreenMenu.hide()` from it to
close the menu. To handle back yourself, pass `closeMenuOnBackButton: false`.
<br>
<br>

## FullScreenMenu.show

Shows the menu over the whole screen. The items and the close button stay
inside the safe area.

### Parameters

| Parameter | Description | Required |
|--|--|--|
| BuildContext context | A context below the `Overlay` (for example below `MaterialApp`) | + |
| List&lt;Widget&gt; items | The menu items. Any widget works, not just `FSMenuItem` | - |
| Color backgroundColor | Background color, drawn at 85% opacity. Defaults to black in a dark theme and white otherwise | - |
| bool closeMenuOnBackgroundTap | Close the menu when the user taps outside the items. Defaults to `true` | - |
| bool closeMenuOnBackButton | Close the menu on the system back (Android back button or back gesture) instead of leaving the screen. Defaults to `true` | - |

<br>
<br>

## FSMenuItem

A round gradient icon with a label below it.

### Parameters

| Parameter | Description | Required |
|--|--|--|
| VoidCallback onTap | Called when the user taps the item | + |
| Text text | The label below the icon | - |
| Icon icon | The icon inside the circle | - |
| Gradient gradient | Fills the circle behind the icon. Defaults to `blueGreyGradient` | - |

Predefined gradients: `orangeGradient`, `blueGradient`, `deepPurpleGradient`,
`redGradient`, `greenGradient`, `lightBlueGradient`, `purpleGradient`,
`lightGreenGradient` and `blueGreyGradient`.

<br>
<br>

<!-- more-from-yako:start -->
## More from Yako

Other Flutter packages from the same team:

<table>
  <tr>
    <td align="center" valign="top" width="33%">
      <a href="https://pub.dev/packages/settings_ui"><img src="https://raw.githubusercontent.com/yako-dev/.github/main/tiles/settings_ui.gif" width="220" alt="Animated demo of the settings_ui Flutter package: an iOS-style settings screen with Appearance and General sections; turning on Dark mode switches the whole list to dark."></a><br>
      <a href="https://pub.dev/packages/settings_ui"><b>settings_ui</b></a><br>
      <sub>Settings screens that look native on every platform.</sub>
    </td>
    <td align="center" valign="top" width="33%">
      <a href="https://pub.dev/packages/badges"><img src="https://raw.githubusercontent.com/yako-dev/.github/main/tiles/badges.gif" width="220" alt="Animated demo of the badges Flutter package: a count badge on a cart icon goes from 1 to 4, a notification badge pops in, and a Twitter-style verified badge, a NEW label and an Instagram-shaped badge appear."></a><br>
      <a href="https://pub.dev/packages/badges"><b>badges</b></a><br>
      <sub>Badges for any widget: counters, dots, shapes and animations.</sub>
    </td>
    <td align="center" valign="top" width="33%">
      <a href="https://pub.dev/packages/yako_celebrations"><img src="https://raw.githubusercontent.com/yako-dev/.github/main/tiles/yako_celebrations.webp" width="220" alt="Animated demo of the yako_celebrations Flutter package: an epic celebration fills a dark screen with fireworks, flames, spinning coins, confetti and popping Yako logos under a LEVEL UP! title."></a><br>
      <a href="https://pub.dev/packages/yako_celebrations"><b>yako_celebrations</b></a><br>
      <sub>Full-screen celebrations in one line: confetti, coins, fireworks, flames.</sub>
    </td>
  </tr>
  <tr>
    <td align="center" valign="top" width="33%">
      <a href="https://pub.dev/packages/status_alert"><img src="https://raw.githubusercontent.com/yako-dev/.github/main/tiles/status_alert.gif" width="220" alt="Animated demo of the status_alert Flutter package: liking a song shows an Apple-style blurred Loved popup with an icon and a subtitle, which then fades away."></a><br>
      <a href="https://pub.dev/packages/status_alert"><b>status_alert</b></a><br>
      <sub>Apple-style status alerts that hide themselves.</sub>
    </td>
    <td align="center" valign="top" width="33%">
      <a href="https://pub.dev/packages/yako_theme_switch"><img src="https://raw.githubusercontent.com/yako-dev/.github/main/tiles/yako_theme_switch.gif" width="220" alt="Animated demo of the yako_theme_switch Flutter package: a toggle whose sun thumb rolls into a moon as the screen changes from light mode to dark mode."></a><br>
      <a href="https://pub.dev/packages/yako_theme_switch"><b>yako_theme_switch</b></a><br>
      <sub>An animated switch between light and dark themes.</sub>
    </td>
    <td align="center" valign="top" width="33%">
      <a href="https://pub.dev/packages/diagonal_decoration"><img src="https://raw.githubusercontent.com/yako-dev/.github/main/tiles/diagonal_decoration.png" width="220" alt="Screenshot of the diagonal_decoration Flutter package: one card filled with fine diagonal lines (DiagonalDecoration) and one with a curved line mesh (MatrixDecoration)."></a><br>
      <a href="https://pub.dev/packages/diagonal_decoration"><b>diagonal_decoration</b></a><br>
      <sub>Diagonal-line and mesh backgrounds for boxes.</sub>
    </td>
  </tr>
</table>
<!-- more-from-yako:end -->

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details
