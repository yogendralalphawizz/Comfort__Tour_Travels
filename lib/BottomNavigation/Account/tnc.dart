import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/Locale/locales.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:http/http.dart'as http;
import 'package:quick_pay/model/setting_model.dart';

import '../../helper/apiservices.dart';

class TncPage extends StatefulWidget {

  @override
  State<TncPage> createState() => _TncPageState();
}

class _TncPageState extends State<TncPage> {
  var trmscondition;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  SettingModel? settingModel;
  void getTerms()async{
    try{
      await App.init();
      Map param = {
          "id":"3",
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
          title: Text("Terms & Condition"),
        ),
        body: settingModel  == null ? Center(child: Text('Data not available')) :Html(
            data:"${settingModel!.html}"
        )
    );
  }
}
