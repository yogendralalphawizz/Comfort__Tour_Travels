import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/model/setting_model.dart';
import 'Theme/colors.dart';
import 'package:http/http.dart'as http;

import 'model/faqmodel.dart';

class FaQScreen extends StatefulWidget {
  const FaQScreen({Key? key}) : super(key: key);

  @override
  State<FaQScreen> createState() => _FaQScreenState();
}

class _FaQScreenState extends State<FaQScreen> {

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  List<FAQModel> faqList = [];
  void getTerms()async{
    try{
      await App.init();
      Map param = {
        "id":"3",
      };

      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}faq"), param);
      setState(() {
        loading =false;
      });
      if(response['status']=="1"){
        for(var v in response['setting']){
          setState(() {
            faqList.add(FAQModel.fromJson(v));
          });
        }


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
            title: Text("FAQs"),
          ),
          body: faqList.isEmpty? Center(child: Text('Data Not Available'),)
          :Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: faqList.length ?? 0,
                        itemBuilder: (context, index) {
                          return Column(
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                title: Text("${faqList[index].title}"),
                                subtitle:
                                Text("${faqList[index].description}",
                                  style: TextStyle(
                                      fontSize: 12, color: hintColor),
                                ),

                              ),
                              index != 2
                                  ? Divider(thickness: 6)
                                  : SizedBox.shrink(),
                            ],
                          );
                        }),
                  ],
                ),
      );
    }
}
