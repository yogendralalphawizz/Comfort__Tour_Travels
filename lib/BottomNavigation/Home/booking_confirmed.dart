import 'package:flutter/material.dart';
import 'package:quick_pay/Config/common.dart';

import '../bottom_navigation.dart';

class BookingConfirmed extends StatelessWidget {
  const BookingConfirmed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value();
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 120,),
          Image.asset('assets/imgs/booking_confirmed.png'),
            commonButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomBar()), (route) => false);
              },
              loading: false,
              title: "Back to Home",
              context: context,
            ),
        ],),
      ),
    );
  }
}
