

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Config/colors.dart';
import '../../Config/common.dart';
import '../../Config/constant.dart';
import '../../Theme/colors.dart';

class ChnagePassword extends StatefulWidget {


  @override
  State<ChnagePassword> createState() => _ChnagePasswordState();
}

class _ChnagePasswordState extends State<ChnagePassword> {
  TextEditingController oldPasswordcon = TextEditingController();
  TextEditingController newPasswordCon = TextEditingController();
  bool obssecure=false;
  bool newobssecure=false;
  bool loading=false;
  void registerApi() async {


    ///MultiPart request

    if (true) {
      try {
        Map<String, String> param = {
          "user_id":curUserId.toString(),
          "old_password": oldPasswordcon.text,
          "new_password":newPasswordCon.text

        };
        var request = http.MultipartRequest(
          'POST',
          Uri.parse(baseUrl + "changePassword"),
        );
        Map<String, String> headers = {
          "token": App.localStorage.getString("token").toString(),
          "Content-type": "multipart/form-data"
        };

        // print("kkkkkkkkkkkkkkkkkkkkkkkkkkkk");
        request.headers.addAll(headers);
        request.fields.addAll(param);
        print(request.fields.toString());
        print("request: " + request.toString());
        var res = await request.send();
        print("This is response:" + res.toString());
        setState(() {
          loading = false;
        });
        print(res.statusCode);
        final respStr = await res.stream.bytesToString();
        print(respStr.toString());
        if (res.statusCode == 200) {
          Map data = jsonDecode(respStr.toString());
          if (!data['error']) {
            //setSnackbar("${data['message'].toString()}", context);

            Fluttertoast.showToast(  msg: "${data['message']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else {
            //setSnackbar(data['message'].toString(), context);
            Fluttertoast.showToast(  msg: "${data['message']}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      } on TimeoutException catch (_) {
       // setSnackbar("Something Went Wrong", context);
        Fluttertoast.showToast(  msg: "Something Went Wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          loading = true;
        });
      }
    }


    // else {
    //   setSnackbar("No Internet Connection", context);
    //   setState(() {
    //     loading = true;
    //   });
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
        title: Text(
          "Chnage Password",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:white),
        ),
      ),
      body:  Column(
        children: [
          Spacer(),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getWidth(8, context)),
            child: TextFormField(
              controller: oldPasswordcon,
              obscureText: obssecure,
              decoration: InputDecoration(
                fillColor: MyColorName.colorBg2,
                filled: true,
                labelText: "Old Password",
                counterText: '',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.lock,
                    color: MyColorName.mainDarkColor,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obssecure = !obssecure;
                    });
                  },
                  icon: Icon(
                    obssecure ? Icons.visibility_off : Icons.visibility,
                    color: MyColorName.mainDarkColor,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColorName.colorBg2,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColorName.colorBg2,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding:
            EdgeInsets.symmetric(horizontal: getWidth(8, context)),
            child: TextFormField(
              controller: newPasswordCon,
              obscureText: newobssecure,
              decoration: InputDecoration(
                fillColor: MyColorName.colorBg2,
                filled: true,
                labelText: "New Password",
                counterText: '',
                labelStyle: TextStyle(color: Colors.black87),
                prefixIcon: IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.lock,
                    color: MyColorName.mainDarkColor,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      newobssecure = !newobssecure;
                    });
                  },
                  icon: Icon(
                    newobssecure ? Icons.visibility_off : Icons.visibility,
                    color: MyColorName.mainDarkColor,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColorName.colorBg2,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: MyColorName.colorBg2,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          boxHeight(3 ,context),
          commonButton(
            width: 70,
            onPressed: () {

              if (oldPasswordcon.text == ""

              ) {
                Fluttertoast.showToast(  msg: "Enter OLd Password",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              }
              if (newPasswordCon.text == ""

              ) {
                Fluttertoast.showToast(  msg: "Enter New Password",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                return;
              }




              setState(() {
                loading = true;
              });
              registerApi();
            },
            loading: loading,
            title: "Change Password",
            context: context,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
