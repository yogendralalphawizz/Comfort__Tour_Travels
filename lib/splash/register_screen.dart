import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/generated/assets.dart';
import 'package:quick_pay/model/state_model.dart';

import '../model/taluka_model.dart';
import '../model/village_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen();

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  List<String> method = ["Email", "Mobile No."];
  String selectMethod = "Email";
  TextEditingController mobileCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passCon = TextEditingController();
  bool obscure = true;
  List<StateModel> stateList = [];
  List<CityModel> cityList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStateApi();
  }

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
                      "Sign Up",
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
              Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: TextFormField(
                      controller: nameCon,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Name",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
                        prefixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.person,
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
                  boxHeight(2, context),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: TextFormField(
                      controller: emailCon,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Email Address",
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
                  boxHeight(2, context),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: TextFormField(
                      controller: mobileCon,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        fillColor: MyColorName.colorBg2,
                        filled: true,
                        labelText: "Mobile Number",
                        counterText: '',
                        labelStyle: TextStyle(color: Colors.black87),
                        prefixIcon: IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.call,
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
                  boxHeight(2, context),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(8, context)),
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
                            obscure ? Icons.visibility_off : Icons.visibility,
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
                  boxHeight(2, context),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColorName.colorBg2,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(4, context)),
                      child: DropdownButton<String>(
                        hint: Text("Select State",style: TextStyle(color: Colors.black87),),
                        value: stateId,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: MyColorName.secondColor,
                        ),
                        items: stateList.map((StateModel value) {
                          return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(value.name!),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        onChanged: (String? value) {
                          setState(() {
                            stateId = value;
                            cityId = null;
                            cityList.clear();
                          });
                          getCityApi();
                        },
                      ),
                    ),
                  ),
                  boxHeight(2, context),
                  cityList.isNotEmpty?Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColorName.colorBg2,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(4, context)),
                      child: DropdownButton<String>(
                        hint: Text("Select City",style: TextStyle(color: Colors.black87),),
                        value: cityId,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: MyColorName.secondColor,
                        ),
                        items: cityList.map((CityModel value) {
                          return DropdownMenuItem<String>(
                            value: value.id,
                            child: Text(value.name!),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        onChanged: (String? value) {
                          setState(() {
                            cityId = value;
                          });
                          getTalukaApi();
                        },
                      ),
                    ),
                  ):SizedBox(),
                  boxHeight(2, context),
                  talukaModel.data?.isNotEmpty??false?Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColorName.colorBg2,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(4, context)),
                      child: DropdownButton<dynamic>(
                        hint: Text("Select Taluka",style: TextStyle(color: Colors.black87),),
                        value: talukaId,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: MyColorName.secondColor,
                        ),
                        items: talukaModel.data?.map(( value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        onChanged: (value) {
                          setState(() {
                            talukaId = value;
                            print(value.id);
                            getVillageApi();
                          });
                        },
                      ),
                    ),
                  ):SizedBox(),
                  boxHeight(2, context),
                  villiageModel.data?.isNotEmpty??false?Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: getWidth(8, context)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyColorName.colorBg2,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: getWidth(4, context)),
                      child: DropdownButton<dynamic>(
                        hint: Text("Select Village",style: TextStyle(color: Colors.black87),),
                        value: villageId,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: MyColorName.secondColor,
                        ),
                        items: villiageModel.data?.map(( value) {
                          return DropdownMenuItem<dynamic>(
                            value: value,
                            child: Text(value.name!),
                          );
                        }).toList(),
                        isExpanded: true,
                        underline: SizedBox(),
                        onChanged: (value) {
                          setState(() {
                            villageId = value;
                            print(value.id);
                          });

                        },
                      ),
                    ),
                  ):SizedBox(),
                ],
              ),
              boxHeight(5, context),
              commonButton(
                onPressed: () async {

                  if (nameCon.text == "") {
                    setSnackBar("Enter Name", context);
                    return;
                  }
                  if (emailCon.text == "" ||
                      !emailCon.text.contains("@") ||
                      !emailCon.text.contains(".")) {
                    setSnackBar("Enter Valid Email", context);
                    return;
                  }
                  if (mobileCon.text == "" || mobileCon.text.length != 10) {
                    setSnackBar("Enter Valid Mobile Number", context);
                    return;
                  }
                  if (passCon.text == "" || passCon.text.length < 6) {
                    setSnackBar("Enter Password Minimum Character 6", context);
                    return;
                  }
                  if (stateId==null) {
                    setSnackBar("Select State", context);
                    return;
                  }
                  if (cityId == null) {
                    setSnackBar("Select City", context);
                    return;
                  }

                  // if (talukaId == null) {
                  //   setSnackBar("Select Taluka", context);
                  //   return;
                  // }
                  // if (villageId == null) {
                  //   setSnackBar("Select villageId", context);
                  //   return;
                  // }

                  setState(() {
                    loading = true;
                  });

                  await registerApi();
                },
                loading: loading,
                title: "Sign Up",
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
                text: 'Already have an account?',
                style: Theme.of(context).textTheme.titleMedium,
                children: <TextSpan>[
                  TextSpan(
                      text: ' Log In',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: MyColorName.secondColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pop(context);
                          // navigate to desired screen
                        })
                ]),
          ),
          boxHeight(5, context),
        ],
      ),
    );
  }

  String? stateId, cityId;

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
   registerApi() async {

    try {
      Map param = {
        "name": nameCon.text,
        "mobile": mobileCon.text,
        "email": emailCon.text,
        "password": passCon.text,
        "fcm_id":"${fcmToken}",
        "confirm_password": passCon.text,
        "address": "${stateList[stateList.indexWhere((element) => element.id == stateId)].name}"+"${cityList[cityList.indexWhere((element) => element.id == cityId)].name},${talukaId!=null?talukaId.name:""},${villageId!=null?villageId.name:""}",
            // "${cityList[cityList.indexWhere((element) => element.id == cityId)].name},${talukaId.name},${villageId.name}",
        "state": stateList[stateList.indexWhere((element) => element.id == stateId)].name,
       "city": cityList[cityList.indexWhere((element) => element.id == cityId)].name,
        "taluka":talukaId!=null?"${talukaId.name??""}":"",
        "village":villageId!=null?"${villageId.name??""}":""
      };
       print("__________________");
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}user_register"), param);
      setState(() {
        loading = false;
      });
      if (!response['error']) {
        Navigator.pop(context);
        setSnackBar("Please Login Your Account", context);
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

  void getStateApi() async {
    try {
      Map param = {};
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_states"), param);
      setState(() {
        loading = false;
      });
      for (var v in response['data']) {
        setState(() {
          stateList.add(StateModel.fromJson(v));
        });
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



  void getCityApi() async {
    try {
      Map param = {
        'state_id': stateId,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_cities"), param);
      setState(() {
        loading = false;
      });
      for (var v in response['data']) {
        setState(() {
          cityList.add(CityModel.fromJson(v));
        });
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
 dynamic talukaId,villageId;
  VilliageModel villiageModel=VilliageModel();
  TalukaModel talukaModel=TalukaModel();

  void getTalukaApi() async {
    try {
      Map param = {
        'city_id': cityId,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_taluka"), param);
      talukaModel=TalukaModel.fromJson(response);
      setState(() {
        loading = false;
      });

      // if(widget.model!.city!=null){
      //   int index = cityList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.city!.toLowerCase());
      //   if(index!=-1){
      //     cityId = cityList[index].id;
      //
      //   }
      // }
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
  void getVillageApi() async {
    try {
      Map param = {
        'taluka_id': talukaId.id,
      };
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_village"), param);
      setState(() {
        loading = false;
      });
      villiageModel=VilliageModel.fromJson(response);
      // if(widget.model!.city!=null){
      //   int index = cityList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.city!.toLowerCase());
      //   if(index!=-1){
      //     cityId = cityList[index].id;
      //
      //   }
      // }
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
