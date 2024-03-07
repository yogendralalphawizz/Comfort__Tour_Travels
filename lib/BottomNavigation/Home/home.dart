import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import 'package:quick_pay/BottomNavigation/Home/search_from.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/Razorpay.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/Config/location_details.dart';

import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:quick_pay/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Booking/booking_List.dart';
import '../../model/RechrgeModel.dart';
import '../../model/getbannermodel.dart';
import '../../model/userprofile.dart';
import '../Account/notifications_page.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class Payment {
  String image;
  String? title;
  Function onTap;
  String? date ;

  Payment(this.image, this.title, this.onTap);
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  int currentIndex = 0;
  TabController? tabController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  final _fomKey  =
  GlobalKey<FormState>();
  TextEditingController pickupCon = new TextEditingController();
  TextEditingController dropCon = new TextEditingController();
  TextEditingController pickupCityCon = new TextEditingController();
  TextEditingController dropCityCon = new TextEditingController();

  Getbannermodel? bannerModel;

  getBanner() async {
    var headers = {
      'Cookie': 'ci_session=83721b31871c96522e60f489ca4e917362cdb60c'
    };
    var request = http.Request('GET', Uri.parse('${ApiService.getSlider}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('_____fdgggggfdg_____${response.statusCode}_________');
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = Getbannermodel.fromJson(json.decode(finalResponse));
      print("aaaaaaaa>>>>>>>>>>>>>$jsonResponse");
      setState(() {
        bannerModel = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  String? username;
//  String? address;
  UserProfile? getprofile;

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
      name = userModel!.username ?? "";
     /* print('${name}________');
      setState(() {
        getprofile = jsonResponse;
      });*/
    } else {
      print(response.reasonPhrase);
    }
  }

  RechrgeModel? rechargecard;
  String? name ;

  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    //getLocation();
    getUserProfile();
    getBanner();
  }
  getLocation() {
    GetLocation location = new GetLocation((result) {
      if (mounted) {
        setState(() {
          address = result.first.streetAddress;
          latitude = latitudeFirst;
          longitude = longitudeFirst;
          pickupCon.text = address;
          pickupCityCon.text = result.first.city;
          print(pickupCityCon.text);
        });
      }
    });
    location.getLoc();
  }
  Future _refresh() {
    return callAPI();
  }

  callAPI() async{
    getUserProfile();
    getBanner();
    
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }



  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();


  List<Widget> _buildDots() {
    List<Widget> dots = [];
    if (bannerModel == null) {
    } else {
      for (int i = 0; i < bannerModel!.data!.length; i++) {
        dots.add(
          Container(
            margin: EdgeInsets.all(1.5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentIndex == i ? MyColorName.mainColor : MyColorName.secondColor),
          ),
        );
      }
    }
    return dots;
  }

  // final formats = DateFormat("yyyy-MM-dd");
  late DateTime journeys;
  var fromLocation;

  var toLocation;

  String? date;
  double dropLatitude = 0, dropLongitude = 0;
  @override
  Widget build(BuildContext context) {

    print('${getprofile?.data?.profilePic}______');
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scaffold(
        key: _refreshIndicatorKey,
        appBar: AppBar(

          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child:  Image.network(
                userModel == null ?"":"${userModel!.profilePic}",fit: BoxFit.fill,),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: commonGradient(),
            ),
          ),
          title: Text(
            "Share My Ride",
          ),
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.white,
            onTap: (index){
              date = null;
            },
            indicatorWeight: 5,
            tabs: [
              Tab(
                text: "Auto",
              ),
              Tab(
                text: "Bus",
              ),
              Tab(
                text: "Car",
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => BusBookingPage(),));
                  Navigator.push(context, MaterialPageRoute(builder: (c)=> NotificationsPage()));
                },
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                )),
          ],
        ),
        backgroundColor: background,
        body: TabBarView(
          physics:const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            commonTabWidget("Book Auto", "Auto"),
            commonTabWidget("Book Bus", "Bus"),
            commonTabWidget("Book Car", "Car"),
          ],
        )
      ),
    );
  }
  Widget bikeRide(){
    return  Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Stack(children: [
                _carouselSlider(),
                Positioned(
                  bottom: 25,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDots(),
                  ),)
              ],)

          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Book Ride",
              style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: pickupCon,
                    readOnly: true,

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: Platform.isAndroid
                                ? "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0"
                                : "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0",
                            onPlacePicked: (result) {
                              if (currentIndex == 3) {
                                latitude = result.geometry!.location.lat;
                                longitude = result.geometry!.location.lng;
                                pickupCon.text =
                                    result.formattedAddress.toString();
                                if (result.formattedAddress
                                    .toString()
                                    .split(",")
                                    .length >
                                    2) {
                                  List<String> cityList = result
                                      .formattedAddress
                                      .toString()
                                      .split(",");
                                  setState(() {
                                    pickupCityCon.text =
                                    cityList[cityList.length - 3];
                                  });
                                }
                                /* getAddress(latitude, longitude)
                                        .then((value) {
                                      if (!value.first.city
                                          .toString()
                                          .contains("pricing"))
                                        setState(() {
                                          pickupCityCon.text =
                                              value.first.city.toString();
                                        });
                                    });*/
                              } else {
                                setState(() {
                                  pickupCon.text =
                                      result.formattedAddress.toString();
                                  latitude = result.geometry!.location.lat;
                                  longitude = result.geometry!.location.lng;
                                });
                              }

                              Navigator.of(context).pop();
                            },
                            initialPosition: LatLng(latitude, longitude),
                            useCurrentLocation: true,
                          ),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      labelText: "Pickup Location",
                      filled: true,
                      suffixIcon: currentIndex == 3
                          ? Text(pickupCityCon.text)
                          : null,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: dropCon,
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            apiKey: Platform.isAndroid
                                ? "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0"
                                : "AIzaSyBmUCtQ_DlYKSU_BV7JdiyoOu1i4ybe-z0",
                            onPlacePicked: (result) {
                              print(result.formattedAddress);
                              if (currentIndex == 3) {
                                dropLatitude =
                                    result.geometry!.location.lat;
                                dropLongitude =
                                    result.geometry!.location.lng;
                                dropCon.text = result.formattedAddress
                                    .toString();
                                if (result.formattedAddress
                                    .toString()
                                    .split(",")
                                    .length >
                                    2) {
                                  List<String> cityList = result
                                      .formattedAddress
                                      .toString()
                                      .split(",");
                                  setState(() {
                                    dropCityCon.text =
                                    cityList[cityList.length - 3];
                                  });
                                }
                                /*getAddress(
                                                  dropLatitude, dropLongitude)
                                              .then((value) {
                                            if (!value.first.city
                                                .toString()
                                                .contains("pricing"))
                                              setState(() {
                                                dropCityCon.text =
                                                    value.first.city.toString();
                                              });
                                          });*/
                              } else {
                                setState(() {
                                  dropCon.text = result
                                      .formattedAddress
                                      .toString();
                                  dropLatitude =
                                      result.geometry!.location.lat;
                                  dropLongitude =
                                      result.geometry!.location.lng;
                                });
                              }
                              Navigator.of(context).pop();
                              //  getBookInfo();
                              // getRides("3");
                            },
                            initialPosition: dropLatitude != 0
                                ? LatLng(dropLatitude, dropLongitude)
                                : LatLng(latitude, longitude),
                            useCurrentLocation: true,
                          ),
                        ),
                      );
                    },
                    decoration: InputDecoration(
                      labelText:"Drop Location",
                      enabledBorder: OutlineInputBorder(),
                      suffixIcon: currentIndex == 3
                          ? Text(dropCityCon.text)
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: commonButton(
                      title: "Continue",
                      context: context,
                      onPressed: ()async{
                        if (latitude != 0 && dropLatitude != 0) {
                          apiBaseHelper.postAPICall(Uri.parse("${baseUrl}get_vehicle_booking_charges"),{"type":"auto"}).then((value) {
                            if(!value['error']){
                              RazorPayHelper razorpayHelper = RazorPayHelper(value['data'][0]['charge'], context, (result) {
                                if(result=="error"){
                                  setState(() {
                                    loading = false;
                                  });
                                  setSnackBar("Payment Cancelled", context);
                                }else{
                                  transactionApi(value['data'][0]['charge'], result, value['data'][0]['type'],"");
                                }
                              });
                              setState(() {
                                loading = true;
                              });
                              razorpayHelper.init();
                            }else{
                              setSnackBar("Something went wrong", context);
                            }
                          });
                        } else {
                          setSnackBar(
                              "Please Pick Both Location", context);
                        }
                      }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget commonTabWidget(String title,String type){
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: 200,
              width: double.maxFinite,
              child: Stack(children: [
                _carouselSlider(),
                Positioned(
                  bottom: 25,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildDots(),
                  ),)
              ],)
            // getbannermodel == null? Center(child: CircularProgressIndicator(
            //   color: primary,
            // )):

          ),
          Card(
            margin: EdgeInsets.all(10.0),
            elevation: 2.0,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10,),
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    readOnly: true,
                    // validator: (value) {
                    //   if(value!.isEmpty){
                    //     return 'Please add from city' ;
                    //   }
                    //   return null;
                    // },
                    controller: fromController,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BusSearchScreen(
                                    isFrom: true),
                          )).then((value) {
                        if (value != null) {
                          if (value[1] == true) {
                            //${value[0].villageName??""} ${value[0].talukaName??""} ${value[0].stateName??""}
                            fromController.text =
                                "${value[0].name??""} ";
                            fromLocation = value[0];
                            setState(() {});
                          }
                        }
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "From",
                      counterText: '',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.location_on_outlined,
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
                      ),),
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    readOnly: true,
                    /*validator: (value){
                            if(value!.isEmpty){
                              return 'Please add to city' ;
                            }
                            return null;
                          },*/
                    controller: toController,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BusSearchScreen(
                                    isFrom: false),
                          )).then((value) {
                        if (value != null) {
                          if (value[1] == false) {
                            toController.text =
                            "${value[0].name??""}";
                            // ${value[0].villageName??""} ${value[0].talukaName??""} ${value[0].stateName??""}
                            toLocation = value[0];
                            setState(() {});
                          }
                        }
                      });
                    },
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "To",
                      counterText: '',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.location_on_outlined,
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
                      ),),
                  ),
                  const SizedBox(height: 15,),
                  DateTimeFormField(
                    decoration: InputDecoration(
                      fillColor: MyColorName.colorBg2,
                      filled: true,
                      labelText: "Journey Date",
                      counterText: '',
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.calendar_today,
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
                      ),),
                    mode:
                    DateTimeFieldPickerMode
                        .date,
                    firstDate: DateTime.now(),
                    autovalidateMode:
                    AutovalidateMode
                        .onUserInteraction,
                    validator: (e) {
                      var date = e?.add(
                          Duration(
                              hours: 23));
                      return (date ??
                          DateTime
                              .now())
                          .isBefore(
                          DateTime
                              .now())
                          ? 'Please select date after yesterday'
                          : null;
                    },
                    onDateSelected:
                        (DateTime value) {
                      print(value);
                      setState(() {
                        date = DateFormat('yyyy-MM-dd').format(value) ;
                      });


                    },
                  ),
                  const SizedBox(height: 30,),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: commonButton(
                          title: "Continue",
                          loading: loading,
                          context: context,
                          onPressed: ()async{
                            if(fromController.text==""){
                              setSnackBar("Select Pickup City", context);
                              return;
                            }
                            if(toController.text==""){
                              setSnackBar("Select Drop City", context);
                              return;
                            }
                            if(date==null){
                              setSnackBar("Select Journey Date", context);
                              return;
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        BookingList(
                                            fromCityId:
                                            fromLocation
                                                .id
                                                .toString(),
                                            toCityId: toLocation
                                                .id
                                                .toString(),
                                            date: date ?? '', vehicleType:type
                                        )));
                            /*apiBaseHelper.postAPICall(Uri.parse("${baseUrl}get_vehicle_booking_charges"),{"type":type}).then((value) {
                              if(!value['error']){
                                RazorPayHelper razorpayHelper = RazorPayHelper(value['data'][0]['charge'], context, (result) {
                                  if(result=="error"){
                                    setState(() {
                                      loading = false;
                                    });
                                    setSnackBar("Payment Cancelled", context);
                                  }else{
                                    transactionApi(value['data'][0]['charge'], result, value['data'][0]['type'],type);
                                  }
                                });
                                setState(() {
                                  loading = true;
                                });
                                razorpayHelper.init();
                              }else{
                                setSnackBar("Something went wrong", context);
                              }
                            });*/
                          }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _carouselSlider() {
    return Padding(
      padding: EdgeInsets.only(top: 18, bottom: 18, left: 10, right: 10),
      child: bannerModel == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                enlargeCenterPage: false,
                scrollDirection: Axis.horizontal,
                height: 180,
                onPageChanged: (position, reason) {
                  setState(() {
                    currentIndex = position;
                  });
                  print(reason);
                  print(CarouselPageChangedReason.controller);
                },
              ),
              items: bannerModel?.data?.map((val) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  // height: 180,
                  // width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "${val.image}",
                        fit: BoxFit.fill,
                      )),
                );
              }).toList(),
            ),
    );
  }

  void transactionApi(String charge,String transId,String type,String vehicleType)async{
    try{
      await App.init();
      Map param = {
        'user_id':curUserId,
        'amount':charge,
        'transaction_id':transId,
        'user_type':type,
      };
      var response = await apiBaseHelper.postAPICall(Uri.parse("${baseUrl}add_transaction"), param);
      setState(() {
        loading =false;
      });
      if(!response['error']){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BookingList(
                      fromCityId:
                      fromLocation
                          .id
                          .toString(),
                      toCityId: toLocation
                          .id
                          .toString(),
                      date: date ?? '', vehicleType:vehicleType
                    )));
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
  Future<void> searchBus() async {
    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiService.searchBusAvailable));
    request.fields.addAll({
      'from_city': fromLocation.id.toString(),
      'to_city': toLocation.id.toString()
    });

    request.headers.addAll(headers);

    print('${request.fields}');

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
