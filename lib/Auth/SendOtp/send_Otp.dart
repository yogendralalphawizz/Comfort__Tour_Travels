import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_pay/Auth/Verification/UI/VerifyOtp.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/generated/assets.dart';

class SendOTPScreen extends StatefulWidget {
  const SendOTPScreen({Key? key}) : super(key: key);

  @override
  State<SendOTPScreen> createState() => _SendOTPScreenState();
}

class _SendOTPScreenState extends State<SendOTPScreen> {
  TextEditingController mobileCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
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
                    "Send OTP",
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
              "Enter Mobile Number",
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
                controller: mobileCon,
                validator:  (value) {
                  if (!isPhone(value!)) {
                    return 'Please enter a valid phone number.';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: InputDecoration(
                  fillColor: MyColorName.colorBg2,
                  filled: true,
                  labelText: "Enter Mobile Number",
                  counterText: '',
                  labelStyle: TextStyle(color: Colors.black87),
                  prefixIcon: IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.phone,
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
                  sendOtpApi();
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
    );
  }

  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  void sendOtpApi()async{
    try{
      await App.init();
      Map param = {
        'mobile': mobileCon.text
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}register_otp"), param);
      if(!response['error']){

        Fluttertoast.showToast(msg: response['message']);

        if(response['otp']!=null){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VerifyOtp(otp:response['otp'].toString(),mobile: mobileCon.text,title: 'sendOtp'),));
        }
        setState(() {
          loading = false;
        });
        //
      }else{
        Fluttertoast.showToast(msg: response['message']);
        setState(() {
          loading = false;
        });
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
