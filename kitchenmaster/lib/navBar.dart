import 'package:flutter/material.dart';
import 'package:fridgemaster/alerts.dart';
import 'package:fridgemaster/inventory.dart';
import 'package:fridgemaster/inventorytryout.dart';
import 'package:fridgemaster/recipes.dart';
import 'package:fridgemaster/favourites.dart';
import 'package:fridgemaster/profile.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';



class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      ProfilePage(),
      AlertsPage(),
      // Add the respective pages
      InventoryPage(),
      RecipePage(),
      FavouritesPage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("PROFILE"),
        activeColorPrimary: Colors.black87,
        activeColorSecondary: Color(0xffff6961),
        inactiveColorPrimary: Colors.black,
        textStyle: TextStyle(fontFamily: 'Iceland', fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add_alert_sharp),
        title: ("ALERTS"),
        activeColorPrimary: Colors.black87,
        activeColorSecondary: Color(0xffff6961),
        inactiveColorPrimary: Colors.black,
        textStyle: TextStyle(fontFamily: 'Iceland', fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.list),
        title: ("INVENTORY"),
        activeColorPrimary: Colors.black87,
        activeColorSecondary: Color(0xffff6961),
        inactiveColorPrimary: Colors.black,
        textStyle: TextStyle(fontFamily: 'Iceland', fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.grid_view_rounded),
        title: ("RECIPES"),
        activeColorPrimary: Colors.black87,
        activeColorSecondary: Color(0xffff6961),
        inactiveColorPrimary: Colors.black,
        textStyle: TextStyle(fontFamily: 'Iceland', fontSize: 12, fontWeight: FontWeight.bold),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        title: ("FAVOURITES"),
        activeColorPrimary: Colors.black87,
        activeColorSecondary: Color(0xffff6961),
        inactiveColorPrimary: Colors.black,
        textStyle: TextStyle(fontFamily: 'Iceland', fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Color(0xffff6961), // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style10, // Choose the nav bar style with this property.
    );
  }
}