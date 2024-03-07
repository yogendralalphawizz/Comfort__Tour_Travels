import 'dart:convert';

import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/model/setting_model.dart';

import 'Theme/colors.dart';
import 'package:http/http.dart'as http;

import 'helper/apiservices.dart';
import 'model/Get_privacy_police_model.dart';
import 'model/getsettingmodel.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  SettingModel? settingModel;
  void getTerms()async{
    try{
      await App.init();
      Map param = {
        "id":"4",
      };

      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}static_pages"), param);
      setState(() {
        loading =false;
      });
      if(response['status']=="1"){
        setState(() {
          settingModel = SettingModel.fromJson(response['setting']);
        });

      }else{
        setSnackBar(response['msg'], context);
      }
    }catch(e){
      setState(() {
        loading =false;
      });
    }finally{
      setState(() {
        loading =false;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTerms();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primary,
          title: Text("Privacy Policy"),
        ),
        body: settingModel == null  ?Center(child: CircularProgressIndicator()): Html(
            data:"${settingModel!.html}"
        )
    );
  }
}
