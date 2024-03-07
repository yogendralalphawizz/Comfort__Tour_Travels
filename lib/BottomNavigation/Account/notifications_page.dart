import 'dart:async';
import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/Locale/locales.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:http/http.dart'as http;
import 'package:quick_pay/helper/apiservices.dart';

import '../../Config/common.dart';
import '../../Config/constant.dart';
import '../../Locale/notificationmodel.dart';
import '../../helper/constant.dart';
import '../../model/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}


class _NotificationsPageState extends State<NotificationsPage> {

  NotificationModel1 notificationmodel=NotificationModel1();
  bool loading = true;

  getNotification() async {
    print("_____________________");
    await App.init();


      try {
        Map data;
        setState(() {
          loading = true;
        });
        data = {
          "user_id": "525",
        };
        var res = await http
            .post(Uri.parse(baseUrl + "notifications"), body: data);

        print(data);
        print(res.body.toString()+"_____________________");
        var data1=jsonDecode(res.body);
        notificationmodel=NotificationModel1.fromJson(data1);
        setState(() {

        });
      } on TimeoutException catch (_) {

      }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 200),(){
      getNotification();
     }
    );
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primary,
        title: Text(
          'Notification',
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700, fontSize: 20,color: white),
        ),
        iconTheme: IconThemeData(color: white),
      ),
      body:
      ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: notificationmodel.data?.length??0,
          itemBuilder: (context, index) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                elevation: 0.5,
                child: ListTile(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${notificationmodel.data?[index].title}",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Text( "${notificationmodel.data?[index].date}",),

                    ],
                  ),
                  trailing:
                  Text("${notificationmodel.data?[index].type??""}"),
                  subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text( "${notificationmodel.data?[index].message}",)
                  ),

                ),
              ),
            );
          }),
    );
  }
}
