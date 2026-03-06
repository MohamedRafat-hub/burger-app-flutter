// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:food_app/core/constants/app_colors.dart';
// import 'package:food_app/features/auth/presentation/views/profile_view.dart';
// import 'package:food_app/features/orderHistory/presentation/views/order_history_view.dart';
// import 'features/cart/presentation/cart_view.dart';
// import 'features/home/presentation/home_view.dart';
//
// class Root extends StatefulWidget {
//   const Root({super.key});
//
//   @override
//   State<Root> createState() => _RootState();
// }
//
// class _RootState extends State<Root> {
//   late PageController controller;
//   late List<Widget> screens;
//   int currentScreen = 0;
//
//   @override
//   void initState() {
//     controller = PageController(initialPage: currentScreen);
//     screens = [
//       HomeView(),
//       CartView(),
//       OrderHistoryView(),
//       ProfileView(),
//     ];
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       child: Scaffold(
//         body: PageView(
//           controller: controller,
//           onPageChanged: (index){
//             setState(() {
//               currentScreen = index;
//             });
//           },
//           children: screens,
//         ),
//         bottomNavigationBar: Container(
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(topLeft:  Radius.circular(16), topRight: Radius.circular(16)),
//               color: AppColors.primaryColor),
//           padding: EdgeInsets.all(10),
//           child: BottomNavigationBar(
//               currentIndex: currentScreen,
//               onTap: (index) {
//                   controller.jumpToPage(index);
//                 // controller.jumpToPage(currentScreen);
//               },
//               elevation: 0,
//               backgroundColor: Colors.transparent,
//               type: BottomNavigationBarType.fixed,
//               selectedItemColor: Colors.white,
//               unselectedItemColor: Colors.grey.shade700,
//               items: [
//                 BottomNavigationBarItem(
//                     icon: Icon(CupertinoIcons.home), label: "Home"),
//                 BottomNavigationBarItem(
//                     icon: Icon(CupertinoIcons.cart), label: "Cart"),
//                 BottomNavigationBarItem(
//                     icon: Icon(Icons.local_restaurant_sharp), label: "Order History"),
//                 BottomNavigationBarItem(
//                     icon: Icon(CupertinoIcons.profile_circled), label: "Profile"),
//               ]),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/core/constants/app_colors.dart';
import 'package:food_app/features/auth/presentation/views/profile_view.dart';
import 'package:food_app/features/orderHistory/presentation/views/order_history_view.dart';
import 'features/cart/presentation/cart_view.dart';
import 'features/home/presentation/home_view.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  // late PageController controller;
  late List<Widget> screens;
  int currentScreen = 0;

  @override
  void initState() {
    // controller = PageController(initialPage: currentScreen);
    screens = [
      HomeView(),
      CartView(),
      OrderHistoryView(),
      ProfileView(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: currentScreen,
          children: screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: AppColors.primaryColor),
          padding: EdgeInsets.all(10),
          child: BottomNavigationBar(
              currentIndex: currentScreen,
              onTap: (index) {
                setState(() {
                  currentScreen = index;
                });
                // controller.jumpToPage(currentScreen);
              },
              elevation: 0,
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey.shade700,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.cart), label: "Cart"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.local_restaurant_sharp),
                    label: "Order History"),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.profile_circled),
                    label: "Profile"),
              ]),
        ),
      ),
    );
  }
}