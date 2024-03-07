/*fonts*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/model/user_model.dart';


const fontRegular = 'Regular';
const fontMedium = 'Medium';
const fontSemibold = 'Semibold';
const fontBold = 'Bold';
/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeLarge = 24.0;
const textSizeXLarge = 34.0;

/* margin */

const spacing_control_half = 2.0;
const spacing_control = 4.0;
const spacing_standard = 8.0;
const spacing_middle = 10.0;
const spacing_standard_new = 16.0;
const spacing_large = 24.0;
const spacing_xlarge = 32.0;
const spacing_xxLarge = 40.0;

final int timeOut = 60;
const int perPage = 10;
String taskId = "";
String groupId = "";
final String appName = 'GYM Management System';
bool notificationStatus = true;
int notificationId = 1;
final String packageName = 'com.gym.system';
const String languageCode = 'en';
//const String baseUrl = 'http://192.168.1.8/gym_api/';
const String baseUrl = "https://developmentalphawizz.com/ShareMyRide/api/";
const String baseNewUrl = "https://developmentalphawizz.com/ShareMyRide/api/";
String imageUrl = "${baseUrl}uploads/";
final String playUrl =
    "https://play.google.com/store/apps/details?id=$packageName";
const String iosUrl =
    "https://apps.apple.com/in/app/taskey-to-do-list-tasks/id1644364637";
String? curUserId;
String? curTikId = '';
String? fcmToken;
String? term = "";
String? privacy = '';
String? returned = "";
String? delivery = "";
String? company = "";
String addressId = "";
String proImage = "";
String address = "";
double latitude = 0;
double longitude = 0;
double latitudeFirst = 0;
double longitudeFirst = 0;
int likeCount = 0;
UserModel? userModel;
const defaultPadding = 12.0;
String razorPayKey = "rzp_test_UUBtmcArqOLqIY";
String razorPaySecret = "NTW3MUbXOtcwUrz5a4YCshqk";
String defaultTheme = "light";
double getHeight(double height, BuildContext context) {
  double tempHeight = 0.0;
  tempHeight = ((height * 100) / 1290);
  return (MediaQuery.of(context).size.height * height) / 100;
}

double getWidth(double width, BuildContext context) {
  double tempWidth = 0.0;
  tempWidth = ((width * 100) / 720);
  return (MediaQuery.of(context).size.width * width) / 100;
}

Widget boxWidth(double width, BuildContext context) {
  return SizedBox(
    width: getWidth(width, context),
  );
}

Widget boxHeight(double height, BuildContext context) {
  return SizedBox(
    height: getHeight(height, context),
  );
}

navigateScreen(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

navigateBackScreen(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

back(BuildContext context) {
  Navigator.pop(context);
}

//Routes
const String homeViewRoute = '/home';
const String userViewRoute = '/admin_user_list';
const String homeUserViewRoute = '/user_home';
const String loginViewRoute = '/login';
const String registerViewRoute = '/register';
//Plan
TextEditingController namePlanCon = new TextEditingController();
TextEditingController descPlanCon = new TextEditingController();
TextEditingController pricePlanCon = new TextEditingController();
TextEditingController monthPlanCon = new TextEditingController();
//Plan
TextEditingController amountSalaryCon = new TextEditingController();
TextEditingController descSalaryCon = new TextEditingController();

//Member
TextEditingController nameMemberCon = new TextEditingController();
TextEditingController emailMemberCon = new TextEditingController();
TextEditingController mobileMemberCon = new TextEditingController();
TextEditingController dateMemberCon = new TextEditingController();
TextEditingController profileMemberCon = new TextEditingController();
TextEditingController heightMemberCon = new TextEditingController();
TextEditingController weightMemberCon = new TextEditingController();
TextEditingController bloodMemberCon = new TextEditingController();
String? selectedGroup, selectedPlan;
debugPrintApp(val){
  if (kDebugMode) {
    print(val);
  }
}
