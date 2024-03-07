// // import 'package:buy_this_app/buy_this_app.dart';
// import 'package:flutter/material.dart';
// import 'package:quick_pay/BottomNavigation/Account/account_page.dart';
// import 'package:quick_pay/BottomNavigation/Mall/mall_page.dart';
// import 'package:quick_pay/BottomNavigation/Orders/my_orders.dart';
// import 'package:quick_pay/Config/app_config.dart';
// import 'package:quick_pay/Locale/locales.dart';
// import 'package:quick_pay/Routes/routes.dart';
// import 'package:quick_pay/Theme/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'Account/my_profile.dart';
// import 'Home/home.dart';
// import 'Scan/scan_page.dart';
//
// class AppNavigation extends StatefulWidget {
//   @override
//   _AppNavigationState createState() => _AppNavigationState();
// }
//
// class _AppNavigationState extends State<AppNavigation> {
//   int _currentIndex = 0;
//
//   final List<Widget> _children = [
//     HomePage(),
//     // MallPage(),
//     Container(),
//     // MyOrdersPage(),
//     MyProfilePage(),
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _checkForBuyNow();
//   }
//
//   void _checkForBuyNow() async {
//     // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     // if (!sharedPreferences.containsKey("key_buy_this_shown") &&
//     //     AppConfig.isDemoMode) {
//     //   Future.delayed(Duration(seconds: 10), () async {
//     //     if (mounted) {
//     //       BuyThisApp.showSubscribeDialog(context);
//     //       sharedPreferences.setBool("key_buy_this_shown", true);
//     //     }
//     //   });
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var locale = AppLocalizations.of(context)!;
//     final List<BottomNavigationBarItem> _items = [
//       BottomNavigationBarItem(
//           icon: ImageIcon(
//             AssetImage(
//               'assets/icons/footer menu/ic_home.png',
//             ),
//           ),
//           label: locale.home),
//       // BottomNavigationBarItem(
//       //     icon: ImageIcon(
//       //       AssetImage(
//       //         'assets/icons/footer menu/ic_mall.png',
//       //       ),
//       //     ),
//       //     label: locale.mall),
//       BottomNavigationBarItem(
//           icon: Image.asset(
//             'assets/icons/footer menu/ic_scane.png',
//             scale: 2.5,
//           ),
//           label:"My Bookings"
//           ),
//       // BottomNavigationBarItem(
//       //     icon: Image.asset(
//       //       'assets/icons/footer menu/ic_orders.png',
//       //       scale: 2.5,
//       //     ),
//       //     label: locale.orders),
//       BottomNavigationBarItem(
//           icon: Image.asset(
//             'assets/icons/footer menu/ic_account.png',
//             scale: 2.5,
//           ),
//           label: locale.account),
//     ];
//     return Scaffold(
//       body: _children[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         elevation: 10,
//         showUnselectedLabels: true,
//         selectedItemColor: Theme.of(context).primaryColorLight,
//         unselectedItemColor: blackColor,
//         // selectedIconTheme: IconThemeData(color: blackColor),
//         // unselectedIconTheme: IconThemeData(color: blackColor),
//         items: _items,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           if (index == 1) {
//             Navigator.pushNamed(context, PageRoutes.scanPage);
//           }
//           setState(() {
//             _currentIndex = index != 1 ? index : _currentIndex;
//           });
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/BottomNavigation/Account/my_profile.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/splash/booking_screen.dart';

import 'Account/favourites_page.dart';
import 'Home/home.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
class BottomBar extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BottomBar>
   {


  @override
  void initState() {
    super.initState();

  }
  @override
  void dispose() {
    super.dispose();

  }
  List<Widget> screenList = [ HomePage(),
    BookingScreen(),
    MyProfilePage(),];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        backgroundColor: background,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          CurvedNavigationBarItem(
            child: Icon(
                 Icons.home,
              color: selectedIndex==0?MyColorName.secondColor:Colors.black,
             ),
            label: "Home",
            labelStyle: TextStyle(
              color: selectedIndex==0?MyColorName.secondColor:Colors.black,
            )
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.history,
              color: selectedIndex==1?MyColorName.secondColor:Colors.black,
            ),
            label: "My Booking",
              labelStyle: TextStyle(
                color: selectedIndex==1?MyColorName.secondColor:Colors.black,
              )
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.person,
              color: selectedIndex==2?MyColorName.secondColor:Colors.black,
            ),
            label: "Account",
              labelStyle: TextStyle(
                color: selectedIndex==2?MyColorName.secondColor:Colors.black,
              )
          ),

        ],
      ),
    );
  }
}