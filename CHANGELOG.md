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
