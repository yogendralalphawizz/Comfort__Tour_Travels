import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_pay/Auth/SendOtp/send_Otp.dart';
import 'package:quick_pay/Auth/Verification/UI/VerifyOtp.dart';
import 'package:quick_pay/BottomNavigation/bottom_navigation.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/generated/assets.dart';
import 'package:quick_pay/splash/forgot_screen.dart';
import 'package:quick_pay/splash/otp_screen.dart';
import 'package:quick_pay/splash/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<String> method = ["Email", "Mobile No."];
  String selectMethod = "Email";
  TextEditingController mobileCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();

  bool isMobile = false;
  int _value = 2;

  bool obscure = true;

  @override
  Widget build(BuildContext context) {
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
                    Image.asset(Assets.assetsHomeLogo),
                    Text(
                      "Login",
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
              boxHeight(5, context),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 2,
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => MyColorName.mainColor),
                        activeColor: Colors.white,
                        groupValue: _value,
                        onChanged: (int? value) {
                          setState(() {
                            _value = value!;
                            isMobile = false;
                          });
                        },
                      ),
                      const Text(
                        "Email",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                      Radio(
                          value: 1,
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => MyColorName.mainColor),
                          groupValue: _value,
                          onChanged: (int? value) {
                            setState(() {
                              _value = value!;
                              isMobile = true;
                            });
                          }),
                      // SizedBox(width: 10.0,),
                      const Text(
                        "Mobile No.",
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                      ),
                    ],
                  ),
                  !isMobile
                      ? Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(8, context)),
                              child: TextFormField(
                                controller: emailCon,
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
                            boxHeight(3, context),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(8, context)),
                              child: TextFormField(
                                controller: passCon,
                                obscureText: obscure,
                                decoration: InputDecoration(
                                  fillColor: MyColorName.colorBg2,
                                  filled: true,
                                  labelText: "Password",
                                  counterText: '',
                                  labelStyle: TextStyle(color: Colors.black87),
                                  prefixIcon: IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.lock,
                                      color: MyColorName.secondColor,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscure = !obscure;
                                      });
                                    },
                                    icon: Icon(
                                      obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidth(8, context)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotScreen()));
                                    },
                                    child: Text(
                                      "Forgot Password ?",
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color: MyColorName.secondColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : SizedBox.shrink(),
                  isMobile
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getWidth(8, context)),
                          child: TextFormField(
                            controller: mobileCon,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            decoration: InputDecoration(
                              fillColor: MyColorName.colorBg2,
                              filled: true,
                              labelText: "Mobile Number",
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
                        )
                      : SizedBox.shrink(),
                ],
              ),
              boxHeight(5, context),
              commonButton(
                onPressed: () {
                  if(isMobile)
                    {
                      if (mobileCon.text.length < 10) {
                        setSnackBar("Enter Valid Mobile Number", context);
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      sendLoginOtpApi();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtp(mobile: mobileCon.text,title: 'login',)));

                    }else {
                    if (emailCon.text == "") {
                      setSnackBar("Enter Valid Email Or Mobile", context);
                      return;
                    }
                    if (passCon.text == "" || passCon.text.length < 6) {
                      setSnackBar("Enter Valid Password", context);
                      return;
                    }

                    setState(() {
                      loading = true;
                    });
                    loginApi();
                  }
                },
                loading: loading,
                title: "Login",
                context: context,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          boxHeight(1, context),
          RichText(
            text: TextSpan(
                text: 'Don\'t have an account?',
                style: Theme.of(context).textTheme.titleMedium,
                children: <TextSpan>[
                  TextSpan(
                      text: ' Sign up',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: MyColorName.secondColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SendOTPScreen()));
                          // navigate to desired screen
                        })
                ]),
          ),
          boxHeight(5, context),
        ],
      ),
    );
  }

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;

  void loginApi() async {
    try {
      await App.init();
      Map param = {};
      if (true) {
        param['email'] = emailCon.text;
        param['password'] = passCon.text;
        param['device_token'] = "${fcmToken}";
      }

      var response =
          await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}login"), param);
      setState(() {
        loading = false;
      });
      if (!response['error']) {
        App.localStorage.setString("userId", response['data']['id'].toString());
        App.localStorage
            .setString("name", response['data']['username'].toString());
        App.localStorage
            .setString("email", response['data']['email'].toString());
        App.localStorage
            .setString("mobile", response['data']['mobile'].toString());
        curUserId = App.localStorage.getString("userId");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomBar()),
            (route) => false);
      } else {
        setSnackBar(response['message'], context);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }


  void sendLoginOtpApi() async {
    try {
      await App.init();
      Map param = {
        "mobile":mobileCon.text,
      };

      var response =
      await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}send_otp"), param);
      setState(() {
        loading = false;
      });
      if (!response['error']) {

        Fluttertoast.showToast(msg: response['message']);

        if(response['otp']!=null){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => VerifyOtp(otp:response['otp'].toString(),mobile: mobileCon.text,title: 'login'),));
        }
      } else {
        setSnackBar(response['message'], context);
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
