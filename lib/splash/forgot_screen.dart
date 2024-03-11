
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:quick_pay/Auth/Verification/UI/VerifyOtp.dart';
import 'package:quick_pay/BottomNavigation/bottom_navigation.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/generated/assets.dart';

class ForgotScreen extends StatefulWidget {



  const ForgotScreen();

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  List<String> method = ["Email", "Mobile No."];
  String selectMethod = "Email";
  TextEditingController mobileCon = TextEditingController();
  TextEditingController pinCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  bool obscure = true;
  final focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = MyColorName.secondColor;
    const fillColor =  MyColorName.colorBg2;
    const borderColor = MyColorName.colorBg2;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: getWidth(100, context),
                height: getHeight(35, context),
                decoration: BoxDecoration(
                    gradient: commonGradient(),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(52),
                      bottomRight: Radius.circular(52),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.white,
                          size: 32,
                        )),
                      ],
                    ),
                    Image.asset(Assets.assetsHomeLogo),
                    Text(
                      "Forget Password ?",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white),
                    ),
                    boxHeight(4, context),
                  ],
                ),
              ),
              boxHeight(3, context),
              Text(
                "Enter Email or Mobile associated\nwith your account",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!,
              ),
              boxHeight(3, context),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getWidth(8, context)),
                child: TextFormField(
                  controller: emailCon,
                  validator:  (value) {
                    if (!isEmail(value!) && !isPhone(value)) {
                      return 'Please enter a valid email or phone number.';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: MyColorName.colorBg2,
                    filled: true,
                    labelText: "Email Address/Mobile Number",
                    counterText: '',
                    labelStyle: TextStyle(color: Colors.black87),
                    prefixIcon: IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.mail,
                        color: MyColorName.secondColor,
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
              boxHeight(5, context),
              commonButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    forgetApi();
                    // Navigate to next page
                  }

                },
                loading: loading,
                title:  "Submit",
                context: context,
              ),

            ],
          ),
        ),
      ),
    );
  }

  bool isEmail(String input) => EmailValidator.validate(input);
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  void forgetApi()async{
    try{
      await App.init();
      Map param = {
        "email":isEmail(emailCon.text) ? emailCon.text : '',
        "mobile":isPhone(emailCon.text) ? emailCon.text: '',
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}forgot_pass"), param);
      if(response['status']=='success'){
        
        Fluttertoast.showToast(msg: response['msg']);

        if(response['otp']!=null){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VerifyOtp(otp:response['otp'].toString(),mobile:response['mobile'].toString() , ),));
        }else{
          Navigator.pop(context);
        }

          //
      }else{

      }
      setSnackBar(response['msg'], context);
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

}
