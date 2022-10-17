import 'package:example/fab_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_menu/full_screen_menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (FullScreenMenu.isVisible) {
          FullScreenMenu.hide();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Full screen menu demo')),
        body: Image.asset(
          'assets/google_maps.png',
          width: 700,
          fit: BoxFit.fitWidth,
        ),
        bottomNavigationBar: FABBottomAppBar(
          color: Colors.grey,
          selectedColor: Theme.of(context).colorScheme.secondary,
          notchedShape: CircularNotchedRectangle(),
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
          onPressed: () => showFullScreenMenu(context),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void showFullScreenMenu(BuildContext context) {
    FullScreenMenu.show(
      context,
      backgroundColor: Colors.black,
      closeMenuOnBackgroundTap: true,
      items: [
        FSMenuItem(
          icon: Icon(Icons.ac_unit, color: Colors.white),
          text: Text('Make colder', style: TextStyle(color: Colors.white)),
          gradient: blueGradient,
          onTap: () {
            print('Made Ukraine colder!');
          },
        ),
        FSMenuItem(
          icon: Icon(Icons.wb_sunny, color: Colors.white),
          text: Text('Make hotter', style: TextStyle(color: Colors.white)),
          gradient: redGradient,
          onTap: () {
            print('Made Ukraine hotter!');
          },
        ),
        FSMenuItem(
          icon: Icon(Icons.flash_on, color: Colors.white),
          text: Text('Lightning', style: TextStyle(color: Colors.white)),
          gradient: orangeGradient,
          onTap: () {
            print('Made Ukraine Lightning!');
          },
        ),
        FSMenuItem(
          icon: Icon(Icons.grain, color: Colors.white),
          text: Text('Give a rain', style: TextStyle(color: Colors.white)),
          gradient: deepPurpleGradient,
          onTap: () {
            print('Gave Ukraine a rain!');
          },
        ),
        FSMenuItem(
          icon: Icon(Icons.add, color: Colors.white),
          text: Text('Add to EU', style: TextStyle(color: Colors.white)),
          onTap: () {
            print('Added to EU');
          },
        ),
      ],
    );
  }
}
