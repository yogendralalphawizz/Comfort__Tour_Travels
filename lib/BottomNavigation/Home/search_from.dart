import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_pay/Theme/colors.dart';
import 'dart:convert';

import 'package:quick_pay/helper/apiservices.dart';
import 'package:quick_pay/model/bus_model/from_to_location_serach_response.dart';
import 'package:quick_pay/model/taluka_model.dart';

import '../../Config/ApiBaseHelper.dart';
import '../../Config/colors.dart';
import '../../Config/common.dart';
import '../../Config/constant.dart';
import '../../model/state_model.dart';

class BusSearchScreen extends StatefulWidget {

  BusSearchScreen({Key? key, required this.isFrom });

  bool isFrom;

  @override
  _BusSearchScreenState createState() => _BusSearchScreenState();
}

class _BusSearchScreenState extends State<BusSearchScreen> {
  // Declare variables to store the user's input and the search suggestions


  LocationSearchList? _fromLocation;

  final fromController = TextEditingController();
  final toController = TextEditingController();


  FromAndToLocationSarchResponse? fromAndToResponse;

  List <LocationSearchList> locationSearchData = [];
bool isLoading = false ;
  dynamic? stateId, cityId,talukaId,villageId;
  List<StateModel> stateList = [];
  List<CityModel> cityList = [];
 // TalukaModel talukaModel
  bool loading = false;

 // get apiBaseHelper => null;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  void getStateApi() async {
    try {
      Map param = {};
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_states"), param);
      print("hello"+response.toString());
      setState(() {
        loading = false;
      });
      for (var v in response['data']) {
        print("hello");
        setState(() {
          stateList.add(StateModel.fromJson(v));
        });

      }
      // if(widget.model!.state!=null){
      //   int index = stateList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.state!.toLowerCase());
      //   if(index!=-1){
      //     stateId = stateList[index].id;
      //     getCityApi();
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

  void getCityApi() async {
    try {
      Map param = {
        'state_id': stateId.id,
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
  // void getTalukaApi() async {
  //   try {
  //     Map param = {
  //       'state_id': cityId.id,
  //     };
  //     var response = await apiBaseHelper.postAPICall(
  //         Uri.parse("${baseUrl}get_taluka"), param);
  //     setState(() {
  //       loading = false;
  //     });
  //     for (var v in response['data']) {
  //       setState(() {
  //         cityList.add(CityModel.fromJson(v));
  //       });
  //     }
  //     // if(widget.model!.city!=null){
  //     //   int index = cityList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.city!.toLowerCase());
  //     //   if(index!=-1){
  //     //     cityId = cityList[index].id;
  //     //
  //     //   }
  //     // }
  //   } catch (e) {
  //     setState(() {
  //       loading = false;
  //     });
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }
  // void getVillageApi() async {
  //   try {
  //     Map param = {
  //       'state_id': talukaId.id,
  //     };
  //     var response = await apiBaseHelper.postAPICall(
  //         Uri.parse("${baseUrl}get_village"), param);
  //     setState(() {
  //       loading = false;
  //     });
  //     for (var v in response['data']) {
  //       setState(() {
  //         cityList.add(CityModel.fromJson(v));
  //       });
  //     }
  //     // if(widget.model!.city!=null){
  //     //   int index = cityList.indexWhere((element) => element.name!.toLowerCase() ==widget.model!.city!.toLowerCase());
  //     //   if(index!=-1){
  //     //     cityId = cityList[index].id;
  //     //
  //     //   }
  //     // }
  //   } catch (e) {
  //     setState(() {
  //       loading = false;
  //     });
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    getStateApi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: primary,),),
        title: Text("Location", style: TextStyle(color: primary),),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
            children: [
            TextFormField(
            onChanged: (vlaue){
                getSuggestions(vlaue);
                },
        controller: widget.isFrom ? fromController : toController,
        decoration: InputDecoration(
            hintText: widget.isFrom ? 'From' : 'To',
          fillColor: MyColorName.colorBg2,
          filled: true,
          prefixIcon: IconButton(
            onPressed: null,
            icon: Icon(
              Icons.search,
              color: MyColorName.secondColor,
            ),
          ),
          suffixIcon: fromController.text!=""||toController.text!=""?IconButton(
            onPressed: (){
              setState(() {
                fromController.text = "";
                toController.text = "";
                locationSearchData.clear();
              });
            },
            icon: Icon(
              Icons.close,
              color: MyColorName.secondColor,
            ),
          ):null,
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
                SizedBox(height: 16.0),
              Expanded(child: isLoading
                  ? Center(child: CircularProgressIndicator(),)
                  : locationSearchData.isEmpty ? Center(
                child: Text('No location found'),) :
              ListView.builder(
                shrinkWrap: true,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: locationSearchData.length,
                itemBuilder: (context, index) =>
                    InkWell(onTap: (){
                      Navigator.pop(context, [locationSearchData[index], widget.isFrom ? true : false]);
                    },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Material(
                          color: Colors.transparent,
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            tileColor: MyColorName.mainColor.withOpacity(0.1),
                            //${locationSearchData[index].villageName??""} ${locationSearchData[index].talukaName??""}
                            title: Text("${locationSearchData[index].name??""}" ?? ''),
                            subtitle: Text("${locationSearchData[index].stateName??""}"),
                            trailing: Icon(
                              Icons.keyboard_arrow_right_sharp,
                              color: MyColorName.secondColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                // Button to initiate the search
                /*ElevatedButton(
              onPressed: () {
                // TODO: Implement search functionality
              },
              child: Text("Search"),
                          ),*/
              ),),

              // boxHeight(2, context),
              // Padding(
              //   padding:
              //   EdgeInsets.symmetric(horizontal: getWidth(2, context)),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: MyColorName.colorBg2,
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     padding: EdgeInsets.symmetric(
              //         horizontal: getWidth(4, context)),
              //     child: DropdownButton<dynamic>(
              //       hint: Text("Select State",style: TextStyle(color: Colors.black87),),
              //       value: stateId,
              //       icon: Icon(
              //         Icons.keyboard_arrow_down_outlined,
              //         color: MyColorName.secondColor,
              //       ),
              //       items: stateList.map((StateModel value) {
              //         return DropdownMenuItem<dynamic>(
              //           value: value,
              //           child: Text(value.name!),
              //         );
              //       }).toList(),
              //       isExpanded: true,
              //       underline: SizedBox(),
              //       onChanged: ( value) {
              //         setState(() {
              //           stateId = value;
              //           cityId = null;
              //           cityList.clear();
              //         });
              //         getCityApi();
              //       },
              //     ),
              //   ),
              // ),
              // boxHeight(2, context),
              // cityList.isNotEmpty?Padding(
              //   padding:
              //   EdgeInsets.symmetric(horizontal: getWidth(2, context)),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: MyColorName.colorBg2,
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //     padding: EdgeInsets.symmetric(
              //         horizontal: getWidth(4, context)),
              //     child: DropdownButton<dynamic>(
              //       hint: Text("Select City",style: TextStyle(color: Colors.black87),),
              //       value: cityId,
              //       icon: Icon(
              //         Icons.keyboard_arrow_down_outlined,
              //         color: MyColorName.secondColor,
              //       ),
              //       items: cityList.map((CityModel value) {
              //         return DropdownMenuItem<dynamic>(
              //           value: value,
              //           child: Text(value.name!),
              //         );
              //       }).toList(),
              //       isExpanded: true,
              //       underline: SizedBox(),
              //       onChanged: (value) {
              //         setState(() {
              //           cityId = value;
              //           print(value.id);
              //         });
              //       },
              //     ),
              //   ),
              // ):SizedBox(),
              //
              //
              //
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: commonButton(
              //         title: "Sumbit",
              //         loading: loading,
              //         context: context,
              //         onPressed: ()async{
              //           if(stateId==""||stateId==null){
              //             setSnackBar(" Please Select State ", context);
              //             return;
              //           }
              //           if(cityId==""||cityId==null){
              //             setSnackBar("Please Select City ", context);
              //             return;
              //           }
              //           // if(date==null){
              //           //   setSnackBar("Select Journey Date", context);
              //           //   return;
              //           // }
              //           Navigator.pop(context, ["${stateId.name},${cityId.name}", widget.isFrom ? true : false]);
              //
              //           /*apiBaseHelper.postAPICall(Uri.parse("${baseUrl}get_vehicle_booking_charges"),{"type":type}).then((value) {
              //               if(!value['error']){
              //                 RazorPayHelper razorpayHelper = RazorPayHelper(value['data'][0]['charge'], context, (result) {
              //                   if(result=="error"){
              //                     setState(() {
              //                       loading = false;
              //                     });
              //                     setSnackBar("Payment Cancelled", context);
              //                   }else{
              //                     transactionApi(value['data'][0]['charge'], result, value['data'][0]['type'],type);
              //                   }
              //                 });
              //                 setState(() {
              //                   loading = true;
              //                 });
              //                 razorpayHelper.init();
              //               }else{
              //                 setSnackBar("Something went wrong", context);
              //               }
              //             });*/
              //         }
              //     ),
              //   ),
              // ),
          ]
                ),
    ),);
  }




  Future<void> getSuggestions(String query) async {
    setState(() {
      isLoading =true ;
    });
    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiService.getLocationSearch));
    request.fields.addAll({
      'search_text': query
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    print('${ Uri.parse(ApiService.getLocationSearch)}________');
    print('${request.fields}________');
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      setState(() {
        isLoading = false ;
      });
      if(json.decode(result)!=null){
        var finalResult = FromAndToLocationSarchResponse.fromJson(json.decode(result));
          fromAndToResponse = finalResult;
          locationSearchData = finalResult.data ?? [];
          if(locationSearchData.isEmpty){
            locationSearchData.clear() ;
          }

      }

    } else {
      throw Exception("Failed to load suggestions");
    }
  }

}
