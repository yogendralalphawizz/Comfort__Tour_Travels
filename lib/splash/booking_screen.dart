import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:quick_pay/BottomNavigation/Account/notifications_page.dart';
import 'package:quick_pay/Config/ApiBaseHelper.dart';
import 'package:quick_pay/Config/colors.dart';
import 'package:quick_pay/Config/common.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:quick_pay/model/booking_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen();

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  TabController? tabController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  bool loading = false;
  List<BookingModel> bookingList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    getBooking();
  }

  bool updateLoading = false;
  void updateBooking(busId, status, index) async {
    setState(() {
      updateLoading = true;
    });
    Map param = {
      'id': busId,
      'status': "4",
      'date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
    };
    Map response = await apiBaseHelper.postAPICall(
        Uri.parse("${baseUrl}cancel_booking"), param);
    setState(() {
      updateLoading = false;
    });
    if (!response['error']) {
      setState(() {
        if (status == "0") {
          bookingList[index].status = "Started";
        } else if (status == "1") {
          bookingList[index].status = "Completed";
        } else {
          bookingList[index].status = "Cancelled";
        }
      });
    } else {
      setSnackBar("Something went wrong", context);
    }
  }
  void updateRating(bookingId,driverId, rating,comment, index) async {
    setState(() {
      updateLoading = true;
    });
    Map param = {
      'user_id': curUserId,
      'driver_id': driverId,
      'booking_id': bookingId,
      'rev_stars': rating.toString(),
      'rev_text':comment,
    };
    Map response = await apiBaseHelper.postAPICall(
        Uri.parse("${baseUrl}booking_rating"), param);
    setState(() {
      updateLoading = false;
    });
    if (!response['error']) {
      setSnackBar("Rating submitted", context);
      setState(() {
       // bookingList[index].status = "Cancelled";
      });
    } else {
      setSnackBar(response['msg'].toString(), context);
    }
  }
  void getBooking() async {
    setState(() {
      loading = true;
    });
    Map param = {
      'user_id': curUserId,
      'type': tabController!.index == 0
          ? "auto"
          : tabController!.index == 1
              ? "Bus"
              : "Car",
    };
    Map response =
        await apiBaseHelper.postAPICall(Uri.parse(ApiService.bookings), param);
    setState(() {
      loading = false;
      bookingList.clear();
    });
    log('${ response['data']}');
    if (response['status']) {
      for (var v in response['data']) {
        bookingList.add(BookingModel.fromJson(v));
      }
    } else {
      setSnackBar("Something went wrong", context);
    }
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
          "My Bookings",
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          onTap: (index) {
            getBooking();
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
      body: !loading
          ? bookingList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: bookingList.length,
                  itemBuilder: (context, index) {
                    BookingModel model = bookingList[index];
                    return InkWell(
                      onTap: () {
                        print(model.busDetail);
                        if (model.busDetail != null) {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  title: Text(
                                      "${model.busDetail!.name}(${model.busDetail!.vehicleNo})"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "Seat Type - ${model.busDetail!.seatType}"),
                                          Text(
                                              "Type - ${model.busDetail?.busType == 'null' ? '' :model.busDetail?.busType}"),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "Total Seats - ${model.busDetail!.noOfSeat}"),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                          "Driver Name - ${model.busDetail!.driverName}"),
                                      SizedBox(height: 5,),
                                      Text(
                                          "Driver Mobile - ${model.busDetail!.driverMobile}"),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shadowColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                        child: Text(
                                          "DONE!!",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14),
                                        )),
                                    ElevatedButton(
                                        onPressed: () async {
                                          final Uri url = Uri.parse('https://developmentalphawizz.com/ShareMyRide/admin/GenerateOrderPdf/${model.id}');
                                          await launchUrl(url,mode: LaunchMode.externalApplication);

                                          // if (!await launchUrl(url)) {
                                          // throw Exception('Could not launch $url');
                                          // }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shadowColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                        ),
                                        child: Text(
                                          "View Invoice",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                              color: Colors.white,
                                              fontSize: 14),
                                        )),
                                  ],
                                );
                              });
                        } else {
                          setSnackBar("Detail Not Available", context);
                        }
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    child: Text(
                                      "B.ID - ${model.id!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    child: Text(
                                      "Status - ${model.status!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${model.fromCity}   ->  ${model.toCity}",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Journey Date - ${model.bookingDate}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              commonButton(
                                height: 4,
                                width: 90,
                                fontSize: 10.0,
                                onPressed: null,
                                loading: false,
                                title:
                                    "${model.pickupAddress}",//(${model.pickupTime})
                                context: context,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              model.passengerDetails != null &&
                                      model.passengerDetails!.isNotEmpty
                                  ? Column(
                                      children:
                                          model.passengerDetails!.map((e) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${e.name}(Age-${e.age})",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              Text(
                                                "Seat - ${e.seatNo}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),
                                              /*Text(
                                                "OTP - ${e.otp}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium,
                                              ),*/
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Booked on - ${DateFormat("dd EEE MMM yy").format(DateTime.parse(model.createdAt!))}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    "Total - ₹${model.amount}",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              commonButton(
                                height: 4,
                                width: 90,
                                fontSize: 10.0,
                                onPressed: null,
                                loading: false,
                                title:
                                    "${model.dropAddress}",//(${model.dropTime})
                                context: context,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: bookingList[index].status ==
                                            "Not Started"
                                        ? ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          "Cancel Booking"),
                                                      content: Text(
                                                          "Do you want to proceed?"),
                                                      actions: [
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              shadowColor:
                                                                  Colors.red,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                            child: Text(
                                                              "No",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                            )),
                                                        ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              updateBooking(
                                                                  bookingList[
                                                                          index]
                                                                      .id,
                                                                  "4",
                                                                  index);
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              shadowColor:
                                                                  Colors.green,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                            ),
                                                            child: Text(
                                                              "Yes",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineSmall!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                            )),
                                                      ],
                                                    );
                                                  });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shadowColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            child: !updateLoading
                                                ? Text(
                                                    "Cancel",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!
                                                        .copyWith(
                                                            color: Colors.white,
                                                            fontSize: 14),
                                                  )
                                                : CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                          )
                                        : const SizedBox(),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed:
                                          bookingList[index].status !=
                                                  "Completed"
                                              ? null
                                              : () {
                                                  TextEditingController
                                                      commentCon =
                                                      TextEditingController();
                                                  double rating = 3;
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) {
                                                        return AlertDialog(
                                                          insetPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      0),
                                                          title: Text(
                                                              "Rate Driver"),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              RatingBar.builder(
                                                                initialRating:
                                                                    3,
                                                                minRating: 1,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    true,
                                                                itemCount: 5,
                                                                itemPadding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            4.0),
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating1) {
                                                                  rating = rating1;
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextFormField(
                                                                minLines: 2,
                                                                maxLines: 4,
                                                                controller:
                                                                    commentCon,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .emailAddress,
                                                                decoration:
                                                                    InputDecoration(
                                                                  fillColor:
                                                                      MyColorName
                                                                          .colorBg2,
                                                                  filled: true,
                                                                  labelText:
                                                                      "Enter Message",
                                                                  counterText:
                                                                      '',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                          color:
                                                                              Colors.black87),
                                                                  enabledBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: MyColorName
                                                                          .colorBg2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: MyColorName
                                                                          .colorBg2,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                        shadowColor:
                                                                            Colors.red,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                      ),
                                                                      child: Text(
                                                                        "Cancel",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall!
                                                                            .copyWith(
                                                                                color: Colors.white,
                                                                                fontSize: 14),
                                                                      )),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        updateRating(
                                                                            bookingList[index].id.toString(),
                                                                            bookingList[index]
                                                                                .busDetail!.driverId,
                                                                            rating,commentCon.text,
                                                                            index);
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                        shadowColor:
                                                                            Colors.green,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                      ),
                                                                      child: Text(
                                                                        "Submit",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineSmall!
                                                                            .copyWith(
                                                                                color: Colors.white,
                                                                                fontSize: 14),
                                                                      )),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shadowColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: !updateLoading
                                          ? Text(
                                              "Rate",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                            )
                                          : CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : const Center(
                  child: Text("No Booking Available"),
                )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
