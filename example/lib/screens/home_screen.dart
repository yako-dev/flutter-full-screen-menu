import 'package:example/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (FullScreenMenu.isVisible) {
          FullScreenMenu.hide();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Full screen menu demo')),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/google_maps.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        bottomNavigationBar: FABBottomAppBar(
          color: Colors.grey,
          selectedColor: Theme.of(context).colorScheme.secondary,
          notchedShape: const CircularNotchedRectangle(),
          onTabSelected: (index) {},
          items: [
            FABBottomAppBarItem(
                iconData: Icons.format_list_bulleted, text: 'lists'),
            FABBottomAppBarItem(iconData: Icons.people, text: 'people'),
            FABBottomAppBarItem(iconData: Icons.attach_money, text: 'money'),
            FABBottomAppBarItem(iconData: Icons.more_horiz, text: 'dots'),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showFullScreenMenu(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showFullScreenMenu(BuildContext context) {
    FullScreenMenu.show(
      context,
      backgroundColor: Colors.black,
      closeMenuOnBackgroundTap: true,
      items: [
        FSMenuItem(
          icon: const Icon(Icons.ac_unit, color: Colors.white),
          text: const Text(
              'Make colder', style: TextStyle(color: Colors.white)),
          gradient: blueGradient,
          onTap: () => debugPrint('Make colder'),
        ),
        FSMenuItem(
          icon: const Icon(Icons.wb_sunny, color: Colors.white),
          text: const Text(
              'Make hotter', style: TextStyle(color: Colors.white)),
          gradient: redGradient,
          onTap: () => debugPrint('Make hotter'),
        ),
        FSMenuItem(
          icon: const Icon(Icons.flash_on, color: Colors.white),
          text: const Text('Lightning', style: TextStyle(color: Colors.white)),
          gradient: orangeGradient,
          onTap: () => debugPrint('Lightning'),
        ),
        FSMenuItem(
          icon: const Icon(Icons.grain, color: Colors.white),
          text: const Text(
              'Give a rain', style: TextStyle(color: Colors.white)),
          gradient: deepPurpleGradient,
          onTap: () => debugPrint('Give a rain'),
        ),
        FSMenuItem(
          icon: const Icon(Icons.add, color: Colors.white),
          text: const Text('Add to EU', style: TextStyle(color: Colors.white)),
          onTap: () => debugPrint('Add to EU'),
        ),
      ],
    );
  }
}
