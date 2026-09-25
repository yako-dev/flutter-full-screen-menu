import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Makes the system back (Android back button and back gesture) close the menu
/// instead of popping the route it was opened from or closing the app.
///
/// The menu is an [OverlayEntry], not a route, so it cannot use a [PopScope].
/// A [WidgetsBindingObserver] is asked too late: the binding asks observers in
/// registration order, and [WidgetsApp] (or a Router's
/// [RootBackButtonDispatcher]) registered first and pops a pushed route before
/// a later observer is asked. The route the menu was opened from is asked
/// first, though: [WidgetsApp] and [PopNavigatorRouterDelegateMixin] both call
/// [NavigatorState.maybePop], which pops the route's newest
/// [LocalHistoryEntry] instead of the route. Scaffold's drawer closes on back
/// the same way. While the entry exists the route also turns off its predictive
/// back transition, so a back gesture ends in the same pop.
///
/// Adding a local history entry does not tell the platform that the app now
/// handles back. On Android with predictive back (the default for apps that
/// target API 36) a back on the first route would still close the app. So the
/// handler is also a [PopEntry] that never blocks a pop: registering and
/// unregistering it makes the route send a [NavigationNotification], and the
/// [Navigator] then reports whether it can pop, counting the local history
/// entry.
///
/// A [PopScope] with `canPop: false` on the same route still gets the back
/// first, as with the drawer.
class MenuBackHandler extends PopEntry<Object?> {
  MenuBackHandler._(this._route, this._onBack);

  /// Starts handling back for the route of [context]. [onBack] is called when
  /// a back closes the menu. Returns null when [context] is not in a route.
  static MenuBackHandler? register(BuildContext context, VoidCallback onBack) {
    final route = ModalRoute.of(context);
    if (route == null || !route.isActive) return null;
    final handler = MenuBackHandler._(route, onBack);
    route.addLocalHistoryEntry(handler._entry);
    route.registerPopEntry(handler);
    return handler;
  }

  final ModalRoute<Object?> _route;
  final VoidCallback _onBack;
  final ValueNotifier<bool> _canPop = ValueNotifier<bool>(true);
  late final LocalHistoryEntry _entry = LocalHistoryEntry(
    // Keep the AppBar below the menu from showing a close button.
    impliesAppBarDismissal: false,
    onRemove: _handleBack,
  );
  bool _removed = false;

  @override
  ValueListenable<bool> get canPopNotifier => _canPop;

  /// Stops handling back, without calling onBack.
  void remove() {
    if (_removed) return;
    _removed = true;
    // A route that is gone or on its way out needs no cleanup.
    if (_route.isActive) _entry.remove();
    _unregister();
  }

  // Called when back popped the local history entry.
  void _handleBack() {
    if (_removed) return;
    _removed = true;
    _unregister();
    _onBack();
  }

  void _unregister() {
    // In a microtask: remove() can run inside the route's loop over its pop
    // entries (an app PopScope that hides the menu), and _handleBack runs
    // while the route is being popped, when it would not report the change.
    scheduleMicrotask(() {
      _route.unregisterPopEntry(this);
      _canPop.dispose();
    });
  }
}
