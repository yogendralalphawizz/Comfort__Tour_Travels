import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:quick_pay/BottomNavigation/bottom_navigation.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/generated/assets.dart';

class OTPScreen extends StatefulWidget {
  String mobile,otp;


  OTPScreen(this.mobile,this.otp);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  List<String> method = ["Email", "Mobile No."];
  String selectMethod = "Email";
  TextEditingController mobileCon = TextEditingController();
  TextEditingController pinCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  bool obscure = true;
  final focusNode = FocusNode();
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
        child: Container(
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
                      "Verification ${widget.otp}",
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
                "Code has sent to",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!,
              ),
              Text(
                "+91${widget.mobile}",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!,
              ),
              boxHeight(3, context),
              Pinput(
                controller: pinCon,
                focusNode: focusNode,
                length: 4,
                androidSmsAutofillMethod:
                AndroidSmsAutofillMethod.smsUserConsentApi,
                listenForMultipleSmsOnAndroid: true,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: 8),
                autofocus: true,
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: focusedBorderColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
              boxHeight(3, context),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Haven't received the verification code?\n",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: <TextSpan>[
                      TextSpan(text: ' Resend',
                          style:Theme.of(context).textTheme.titleMedium!.copyWith(color: MyColorName.secondColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                loading = true;
                              });
                              loginApi();
                              // navigate to desired screen
                            }
                      )
                    ]
                ),
              ),
              boxHeight(5, context),
              commonButton(
                onPressed: () {
                  if(pinCon.text==""||pinCon.text != widget.otp){
                    setSnackBar("Enter Valid OTP", context);
                    return;
                  }
                  setState(() {
                    loading = true;
                  });
                  verifyApi();
                },
                loading: loading,
                title:  "Verify",
                context: context,
              ),

            ],
          ),
        ),
      ),
    );
  }

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  void verifyApi()async{
    try{
      await App.init();
      Map param = {
        "mobile":widget.mobile,
        "otp":pinCon.text,
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}verify_otp"), param);
      if(!response['error']){
            App.localStorage.setString("userId", response['data']['id'].toString());
            App.localStorage.setString("name", response['data']['username'].toString());
            App.localStorage.setString("email", response['data']['email'].toString());
            App.localStorage.setString("mobile", response['data']['mobile'].toString());
            curUserId = App.localStorage.getString("userId");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder:(context)=> BottomBar()),
                    (route) => false);
      }else{
        setSnackBar(response['message'], context);
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
  void loginApi()async{
    try{
      Map param = {

      };
      param['mobile'] = widget.mobile;
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}send_otp"), param);
      setState(() {
        loading =false;
      });
      if(!response['error']){
        setState(() {
          widget.otp =  response['otp'].toString();
        });

      }else{
        setSnackBar(response['message'], context);
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
}
