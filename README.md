# Full Screen Menu for Flutter

[![Pub Version](https://img.shields.io/pub/v/full_screen_menu?color=blueviolet)](https://pub.dev/packages/full_screen_menu)

<p align="center">
  <img src="https://raw.githubusercontent.com/yako-dev/flutter-full-screen-menu/master/assets/full_screen_menu_logo.png" height="400px">
</p>


## Installing:
In your pubspec.yaml
```yaml
dependencies:
  full_screen_menu: ^2.0.0
```
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
          icon: Icon(Icons.ac_unit, color: Colors.white),
          text: Text('Make colder'),
          gradient: orangeGradient,
          onTap: () => print('The weather is colder now');
        ),
        FSMenuItem(
          icon: Icon(Icons.wb_sunny, color: Colors.white),
          text: Text('Make hotter'),
          gradient: blueGradient,
          onTap: () => print('The weather is hotter now');
        ),
      ],
    );
```
<br>
<br>


## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details
