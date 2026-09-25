import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_screen_menu/full_screen_menu.dart';
import 'package:full_screen_menu/src/utils/full_screen_menu_util.dart';
import 'package:material_ui/material_ui.dart';

/// Longer than the 200 ms closing animation.
const _closed = Duration(milliseconds: 300);

/// Platform calls: `SystemNavigator.pop` (the app would close) and
/// `SystemNavigator.setFrameworkHandlesBack`.
final _platformCalls = <MethodCall>[];

int get _appCloses =>
    _platformCalls.where((call) => call.method == 'SystemNavigator.pop').length;

/// What the app last told Android about handling back itself. Without it, back
/// on the first route skips Flutter when predictive back is on.
bool? get _frameworkHandlesBack =>
    _platformCalls
            .lastWhere(
              (call) =>
                  call.method == 'SystemNavigator.setFrameworkHandlesBack',
              orElse: () => const MethodCall('none'),
            )
            .arguments
        as bool?;

/// A screen that stores its context under [name], so tests can open the menu
/// from it.
final _contexts = <String, BuildContext>{};

class _Screen extends StatelessWidget {
  const _Screen(this.name, {this.wrap});

  final String name;
  final Widget Function(Widget screen)? wrap;

  @override
  Widget build(BuildContext context) {
    _contexts[name] = context;
    final screen = Scaffold(
      appBar: AppBar(title: Text('$name title')),
      body: Center(child: Text('$name body')),
    );
    return wrap?.call(screen) ?? screen;
  }
}

Widget _app({Widget Function(Widget screen)? wrap}) =>
    MaterialApp(home: _Screen('home', wrap: wrap));

Future<void> _push(WidgetTester tester, String name) async {
  Navigator.of(_contexts['home']!)
      .push(MaterialPageRoute<void>(builder: (_) => _Screen(name)));
  await tester.pumpAndSettle();
}

Future<void> _show(
  WidgetTester tester,
  String screen, {
  bool closeMenuOnBackButton = true,
  List<Widget> items = const [Text('menu')],
}) async {
  FullScreenMenu.show(
    _contexts[screen]!,
    closeMenuOnBackButton: closeMenuOnBackButton,
    items: items,
  );
  await tester.pumpAndSettle();
  expect(FullScreenMenu.isVisible, isTrue);
}

/// System back, as sent by the Android back button.
Future<bool> _back(WidgetTester tester) async {
  final handled = await tester.binding.handlePopRoute();
  await tester.pump(_closed);
  await tester.pumpAndSettle();
  return handled;
}

/// A complete Android predictive back gesture from the left edge.
Future<void> _backGesture(WidgetTester tester) async {
  Future<void> send(String method, [Map<String, Object?>? event]) {
    return tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/backgesture',
      const StandardMethodCodec().encodeMethodCall(MethodCall(method, event)),
      (_) {},
    );
  }

  Map<String, Object?> event(double progress) => {
    'touchOffset': [5.0, 300.0],
    'progress': progress,
    'swipeEdge': 0,
  };

  await send('startBackGesture', event(0));
  await tester.pump();
  await send('updateBackGestureProgress', event(0.5));
  await tester.pump();
  await send('commitBackGesture');
  await tester.pump(_closed);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    _platformCalls.clear();
    _contexts.clear();
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          _platformCalls.add(call);
          return null;
        });
    // WidgetsApp only reports setFrameworkHandlesBack once the app is resumed.
    await TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
          'flutter/lifecycle',
          const StringCodec().encodeMessage(
            AppLifecycleState.resumed.toString(),
          ),
          (_) {},
        );
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
    FullScreenMenuUtil.isVisible = false;
    FullScreenMenuUtil.entry = null;
    FullScreenMenuUtil.state = null;
  });

  group('MaterialApp, first route', () {
    testWidgets('back closes the menu and keeps the app open', (tester) async {
      await tester.pumpWidget(_app());
      await _show(tester, 'home');

      expect(await _back(tester), isTrue);
      expect(FullScreenMenu.isVisible, isFalse);
      expect(find.text('menu'), findsNothing);
      expect(find.text('home body'), findsOneWidget);
      expect(_appCloses, 0);
    });

    testWidgets('tells Android that Flutter handles back while it is open', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();
      expect(_frameworkHandlesBack, isNot(isTrue));

      await _show(tester, 'home');
      expect(_frameworkHandlesBack, isTrue);

      await _back(tester);
      expect(_frameworkHandlesBack, isFalse);

      await _show(tester, 'home');
      expect(_frameworkHandlesBack, isTrue);
      FullScreenMenu.hide();
      await tester.pump(_closed);
      await tester.pumpAndSettle();
      expect(_frameworkHandlesBack, isFalse);
    });

    testWidgets('the app bar below the menu does not get a close button', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await _show(tester, 'home');
      expect(find.byType(CloseButton), findsNothing);
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('back with the menu closed closes the app, as before', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      expect(await _back(tester), isFalse);
      expect(_appCloses, 1);

      // Also after a menu was opened and closed.
      await _show(tester, 'home');
      FullScreenMenu.hide();
      await tester.pump(_closed);
      expect(await _back(tester), isFalse);
      expect(_appCloses, 2);
    });

    testWidgets('a predictive back gesture closes the menu', (tester) async {
      await tester.pumpWidget(_app());
      await _show(tester, 'home');

      await _backGesture(tester);
      expect(FullScreenMenu.isVisible, isFalse);
      expect(find.text('home body'), findsOneWidget);
      expect(_appCloses, 0);
    });
  });

  group('MaterialApp, pushed route', () {
    testWidgets('back closes the menu, the next back pops the route', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await _push(tester, 'second');
      await _show(tester, 'second');

      expect(await _back(tester), isTrue);
      expect(FullScreenMenu.isVisible, isFalse);
      expect(find.text('second body'), findsOneWidget);

      expect(await _back(tester), isTrue);
      expect(find.text('second body'), findsNothing);
      expect(find.text('home body'), findsOneWidget);
      expect(_appCloses, 0);
    });

    testWidgets('a predictive back gesture closes the menu, not the route', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await _push(tester, 'second');
      await _show(tester, 'second');

      await _backGesture(tester);
      expect(FullScreenMenu.isVisible, isFalse);
      expect(find.text('second body'), findsOneWidget);

      await _backGesture(tester);
      expect(find.text('second body'), findsNothing);
      expect(find.text('home body'), findsOneWidget);
    });

    testWidgets('Navigator.pop right after hide() pops the route', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await _push(tester, 'second');
      await _show(
        tester,
        'second',
        items: [
          FSMenuItem(
            text: const Text('leave'),
            onTap: () {
              FullScreenMenu.hide();
              Navigator.of(_contexts['second']!).pop();
            },
          ),
        ],
      );

      await tester.tap(find.text('leave'));
      await tester.pump(_closed);
      await tester.pumpAndSettle();
      expect(FullScreenMenu.isVisible, isFalse);
      expect(find.text('second body'), findsNothing);
      expect(find.text('home body'), findsOneWidget);
    });
  });

  testWidgets('MaterialApp.router: back closes the menu, then pops the page', (
    tester,
  ) async {
    final delegate = _RouterDelegate();
    await tester.pumpWidget(
      MaterialApp.router(
        // Like go_router's config: back goes through the Router.
        routerConfig: RouterConfig(
          routerDelegate: delegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
    delegate.push('second');
    await tester.pumpAndSettle();
    await _show(tester, 'second');

    expect(await _back(tester), isTrue);
    expect(FullScreenMenu.isVisible, isFalse);
    expect(find.text('second body'), findsOneWidget);

    expect(await _back(tester), isTrue);
    expect(find.text('second body'), findsNothing);
    expect(find.text('home body'), findsOneWidget);

    await _show(tester, 'home');
    expect(await _back(tester), isTrue);
    expect(FullScreenMenu.isVisible, isFalse);
    expect(find.text('home body'), findsOneWidget);
    expect(_appCloses, 0);
  });

  group('closeMenuOnBackButton: false', () {
    testWidgets('back behaves as if the menu was not there', (tester) async {
      await tester.pumpWidget(_app());
      await _push(tester, 'second');
      await _show(tester, 'second', closeMenuOnBackButton: false);

      await _back(tester);
      expect(find.text('second body'), findsNothing);
      expect(FullScreenMenu.isVisible, isTrue);
    });

    testWidgets('on the first route back closes the app', (tester) async {
      await tester.pumpWidget(_app());
      await _show(tester, 'home', closeMenuOnBackButton: false);

      expect(await _back(tester), isFalse);
      expect(_appCloses, 1);
    });
  });

  testWidgets('a PopScope that hides the menu keeps working', (tester) async {
    var popScopeCalls = 0;
    await tester.pumpWidget(
      _app(
        // The workaround the README used to recommend.
        wrap: (screen) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            popScopeCalls++;
            if (!didPop && FullScreenMenu.isVisible) FullScreenMenu.hide();
          },
          child: screen,
        ),
      ),
    );
    await _show(tester, 'home');

    expect(await _back(tester), isTrue);
    expect(popScopeCalls, 1);
    expect(FullScreenMenu.isVisible, isFalse);
    expect(tester.takeException(), isNull);
    expect(_appCloses, 0);
  });

  testWidgets('hide() after back does not throw', (tester) async {
    await tester.pumpWidget(_app());
    await _show(tester, 'home');
    await tester.binding.handlePopRoute();
    FullScreenMenu.hide();
    await tester.pump(_closed);
    await tester.pumpAndSettle();
    FullScreenMenu.hide();
    await tester.pump(_closed);
    expect(FullScreenMenu.isVisible, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the menu opens again after back, and back closes it again', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await _show(tester, 'home');
    await _back(tester);

    await _show(tester, 'home', items: const [Text('again')]);
    expect(find.text('again'), findsOneWidget);
    expect(await _back(tester), isTrue);
    expect(FullScreenMenu.isVisible, isFalse);
    expect(_appCloses, 0);
  });

  testWidgets('back after the close button closes the app, as before', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await _show(tester, 'home');
    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(_closed);
    await tester.pumpAndSettle();
    expect(FullScreenMenu.isVisible, isFalse);

    expect(await _back(tester), isFalse);
    expect(_appCloses, 1);
  });

  testWidgets('show() works after the app that held the menu is replaced', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await _show(tester, 'home');
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app());

    await _show(tester, 'home');
    expect(await _back(tester), isTrue);
    expect(FullScreenMenu.isVisible, isFalse);
    expect(tester.takeException(), isNull);
  });
}

/// A minimal Router setup: a stack of named pages.
class _RouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  final _pages = <Page<void>>[_page('home')];

  static Page<void> _page(String name) =>
      MaterialPage<void>(key: ValueKey(name), child: _Screen(name));

  void push(String name) {
    _pages.add(_page(name));
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onDidRemovePage: (page) {
        _pages.remove(page);
        notifyListeners();
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}
