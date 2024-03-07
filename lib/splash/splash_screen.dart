import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quick_pay/Auth/Login/UI/login_page.dart';
import 'package:quick_pay/BottomNavigation/bottom_navigation.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/generated/assets.dart';
import 'package:quick_pay/splash/login_screen.dart';

import '../Auth/Login/UI/login_ui.dart';
import '../Auth/login_navigator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changePage();
    // Future.delayed(Duration(seconds: 3)).then((value) {
    //   Navigator.push(
    //       context, MaterialPageRoute(builder: (context) => LoginScreen()));
    // });
  }
  void changePage()async{
    await App.init();
    Future.delayed(Duration(seconds: 3)).then((value) {
      if(App.localStorage.getString("userId")!=null){
          curUserId = App.localStorage.getString("userId");
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomBar()));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage(Assets.assetsSplashScreen),
                  fit: BoxFit.fill),
            ],
          ),
        ),
      ),
    );
  }
}
