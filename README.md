# Full Screen Menu for Flutter

[![pub package](https://img.shields.io/badge/pub-0.1.1-blueviolet.svg)](https://pub.dev/packages/full_screen_menu)

<p align="center">
  <img src="https://raw.githubusercontent.com/yako-dev/flutter-full-screen-menu/master/assets/full_screen_menu_logo.png" height="400px">
</p>


## Installing:
In your pubspec.yaml
```yaml
dependencies:
  full_screen_menu: ^0.1.1
```
```dart
import 'package:full_screen_menu/full_screen_menu.dart';
```


## Basic Usage:
```dart
    FullScreenMenu.show(
      context,
      items: [
        FSMenuItem(
          icon: Icon(Icons.ac_unit, color: Colors.white),
          text: Text('Make colder'),
          onTap: () => print('Cool package check');
        ),
        FSMenuItem(
          icon: Icon(Icons.wb_sunny, color: Colors.white),
          text: Text('Make hotter'),
        ),
      ],
    );
```
<br>
<br>


## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details
