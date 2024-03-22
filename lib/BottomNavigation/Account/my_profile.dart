import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:quick_pay/BottomNavigation/Account/help_page.dart';
import 'package:quick_pay/BottomNavigation/Account/tnc.dart';
import 'package:quick_pay/BottomNavigation/Home/Pages/MyWallet.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';

import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:quick_pay/model/user_model.dart';
import 'package:quick_pay/splash/splash_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/custom_profile.dart';
import '../../Editeprofile.dart';
import '../../faq.dart';
import '../../model/DeleteAccountModel.dart';
import '../../model/userprofile.dart';
import 'package:http/http.dart' as http;

import '../../privacy_policy.dart';
import '../Home/change_password.dart';
import 'notifications_page.dart';

class MyProfilePage extends StatefulWidget {
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  UserProfile? getprofile;
  String? username;
  String? address;

  getUserProfile() async {
    print("This is user profile$username");
    await App.init();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? id = preferences.getString('userId');
    username = preferences.getString('username');
    // address = preferences.getString("address");
    var headers = {
      'Cookie': 'ci_session=7ff77755bd5ddabba34d18d1a5a3b7fbca686dfa'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse("${ApiService.getUserProfile}"));
    request.fields.addAll({'user_id': curUserId!});
    print(curUserId.toString()+"dhhdhgffbfnh");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print("This is user request-----------${response.statusCode}");
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      Map data = json.decode(finalResult);
      final jsonResponse = UserProfile.fromJson(json.decode(finalResult));
      setState(() {
        userModel = UserModel.fromJson(data['data']);
      });

      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // name = userModel!.username ?? "";
      /* print('${name}________');
      setState(() {
        getprofile = jsonResponse;
      });*/
    } else {
      print(response.reasonPhrase);
    }
  }

  void initState() {
    super.initState();
    // getuserProfile();
  }

  Future<DeleteAccountModel?> deleteAccount() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('userId');
    var headers = {
      'Cookie': 'ci_session=7ff77755bd5ddabba34d18d1a5a3b7fbca686dfa'
    };
    var header = headers;
    var request = http.MultipartRequest('POST',
        Uri.parse('${baseUrl}delete_account'));
    request.fields.addAll({'user_id': id.toString()});
    print("User id in delete account ${request.fields}");
    request.headers.addAll(header);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
          (route) => false);
      Fluttertoast.showToast(msg: 'Account Delete Success');
      return DeleteAccountModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }

  dialogAnimate(BuildContext context, Widget dialog) {
    return showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: dialog,
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
    );
  }

  deleteAccountDialog() async {
    await dialogAnimate(
      context,
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        content: Text("Are You Sure do You Want To Delete This Account",
            style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          TextButton(
              child: Text("No",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(false);
              }),
          TextButton(
              child: Text("Yes",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                deleteAccount();
                // SettingProvider settingProvider =
                // Provider.of<SettingProvider>(context, listen: false);
                // settingProvider.clearUserSession(context);
                // //favList.clear();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //     '/home', (Route<dynamic> route) => false);
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.network(
              userModel == null ? "" : "${userModel!.profilePic}",
              fit: BoxFit.fill,
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "Profile",
        ),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => BusBookingPage(),));
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => NotificationsPage()));
              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              )),
        ],
      ),
      backgroundColor: background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage('${userModel!.profilePic}')),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userModel!.username}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${userModel!.email}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => EditeProfile(userModel)))
                            .then((value) {
                          if (value != null) {
                            getUserProfile();
                          }
                        });
                      },
                      child: CircleAvatar(
                          radius: 25,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          )))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Notifications ',
                tileIcon: Image.asset(
                  "assets/imgs/Notifications.png",
                  scale: 1.7,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => NotificationsPage()));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'My Wallet',
                tileIcon: Image.asset(
                  "assets/imgs/Notifications.png",
                  scale: 1.7,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => MyWallet(getprofile: getprofile,)));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Change Password',
                tileIcon: Image.asset(
                  "assets/imgs/Notifications.png",
                  scale: 1.7,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ChnagePassword()));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Emergency Contact',
                tileIcon: Image.asset(
                  "assets/imgs/Need Help.png",
                  scale: 1.7,
                ),

                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => NeedHelpPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Rate us ',
                tileIcon: Image.asset(
                  "assets/imgs/Rate us.png",
                  scale: 1.7,
                ),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (c)=>Rateu()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Terms & Conditions ',
                tileIcon: Image.asset(
                  "assets/imgs/Terms & Conditions.png",
                  scale: 1.7,
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => TncPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Privacy Policy ',
                tileIcon: Image.asset(
                  "assets/imgs/Privacy Policy.png",
                  scale: 1.7,
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => Privacy()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'FAQs',
                tileIcon: Image.asset(
                  "assets/imgs/Privacy Policy.png",
                  scale: 1.7,
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => FaQScreen()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Account Delete',
                tileIcon: Image.asset(
                  "assets/imgs/delete.png",
                  scale: 1.7,
                ),
                onTap: () {
                  deleteAccountDialog();
                  // Navigator.push(context, MaterialPageRoute(builder: (c)=> FaQScreen()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: CustomDrawerTile(
                tileName: 'Logout',
                tileIcon: Image.asset(
                  "assets/imgs/log out.png",
                  scale: 1.7,
                  color: Colors.black87,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Logout"),
                          content: Text("Do you want to proceed?"),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primary),
                              child: Text("YES"),
                              onPressed: () async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("User Logout")));
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                setState(() {
                                  prefs.clear();
                                });
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashScreen()),
                                    (route) => false);
                                // Navigator.pushNamedAndRemoveUntil(
                                //   context,
                                //   MaterialPageRoute(builder: (context) =>LoginPage()),
                                // );
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: primary),
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            ),
            SizedBox(
              height: 17,
            ),
          ],
        ),
      ),
    );
  }
}
