
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quick_pay/BottomNavigation/Account/notifications_page.dart';
import 'package:quick_pay/BottomNavigation/Home/Pages/passenger_information.dart';
import 'package:quick_pay/Components/color.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:quick_pay/model/bus_detail_model.dart';
import 'package:quick_pay/model/bus_model/bus_data_response.dart';

import '../model/BusDetailDesignResponse.dart';
import '../model/bus_stopage_model.dart';

class VehicleDetailScreen extends StatefulWidget {
  BusDataList model;
  String journeyDate;
  final String vehicleType;
  VehicleDetailScreen(
      {required this.model,
      required this.journeyDate,
      required this.vehicleType});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  BusDetailModel? model;
  BusDesignDataResponse? model2;
  StationModel? selectedPick;
  StationModel? selectedDrop;
  List<StationModel> pickList = [];
  List<StationModel> dropList = [];
  double totalAmount = 0;
  StopageData? pickupstage;
  StopageData? dropstage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVehicleDetail();
    getPlatformFee();
    getStopge();
  }

  String platformFee = "0";
  void getPlatformFee() {
    ApiBaseHelper().postAPICall(
        Uri.parse("${baseUrl}get_vehicle_booking_charges"),
        {"type": widget.vehicleType}).then((value) {
      if (!value['error']) {
        setState(() {
          platformFee = value['data'][0]['charge'];
        });
      } else {
        setSnackBar("Something went wrong", context);
      }
    });
  }

  BusStopgeModel busStopgeModel = BusStopgeModel();

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  Future<void> getVehicleDetail() async {
    setState(() {
      loading = true;
    });
    Map param = {'bus_id': widget.model.id, 'journey_date': widget.journeyDate};
    var response =
        await apiBaseHelper.postAPICall(Uri.parse(ApiService.busDetail), param);

    log('${response}');
    if (response['status']) {
      if(response['data']['type']=='auto' || response['data']['type']=='car' || response['data']['bus_type']!='Sleeper') {
        model = BusDetailModel.fromJson(response['data']);
        print('_________________after');
        setState(() {
          loading = false;
        });
      }else {

        model2 = BusDesignDataResponse.fromJson(response);
        setState(() {
          loading = false;
        });
      }
    } else {
      setSnackBar("Something went Wrong", context);
    }
  //  getStationDetail();
  }

  Future<void> getStationDetail() async {
    setState(() {
      loading = true;
    });
    Map param = {
      'bus_id': widget.model.id,
    };
    var response = await apiBaseHelper.postAPICall(
        Uri.parse(ApiService.pickupDrop), param);
    setState(() {
      loading = false;
    });
    if (response['status']) {
      for (var v in response['data']['pickup_points']) {
        pickList.add(StationModel.fromJson(v));
      }
      for (var v in response['data']['drop_points']) {
        dropList.add(StationModel.fromJson(v));
      }
      if (pickList.isNotEmpty) {
        selectedPick = pickList.first;
      }
      if (dropList.isNotEmpty) {
        selectedDrop = dropList.first;
      }
    } else {
      setSnackBar("Something went Wrong", context);
    }
  }

  List<String> selectedSeat = [];

  Future<void> getStopge() async {
    setState(() {
      loading = true;
    });
    Map param = {
      'bus_id': widget.model.id,
    };
    var response = await apiBaseHelper.postAPICall(
        Uri.parse(ApiService.pickupDrop), param);
    setState(() {
      loading = false;
    });
    log('${response}');
    if (response['status']) {
      busStopgeModel = BusStopgeModel.fromJson(response);
      setState(() {});
    } else {
      setSnackBar("Something went Wrong", context);
    }
  }
  calculate(){
  return  totalAmount+totalAmount*double.parse(platformFee)/100;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          widget.model.name ?? "",
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
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Platform Fee"), Text("₹${totalAmount * double.parse(platformFee) / 100}")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Sub Total"), Text("₹$totalAmount")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total"),
                  Text("₹${calculate()}")
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            commonButton(
              onPressed: () {
                if (selectedSeat.isEmpty) {
                  setSnackBar("Please Select Seat", context);
                  return;
                }
                if(model != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerInformation(
                          amount: "${calculate()}",
                          type: model!.type,
                          platformFee:
                              "${totalAmount * double.parse(platformFee) / 100}",
                          seatNoList: selectedSeat,
                          travelsName: model!.name,
                          date: widget.journeyDate,
                          busId: model!.id,
                          boarding: pickupstage ?? StopageData(),
                          dropping: dropstage ?? StopageData(),
                          cityFromAndTo: model!.jsonData,
                          timeFrom: model!.startTime,
                          timeTo: model!.endTime,
                        ),
                      ));
                }else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerInformation(
                          amount: "${calculate()}",
                          type: model2?.data?.type,
                          platformFee:
                          "${totalAmount * double.parse(platformFee) / 100}",
                          seatNoList: selectedSeat,
                          travelsName:  model2?.data?.name,
                          date: widget.journeyDate,
                          busId: model2?.data?.id,
                          boarding: pickupstage ?? StopageData(),
                          dropping: dropstage ?? StopageData(),
                          cityFromAndTo:  model2?.data?.jsonData,
                          timeFrom:  model2?.data?.startTime,
                          timeTo:  model2?.data?.endTime,
                        ),
                      ));
                }
              },
              loading: loading,
              title: "Continue",
              context: context,
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
      body: !loading
          ? model != null
              ? Column(
                  children: [
                    Card(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              model!.jsonData ?? "",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "Start - ${model!.startTime}   ->   End - ${model!.endTime}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Journey Date - ${widget.journeyDate}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pickup Point",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: busStopgeModel.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          pickupstage =
                                              busStopgeModel.data?[index];
                                          dropstage = null ;
                                        });

                                        ///unselect the seats for reset the amount
                                        model?.seatDesignList?.forEach((element) {
                                          element.forEach((element) {
                                            element.isChecked = false ;
                                          });
                                        });
                                        setState(() {
                                          totalAmount = 0.0;
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: pickupstage ==
                                                    busStopgeModel.data?[index]
                                                ? null
                                                : Colors.white,
                                            gradient: pickupstage ==
                                                    busStopgeModel.data?[index]
                                                ? commonGradient()
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.3))),
                                        margin: const EdgeInsets.all(5.0),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "${busStopgeModel.data?[index].name}(${busStopgeModel.data?[index].stopFromtime}to${busStopgeModel.data?[index].stopTotime})",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                  color: pickupstage ==
                                                          busStopgeModel
                                                              .data?[index]
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Drop Point",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: busStopgeModel.data?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        if (pickupstage != null && int.parse(pickupstage?.sr_no ?? '0') < int.parse(busStopgeModel.data?[index].sr_no ?? '0')) {
                                          setState(() {
                                            dropstage =
                                                busStopgeModel.data?[index];
                                            //   totalAmount=double.parse("${dropstage?.charge}")-double.parse("${pickupstage?.charge}");
                                          });
                                          ///unselect the seats for reset the amount
                                          model?.seatDesignList?.forEach((element) {
                                            element.forEach((element) {
                                              element.isChecked = false ;
                                            });
                                          });
                                          setState(() {
                                            totalAmount = 0.0;
                                          });
                                        } else {

                                          setSnackBar(
                                              "Please select valid Pickup Point", context);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: dropstage ==
                                                    busStopgeModel.data?[index]
                                                ? null
                                                : Colors.white,
                                            gradient: dropstage ==
                                                    busStopgeModel.data?[index]
                                                ? commonGradient()
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.3))),
                                        margin: const EdgeInsets.all(5.0),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "${busStopgeModel.data?[index].name}(${busStopgeModel.data?[index].stopFromtime}to${busStopgeModel.data?[index].stopTotime})",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(
                                                  color: dropstage ==
                                                          busStopgeModel
                                                              .data?[index]
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Seat",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: model!.seatDesignList!.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount:
                                            model?.seatDesignList?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          int seatRow = model!.seatDesignList![index]
                                              .length;
                                          print("Seatrow$seatRow");
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 10,
                                              left: 10,
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                    model!
                                                        .seatDesignList![index]
                                                        .length, (k) {
                                                  print(
                                                      "seat${(seatRow / 2).round()}");

                                                  return Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {

                                                          if (model!.seatDesignList![index][k].isSelected ?? false) {


                                                          }
                                                          else {
                                                            if (model!
                                                                .seatDesignList![
                                                                    index][k]
                                                                .isChecked!) {
                                                              if (pickupstage !=
                                                                      null &&
                                                                  dropstage !=
                                                                      null) {

                                                                totalAmount -= double
                                                                        .parse(
                                                                            "${pickupstage?.charge}") -
                                                                    double.parse(
                                                                        "${dropstage?.charge}");
                                                                model!
                                                                    .seatDesignList![
                                                                        index]
                                                                        [k]
                                                                    .isChecked = false;
                                                                selectedSeat.remove(model!
                                                                    .seatDesignList![
                                                                        index]
                                                                        [k]
                                                                    .id
                                                                    .toString());
                                                                setState(() {});
                                                              } else {
                                                                setState(() {
                                                                  totalAmount -=
                                                                      double.parse(
                                                                          model!
                                                                              .amount!);
                                                                  model!
                                                                      .seatDesignList![
                                                                          index]
                                                                          [k]
                                                                      .isChecked = false;
                                                                  selectedSeat.remove(model!
                                                                      .seatDesignList![
                                                                          index]
                                                                          [k]
                                                                      .id
                                                                      .toString());
                                                                });
                                                              }
                                                            } else {
                                                              if (pickupstage !=
                                                                      null &&
                                                                  dropstage !=
                                                                      null) {
                                                                totalAmount += double
                                                                        .parse(
                                                                            "${pickupstage?.charge}") -
                                                                    double.parse(
                                                                        "${dropstage?.charge}");
                                                                model!
                                                                    .seatDesignList![
                                                                        index]
                                                                        [k]
                                                                    .isChecked = true;
                                                                selectedSeat.add(model!
                                                                    .seatDesignList![
                                                                        index]
                                                                        [k]
                                                                    .id
                                                                    .toString());
                                                                setState(() {});
                                                              } else {
                                                                setState(() {
                                                                  totalAmount +=
                                                                      double.parse(
                                                                          model!
                                                                              .amount!);
                                                                  model!
                                                                      .seatDesignList![
                                                                          index]
                                                                          [k]
                                                                      .isChecked = true;
                                                                  selectedSeat.add(model!
                                                                      .seatDesignList![
                                                                          index]
                                                                          [k]
                                                                      .id
                                                                      .toString());
                                                                });
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: model!.busType=="Sleeper"?Container(
                                                          height: 60,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                            color: model!
                                                                .seatDesignList![
                                                            index]
                                                            [k]
                                                                .isSelected ??
                                                                false?Colors.grey: model!
                                                                .seatDesignList![
                                                            index]
                                                            [k]
                                                                .isChecked??false?MyColorName.mainColor:null,
                                                            border: Border.all(color: Colors.black),
                                                            borderRadius: BorderRadius.circular(5.0),
                                                          ),
                                                          padding:const EdgeInsets.all(2.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                            children: [
                                                              Container(
                                                                height: 10,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.black),
                                                                  borderRadius: BorderRadius.circular(5.0),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ):model!
                                                                    .seatDesignList![
                                                                        index]
                                                                        [k]
                                                                    .isSelected ??
                                                                false
                                                            ? Image.asset(
                                                                'assets/imgs/chair3.png',
                                                                height: 30,
                                                                width: 30,
                                                                scale: 5)
                                                            : model!
                                                                    .seatDesignList![
                                                                        index]
                                                                        [k]
                                                                    .isChecked!
                                                                ? Image.asset(
                                                                    'assets/imgs/chair2.png',
                                                                    height: 30,
                                                                    width: 30,
                                                                    scale: 5)
                                                                : Image.asset(
                                                                    'assets/imgs/chair1.png',
                                                                    height: 30,
                                                                    width: 30,
                                                                    scale: 5),
                                                      ),
                                                      (seatRow==4&&k==1)||(seatRow==3&&k==1&&model!.type=="Bus")
                                                          ? const SizedBox(
                                                              width: 40,
                                                            ):(seatRow==2&&k==0)?const SizedBox(
                                                        width: 0,
                                                      )
                                                          : SizedBox(
                                                              width: 5,
                                                            )
                                                    ],
                                                  );
                                                })),
                                          );
                                        })
                                    : model!.seatDesign!.isNotEmpty
                                        ? ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            itemCount:
                                                model!.seatDesign!.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 10,
                                                ),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        if (model!
                                                                .seatDesign![
                                                                    index]
                                                                .isSelected ??
                                                            false) {
                                                        } else {
                                                          if (model!
                                                              .seatDesign![
                                                                  index]
                                                              .isChecked!) {
                                                            setState(() {
                                                              totalAmount -= double
                                                                  .parse(model!
                                                                      .amount!);
                                                              model!
                                                                  .seatDesign![
                                                                      index]
                                                                  .isChecked = false;
                                                              selectedSeat
                                                                  .remove(model!
                                                                      .seatDesign![
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                            });
                                                          } else {
                                                            setState(() {
                                                              totalAmount += double
                                                                  .parse(model!
                                                                      .amount!);
                                                              model!
                                                                  .seatDesign![
                                                                      index]
                                                                  .isChecked = true;
                                                              selectedSeat.add(model!
                                                                  .seatDesign![
                                                                      index]
                                                                  .id
                                                                  .toString());
                                                            });
                                                          }
                                                        }
                                                      },
                                                      child: model!
                                                                  .seatDesign![
                                                                      index]
                                                                  .isSelected ??
                                                              false
                                                          ? Image.asset(
                                                              'assets/imgs/chair3.png',
                                                              height: 30,
                                                              width: 30,
                                                              scale: 5)
                                                          : model!
                                                                  .seatDesign![
                                                                      index]
                                                                  .isChecked!
                                                              ? Image.asset(
                                                                  'assets/imgs/chair2.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                  scale: 5)
                                                              : Image.asset(
                                                                  'assets/imgs/chair1.png',
                                                                  height: 30,
                                                                  width: 30,
                                                                  scale: 5),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    )
                                                  ],
                                                ),
                                              );
                                            })
                                        : const SizedBox(
                                            width: 30,
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : model2!= null ? busViewWidget(): Center(
                  child: Text("No Detail Found"),
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget busViewWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    model2?.data?.jsonData ?? "",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Start - ${model2?.data?.startTime}   ->   End - ${model2?.data?.endTime}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Journey Date - ${widget.journeyDate}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pickup Point",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: busStopgeModel.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                pickupstage =
                                busStopgeModel.data?[index];
                                dropstage = null ;


                                ///unselect the seats for reset the amount
                                if(model2?.upperDeck?.isNotEmpty ?? false) {
                                  model2?.upperDeck?.forEach((element) {
                                    element.forEach((element) {
                                      element.isChecked = false;
                                    });
                                  });
                                }
                                if(model2?.lowerDeck?.isNotEmpty ?? false) {
                                  model2?.lowerDeck?.forEach((element) {
                                    element.forEach((element) {
                                      element.isChecked = false;
                                    });
                                  });
                                }

                                setState(() {
                                  totalAmount = 0.0;
                                });
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: pickupstage ==
                                      busStopgeModel.data?[index]
                                      ? null
                                      : Colors.white,
                                  gradient: pickupstage ==
                                      busStopgeModel.data?[index]
                                      ? commonGradient()
                                      : null,
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.grey
                                          .withOpacity(0.3))),
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  "${busStopgeModel.data?[index].name}(${busStopgeModel.data?[index].stopFromtime}to${busStopgeModel.data?[index].stopTotime})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                    color: pickupstage ==
                                        busStopgeModel
                                            .data?[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              width: double.infinity,
              height: 100,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Drop Point",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: busStopgeModel.data?.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (pickupstage != null && int.parse(pickupstage?.sr_no ?? '0') < int.parse(busStopgeModel.data?[index].sr_no ?? '0')) {
                                setState(() {
                                  dropstage =
                                  busStopgeModel.data?[index];
                                  //   totalAmount=double.parse("${dropstage?.charge}")-double.parse("${pickupstage?.charge}");
                                });
                                ///unselect the seats for reset the amount
                                if(model2?.upperDeck?.isNotEmpty ?? false) {
                                  model2?.upperDeck?.forEach((element) {
                                    element.forEach((element) {
                                      element.isChecked = false;
                                    });
                                  });
                                }
                                if(model2?.lowerDeck?.isNotEmpty ?? false) {
                                  model2?.lowerDeck?.forEach((element) {
                                    element.forEach((element) {
                                      element.isChecked = false;
                                    });
                                  });
                                }

                                setState(() {
                                  totalAmount = 0.0;
                                });
                              } else {
                                setSnackBar(
                                    "Please Pickup Point", context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: dropstage ==
                                      busStopgeModel.data?[index]
                                      ? null
                                      : Colors.white,
                                  gradient: dropstage ==
                                      busStopgeModel.data?[index]
                                      ? commonGradient()
                                      : null,
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.grey
                                          .withOpacity(0.3))),
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  "${busStopgeModel.data?[index].name}(${busStopgeModel.data?[index].stopFromtime}to${busStopgeModel.data?[index].stopTotime})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                    color: dropstage ==
                                        busStopgeModel
                                            .data?[index]
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              width: double.infinity,
                 color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Seat",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  tabBar(),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(

                      height:350,
                      color: Colors.grey.withOpacity(0.2),

                      width: MediaQuery.of(context).size.width/2.15,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(10),
                      child: _buttonUpper ? ListView.builder(

                        shrinkWrap: true,

                        itemCount: model2?.upperDeck?.length,
                        itemBuilder: (context, index) {
                        return deckView(model2?.upperDeck?[index]);
                      },) : ListView.builder(

                        shrinkWrap: true,

                        itemCount: model2?.lowerDeck?.length,
                        itemBuilder: (context, index) {
                          return deckView(model2?.lowerDeck?[index]);
                        },),),
                  ),
                  /*Expanded(
                    child: model!.seatDesignList!.isNotEmpty
                        ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                        model!.seatDesignList!.length,
                        itemBuilder: (context, index) {
                          int seatRow = model!.seatDesignList![index]
                              .length;
                          print("Seatrow$seatRow");
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                            ),
                            child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    model!
                                        .seatDesignList![index]
                                        .length, (k) {
                                  print(
                                      "seat${(seatRow / 2).round()}");
                                  return Row(
                                    children: [
                                      InkWell(
                                        onTap: () {

                                          if (model!.seatDesignList![index][k].isSelected ?? false) {


                                          }
                                          else {
                                            if (model!
                                                .seatDesignList![
                                            index][k]
                                                .isChecked!) {
                                              if (pickupstage !=
                                                  null &&
                                                  dropstage !=
                                                      null) {

                                                totalAmount -= double
                                                    .parse(
                                                    "${dropstage?.charge}") -
                                                    double.parse(
                                                        "${pickupstage?.charge}");
                                                model!
                                                    .seatDesignList![
                                                index]
                                                [k]
                                                    .isChecked = false;
                                                selectedSeat.remove(model!
                                                    .seatDesignList![
                                                index]
                                                [k]
                                                    .id
                                                    .toString());
                                                setState(() {});
                                              } else {
                                                setState(() {
                                                  totalAmount -=
                                                      double.parse(
                                                          model!
                                                              .amount!);
                                                  model!
                                                      .seatDesignList![
                                                  index]
                                                  [k]
                                                      .isChecked = false;
                                                  selectedSeat.remove(model!
                                                      .seatDesignList![
                                                  index]
                                                  [k]
                                                      .id
                                                      .toString());
                                                });
                                              }
                                            } else {
                                              if (pickupstage !=
                                                  null &&
                                                  dropstage !=
                                                      null) {
                                                totalAmount += double
                                                    .parse(
                                                    "${dropstage?.charge}") -
                                                    double.parse(
                                                        "${pickupstage?.charge}");
                                                model!
                                                    .seatDesignList![
                                                index]
                                                [k]
                                                    .isChecked = true;
                                                selectedSeat.add(model!
                                                    .seatDesignList![
                                                index]
                                                [k]
                                                    .id
                                                    .toString());
                                                setState(() {});
                                              } else {
                                                setState(() {
                                                  totalAmount +=
                                                      double.parse(
                                                          model!
                                                              .amount!);
                                                  model!
                                                      .seatDesignList![
                                                  index]
                                                  [k]
                                                      .isChecked = true;
                                                  selectedSeat.add(model!
                                                      .seatDesignList![
                                                  index]
                                                  [k]
                                                      .id
                                                      .toString());
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: model!.busType=="Sleeper"?Container(
                                          height: 60,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: model!
                                                .seatDesignList![
                                            index]
                                            [k]
                                                .isSelected ??
                                                false?Colors.grey: model!
                                                .seatDesignList![
                                            index]
                                            [k]
                                                .isChecked??false?MyColorName.mainColor:null,
                                            border: Border.all(color: Colors.black),
                                            borderRadius: BorderRadius.circular(5.0),
                                          ),
                                          padding:const EdgeInsets.all(2.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(5.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ):model!
                                            .seatDesignList![
                                        index]
                                        [k]
                                            .isSelected ??
                                            false
                                            ? Image.asset(
                                            'assets/imgs/chair3.png',
                                            height: 30,
                                            width: 30,
                                            scale: 5)
                                            : model!
                                            .seatDesignList![
                                        index]
                                        [k]
                                            .isChecked!
                                            ? Image.asset(
                                            'assets/imgs/chair2.png',
                                            height: 30,
                                            width: 30,
                                            scale: 5)
                                            : Image.asset(
                                            'assets/imgs/chair1.png',
                                            height: 30,
                                            width: 30,
                                            scale: 5),
                                      ),
                                      (seatRow==4&&k==1)||(seatRow==3&&k==1&&model!.type=="Bus")
                                          ? const SizedBox(
                                        width: 40,
                                      ):(seatRow==2&&k==0)?const SizedBox(
                                        width: 110,
                                      )
                                          : SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  );
                                })),
                          );
                        })
                        : model!.seatDesign!.isNotEmpty
                        ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount:
                        model!.seatDesign!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: 10,
                              left: 10,
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (model!
                                        .seatDesign![
                                    index]
                                        .isSelected ??
                                        false) {
                                    } else {
                                      if (model!
                                          .seatDesign![
                                      index]
                                          .isChecked!) {
                                        setState(() {
                                          totalAmount -= double
                                              .parse(model!
                                              .amount!);
                                          model!
                                              .seatDesign![
                                          index]
                                              .isChecked = false;
                                          selectedSeat
                                              .remove(model!
                                              .seatDesign![
                                          index]
                                              .id
                                              .toString());
                                        });
                                      } else {
                                        setState(() {
                                          totalAmount += double
                                              .parse(model!
                                              .amount!);
                                          model!
                                              .seatDesign![
                                          index]
                                              .isChecked = true;
                                          selectedSeat.add(model!
                                              .seatDesign![
                                          index]
                                              .id
                                              .toString());
                                        });
                                      }
                                    }
                                  },
                                  child: model!
                                      .seatDesign![
                                  index]
                                      .isSelected ??
                                      false
                                      ? Image.asset(
                                      'assets/imgs/chair3.png',
                                      height: 30,
                                      width: 30,
                                      scale: 5)
                                      : model!
                                      .seatDesign![
                                  index]
                                      .isChecked!
                                      ? Image.asset(
                                      'assets/imgs/chair2.png',
                                      height: 30,
                                      width: 30,
                                      scale: 5)
                                      : Image.asset(
                                      'assets/imgs/chair1.png',
                                      height: 30,
                                      width: 30,
                                      scale: 5),
                                ),
                                SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          );
                        })
                        : const SizedBox(
                      width: 30,
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _buttonUpper = true;
  bool _buttonLower = false;

  void _handleButton1Tap() {
    setState(() {
       _buttonUpper = true;
       _buttonLower = false;
    });
  }

  void _handleButton2Tap() {
    setState(() {
       _buttonUpper = false;
       _buttonLower = true;
    });
  }

  Widget tabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 40,
           // width: 40,
            decoration: BoxDecoration(
              gradient: _buttonUpper ?  commonGradient() : LinearGradient(colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.circular(10),
            ),
            child:ElevatedButton(
              onPressed: _handleButton1Tap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child:  Text(
                'Upper',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: _buttonUpper ? Colors.white : Colors.black,fontSize: 16),
              )

            )
        ),
        Container(
            height: 40,
            //width: 40,
            decoration: BoxDecoration(
              gradient: _buttonLower ?  commonGradient() : LinearGradient(colors: [Colors.white, Colors.white]),
              borderRadius: BorderRadius.circular(10),
            ),
            child:ElevatedButton(
                onPressed: _handleButton2Tap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child:  Text(
                  'Lower',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: _buttonLower ? Colors.white : Colors.black,fontSize: 16),
                )

            )
        )
      ],
    );
  }

  Widget deckView(List<BusDeck>? deck) {
    return Row(
      mainAxisSize: MainAxisSize.min,
     // mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(deck?.length ?? 0, (i) {
      return model2?.data?.busType =="Sleeper" ? InkWell(
        onTap: (){
          if (deck?[i].isSelected ?? false) {


          }
          else {

            if (deck![i].isChecked!) {
              if (pickupstage !=
                  null &&
                  dropstage !=
                      null) {

                totalAmount -= double
                    .parse(
                    "${pickupstage?.charge}") -
                    double.parse(
                        "${dropstage?.charge}");
                deck[i].isChecked = false;
                selectedSeat.remove(deck[i].id
                    .toString());
                setState(() {});
              } else {
                setState(() {
                  totalAmount -=
                      double.parse(
                          model2!.data!
                              .amount!);
                  deck[i].isChecked = false;
                  selectedSeat.remove(deck[i].id
                      .toString());
                });
              }
            } else {

              if (pickupstage !=
                  null &&
                  dropstage !=
                      null) {
                totalAmount += double
                    .parse(
                    "${pickupstage?.charge}") -
                    double.parse(
                        "${dropstage?.charge}");
                deck[i].isChecked = true;
                selectedSeat.add(deck[i].id
                    .toString());
                setState(() {});
              } else {


                setState(() {
                  totalAmount +=
                      double.parse(
                          model2!.data!
                              .amount!);
                  deck[i].isChecked = true;
                  selectedSeat.add(deck[i].id
                      .toString());
                });
              }
            }
          }
          setState(() {

          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15,),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 30,
                decoration: BoxDecoration(
                  color: deck![i]
                      .isSelected ??
                      false? Colors.grey:
                  deck[i].isChecked ?? false? MyColorName.mainColor:null,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding:const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ],
                ),
              ),
              i==0 ? SizedBox(width: 50,): i==1 ? SizedBox(width: 5,): SizedBox()
            ],
          ),
        ),
      ) : InkWell(
        onTap: (){
          if (deck?[i].isSelected ?? false) {


          }
          else {
            if (deck![i].isChecked!) {
              if (pickupstage !=
                  null &&
                  dropstage !=
                      null) {

                totalAmount -= double
                    .parse(
                    "${pickupstage?.charge}") -
                    double.parse(
                        "${dropstage?.charge}");
                deck[i].isChecked = false;
                selectedSeat.remove(deck[i].id
                    .toString());
                setState(() {});
              } else {
                setState(() {
                  totalAmount -=
                      double.parse(
                          model2!.data!
                              .amount!);
                  deck?[i].isChecked = false;
                  selectedSeat.remove(deck[i].id
                      .toString());
                });
              }
            } else {

              if (pickupstage !=
                  null &&
                  dropstage !=
                      null) {
                totalAmount += double
                    .parse(
                    "${pickupstage?.charge}") -
                    double.parse(
                        "${dropstage?.charge}");
                deck[i].isChecked = true;
                selectedSeat.add(deck[i].id
                    .toString());
                setState(() {});
              } else {
                setState(() {
                  totalAmount +=
                      double.parse(
                          model2!.data!
                              .amount!);
                  deck?[i].isChecked = true;
                  selectedSeat.add(deck[i].id
                      .toString());
                });
              }
            }
          }

          setState(() {

          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              deck?[i].isSelected ?? false
                  ? Image.asset(
                  'assets/imgs/chair3.png',
                  height: 30,
                  width: 30,
                  scale: 5)
                  : deck?[i].isChecked ?? false
                  ? Image.asset(
                  'assets/imgs/chair2.png',
                  height: 30,
                  width: 30,
                  scale: 5)
                  : Image.asset(
                  'assets/imgs/chair1.png',
                  height: 30,
                  width: 30,
                  scale: 5),
              i==0 ? SizedBox(width: 50,): i==1 ? SizedBox(width: 5): SizedBox()
            ],
          ),
        ),
      ) ;
    }),);
  }

}
