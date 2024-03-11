import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_pay/BottomNavigation/Home/seats_detail_creen.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:http/http.dart' as http;
import 'package:quick_pay/model/bus_model/bus_data_response.dart';
import 'package:quick_pay/splash/vehicle_detail_screen.dart';

import 'booking_Details.dart';

class BookingList extends StatefulWidget {
  const BookingList(
      {Key? key,
      required this.fromCityId,
      required this.toCityId,
      required this.vehicleType,
      required this.date})
      : super(key: key);
  final String fromCityId;
  final String vehicleType;
  final String toCityId;

  final String date;

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchBus();
  }

  List<BusDataList> busDataList = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: commonGradient(),
          ),
        ),
        title: Text(
          "Vehicle List",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await searchBus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Text("${busDataList.length} VEHICLE FOUND"),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : busDataList.isEmpty
                    ? Expanded(child: Center(child: Text("Sorry No Ride Available",style: TextStyle(color: Colors.black,fontSize: 25),)))
            // Center(
            //             child: Column(
            //               children: [
            //                 SizedBox(
            //                   height: 50,
            //                 ),
            //                 Image.asset('assets/imgs/nobusavailable.png')
            //               ],
            //             ),
            //           )
                    : Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(5.0),
                          itemCount: busDataList.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            color: Colors.black,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            var model = busDataList[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleDetailScreen(
                                              model: model,
                                              journeyDate: widget.date,
                                              vehicleType:
                                                  model.type.toString(),
                                            )));
                              },
                              child: Card(
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [

                                      Text(
                                        "${model.jsonData}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${model.startTime}   ->  ${model.endTime}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          commonButton(
                                            height: 4,
                                            width: null,
                                            fontSize: 10.0,
                                            onPressed: () {},
                                            loading: false,
                                            title: "Type - ${model.busType=='null' ? '' : model.busType}",
                                            context: context,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          commonButton(
                                            height: 4,
                                            width: null,
                                            fontSize: 10.0,
                                            onPressed: () {},
                                            loading: false,
                                            title:
                                                "Seat Type - ${model.seatType}",
                                            context: context,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Available Seats - ${model.availableSeats}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                          Text(
                                            "Seats - ${model.noOfSeat}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Text(
                                          "Rent - ${model.amount}/-",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      commonButton(
                                        height: 4,
                                        fontSize: 10.0,
                                        onPressed: () {},
                                        loading: false,
                                        title: "Travel Name - ${model.name}",
                                        context: context,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    )
          ],
        ),
      ),
    );
  }

  Future<void> searchBus() async {
    setState(() {
      isLoading = true;
    });
    var headers = {
      'Cookie': 'ci_session=ba5b65aa074927b9d9c1a401ca8edf20b7aeba71'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiService.searchBusAvailable));
    request.fields.addAll({
      'from_city': widget.fromCityId,
      'to_city': widget.toCityId,
      'type': widget.vehicleType.toLowerCase(),
      'journey_date': widget.date
    });
    print(request.fields);
    print("this is bus booking list ${ApiService.searchBusAvailable}");
    print("this is bus booking list ${request.fields.toString()}");

    request.headers.addAll(headers);

    print('${request.fields}');

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = BusDataResponse.fromJson(jsonDecode(result));

      setState(() {
        busDataList = finalResult.data ?? [];
        isLoading = false;
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
        isLoading = false;
      });
    }
  }
}
