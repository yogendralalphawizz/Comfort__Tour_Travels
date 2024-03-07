import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quick_pay/BottomNavigation/Home/boarding_screen.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:http/http.dart' as http;
import 'package:quick_pay/model/bus_model/bus_detail_data_response.dart';
import 'package:quick_pay/model/bus_model/pickup_drop_data_response.dart';
import 'package:quick_pay/model/bus_model/pickup_drop_new_data_response.dart';
import 'package:quick_pay/model/bus_model/vehicle_data_response.dart';


class BusBookingPage extends StatefulWidget {

  BusBookingPage({Key? key, required this.id, this.date, this.type});

  String id ;
  String? date;
  String? type;

  @override
  _BusBookingPageState createState() => _BusBookingPageState();
}

class _BusBookingPageState extends State<BusBookingPage> {
  bool _isSleeperSelected = false;


  List <SeatDesign> allSeats = [];
  List <List<Seat>> seats = [];
  List <List<Seat>> lastSeats = [];
  /*List <SeatDesign> firstRowSeats = [];
  List <SeatDesign> secondRowSeats = [];
  List <SeatDesign> thirdRowSeats = [];
  List <SeatDesign> fourthRowSeats = [];
  List <SeatDesign> fifthRowSeats = [];*/

  List <String> seatNoList = [];
  List<VehicleSeatDesign> vehicleSeats = [] ;

  //BusDetailData? busDetailData ;
  BusSeatBookingNewData? busDetailData ;
  VehicleData? vehicleData ;

  bool isLoading = false ;
  double amount = 0.00;
  int seatCount = 0 ;

  List <EchoSeat> echoSeatList = [
    EchoSeat(isBooked: false, seatNo: '1'),
    EchoSeat(isBooked: false, seatNo: '2'),
    EchoSeat(isBooked: false, seatNo: '3'),
    EchoSeat(isBooked: false, seatNo: '4'),
    EchoSeat(isBooked: false, seatNo: '5'),
    EchoSeat(isBooked: false, seatNo: '6'),
    EchoSeat(isBooked: false, seatNo: '7'),
    EchoSeat(isBooked: false, seatNo: '8'),

  ];
  List <EchoSeat> ertigaSeatList = [
    EchoSeat(isBooked: false, seatNo: '1'),
    EchoSeat(isBooked: false, seatNo: '2'),
    EchoSeat(isBooked: false, seatNo: '3'),
    EchoSeat(isBooked: false, seatNo: '4'),
    EchoSeat(isBooked: false, seatNo: '5'),
    EchoSeat(isBooked: false, seatNo: '6'),
    EchoSeat(isBooked: false, seatNo: '7'),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.type == 'bus' ){
      getBusDetail();
    }else {
      getVehicleDetail();
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(

        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: primary,
        title: Text(
          widget.type == 'bus' ? busDetailData?.name ??'' : vehicleData?.name ?? '',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      bottomSheet: Container(
        height: 100,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${seatCount} Seats'),
                  Text(
                    '${amount}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if(widget.type=='ertiga' || widget.type=='eeco'){
                    seatNoList.clear();
                    for (int i = 0; i < vehicleSeats.length; i++){
                      if(vehicleSeats[i].isBooked ?? false){
                        seatNoList.add(vehicleSeats[i].id.toString());
                      }
                    }


                  }else {
                    seatNoList.clear();
                    for (int i = 0; i < seats.length; i++) {
                      for (int j = 0; j < seats[i].length; j++) {
                        if (seats[i][j].isBooked ?? false) {
                          seatNoList.add(seats[i][j].id.toString());
                          print('${j}__j__');
                        }
                      }
                    }
                  }

                  Navigator.push(context, MaterialPageRoute(builder: (context) => BoardingDroppingScreen(
                    busId: widget.type == 'bus' ? busDetailData?.id.toString() : vehicleData?.id.toString(), date: widget.date,
                    amount: amount.toString(), seatNoList: seatNoList,travelsName: widget.type == 'bus' ?  busDetailData?.name.toString(): vehicleData?.name.toString() ,
                    fromTime: widget.type == 'bus' ? busDetailData?.startTime : vehicleData?.startTime.toString(),
                    toTime: widget.type == 'bus' ? busDetailData?.endTime :vehicleData?.endTime.toString(),
                    fromAndToCity: widget.type == 'bus' ? busDetailData?.fromAndToCity.toString() : vehicleData?.jsonData.toString()
                  ),));
                },
                child: Text(
                  'SELECT BOARDING & DROPPING POINT',
                  style: TextStyle(fontSize: 14),
                ))
          ],
        ),
      ),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(

          children: [

            Container(
              padding: EdgeInsets.only(left: 20),
              color: Colors.white,
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 10,),
              Row(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('Pickup Point :', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text('Dropping Point :', style: TextStyle(fontWeight: FontWeight.bold),),
                ],),
                SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width/1.8,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                        child: Row(children: _boardingPoints.map((e) => Text('${e.title}, ' ?? '')).toList())),
                  ),
                    SizedBox(height: 10,),

                    SizedBox(
                      width: MediaQuery.of(context).size.width/1.8,

                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(children: _droppingPoints.map((e) => Text('${e.title}, ' ?? '')).toList())),
                    )
                ],)
              ],),
                  SizedBox(height: 10,),
              Row(
                children: [
                Text(widget.type == 'bus' ? busDetailData?.startTime ?? '' : vehicleData?.startTime ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                SizedBox(width: 5,),
                Icon(Icons.arrow_right_alt),
                SizedBox(width: 10,),
                Text(widget.type == 'bus' ?busDetailData?.endTime ?? '': vehicleData?.endTime ?? '', style: TextStyle(color: Colors.black,),),
                  SizedBox(width: 20,),
                  Text(widget.date.toString().substring(0,10) ?? '', style: TextStyle(color: Colors.black,),),

              ],),

            ],),),
            SizedBox(
              height: 20,
            ),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSleeperSelected = false;
                    });
                  },
                  child: Text('Sitting'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSleeperSelected = true;
                    });
                  },
                  child: Text('Sleeper'),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),*/
            //seatView2(),
            Align(
              alignment: Alignment.topCenter,
                child: widget.type== 'ertiga' ? ertigaView() : widget.type== 'eeco' ? echoSeatView() : busSeatView ()),//seatsView()),
            //seatView3(),
            SizedBox(height: 120,)
          ],
        ),
      ),
    );
  }
  Widget busSeatView () {
    int i =  allSeats.length - 5;
    int y = (seats.length - (seats.length-2)) ;

    print('${i}________');
    print('${y}________');

    if (seats.length >= 2) {
      lastSeats.add(seats[seats.length - 1]);
    }

    return Container(
      padding: EdgeInsets.only(left: 15),
      width: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/imgs/img1.png',
            height: 40,
            width: 40,
          ),
          SizedBox(
              width: double.maxFinite,
              child: Divider(
                thickness: 1,
                color: Colors.black26,
              )),
          seats.length>1?ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: seats.length-1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10,left: 10, ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                    children: List.generate(seats[index].length, (k) {

                      return InkWell(
                        onTap: (){
                          if (seats[index][k].isSelected ?? false) {
                          } else {
                            setState(() {
                              seats[index][k].isBooked = !(seats[index][k].isBooked ?? false);
                              if(seats[index][k].isBooked ??   false){
                                amount = amount + double.parse(busDetailData?.amount ?? '');
                                seatCount = seatCount + 1 ;
                              }else {
                                amount = amount - double.parse(busDetailData?.amount ?? '');
                                seatCount = seatCount - 1 ;
                              }
                            });

                          }
                        },
                        child: Row(
                        children: [
                          seats[index][k].isSelected ?? false
                        ? Image.asset('assets/imgs/chair3.png',height: 30, width: 30, scale: 5)
                            : seats[index][k].isBooked ?? false
                              ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                              : Image.asset('assets/imgs/chair1.png',height: 30, width: 30, scale: 5) ,
                  k%2 == 0 ? SizedBox(width: 5,) : SizedBox(width: 20,)
                ],),
                      );
                    } )),
              );
            },
          ):const SizedBox(),

          Padding(
            padding: EdgeInsets.only(right: 12, left: 0),
            child: SizedBox(
                width: 200,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(lastSeats.first.length, (index) {

                    return InkWell(onTap: (){


                      if (lastSeats.first[index].isSelected ?? false) {
                      } else {
                        setState(() {
                          lastSeats.first[index].isBooked = !(lastSeats.first[index].isBooked ?? false);
                          if(lastSeats.first[index].isBooked ??   false){
                            amount = amount + double.parse(busDetailData?.amount ?? '');
                            seatCount = seatCount + 1 ;
                          }else {
                            amount = amount - double.parse(busDetailData?.amount ?? '');
                            seatCount = seatCount - 1 ;
                          }
                        });

                      }


                    },
                      child: lastSeats.first[index].isSelected ?? false
                          ? Image.asset('assets/imgs/chair3.png',height: 30, width: 30, scale: 5)
                        :lastSeats.first[index].isBooked ?? false
                          ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          : Image.asset('assets/imgs/chair1.png',height: 30, width: 30, scale: 5)) ;
                  }),)

      ),
    )]));
  }


Widget echoSeatView(){
    return Container(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        width: 250,
        color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.maxFinite,
              child: Divider(
                thickness: 1,
                color: Colors.black26,
              )),
          Row(

            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              vehicleSeats[0].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
              : vehicleSeats[0].isBooked  ?? false ? InkWell(
              onTap: (){
                setState(() {
                  vehicleSeats[0].isBooked = !(vehicleSeats[0].isBooked ?? false);
                  seatCount = seatCount-1;
                  amount = amount- double.parse(vehicleData?.amount ??'');
                });
              },
                child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[0].isBooked = !(vehicleSeats[0].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
            Image.asset(
              'assets/imgs/img1.png',
              height: 60,
              width: 60,
            ),
          ],),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              vehicleSeats[1].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  :vehicleSeats[1].isBooked ?? false ? InkWell(
                onTap: (){
                  setState(() {
                    vehicleSeats[1].isBooked = !(vehicleSeats[1].isBooked ?? false);
                    seatCount = seatCount-1;
                    amount = amount- double.parse(vehicleData?.amount ??'');
                  });
                },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) :InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[1].isBooked = !(vehicleSeats[1].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              vehicleSeats[2].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  :vehicleSeats[2].isBooked ?? false ? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[2].isBooked = !(vehicleSeats[2].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[2].isBooked = !(vehicleSeats[2].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              vehicleSeats[3].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  :vehicleSeats[3].isBooked ?? false ? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[3].isBooked = !(vehicleSeats[3].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[3].isBooked = !(vehicleSeats[3].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
          ],),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(children: [
              RotatedBox(
                quarterTurns: 45,
                  child: vehicleSeats[4].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                      : vehicleSeats[4].isBooked ?? false ? InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[4].isBooked = !(vehicleSeats[4].isBooked ??false);
                          seatCount = seatCount-1;
                          amount = amount- double.parse(vehicleData?.amount ??'');
                        });

                  }, child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5) ) : InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[4].isBooked = !(vehicleSeats[4].isBooked ??false);
                          seatCount = seatCount+1;
                          amount = amount+ double.parse(vehicleData?.amount ??'');
                        });

                      }, child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5) )),
              RotatedBox(
                quarterTurns: 45,
                  child: vehicleSeats[5].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                      :  vehicleSeats[5].isBooked ?? false ?  InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[5].isBooked = !(vehicleSeats[5].isBooked ??false);
                          seatCount = seatCount-1;
                          amount = amount- double.parse(vehicleData?.amount ??'');
                        });
                      }, child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5) ): InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[5].isBooked = !(vehicleSeats[5].isBooked ??false);
                          seatCount = seatCount+1;
                          amount = amount+ double.parse(vehicleData?.amount ??'');
                        });
                      }, child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5) )),
            ],),
            Column(children: [
              RotatedBox(
                  quarterTurns: 135,
                  child: vehicleSeats[6].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                      : vehicleSeats[6].isBooked ?? false ? InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[6].isBooked = !(vehicleSeats[6].isBooked ??false);
                          seatCount = seatCount-1;
                          amount = amount- double.parse(vehicleData?.amount ??'');
                        });

                      }, child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5) ) : InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[6].isBooked = !(vehicleSeats[6].isBooked ??false);
                          seatCount = seatCount+1;
                          amount = amount+ double.parse(vehicleData?.amount ??'');
                        });

                      }, child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5) )),
              RotatedBox(
                  quarterTurns: 135,
                  child: vehicleSeats[7].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                      :  vehicleSeats[7].isBooked ?? false ?  InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[7].isBooked = !(vehicleSeats[7].isBooked ??false);
                          seatCount = seatCount-1;
                          amount = amount- double.parse(vehicleData?.amount ??'');
                        });
                      }, child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5) ): InkWell(
                      onTap: (){
                        setState(() {
                          vehicleSeats[7].isBooked = !(vehicleSeats[7].isBooked ??false);
                          seatCount = seatCount+1;
                          amount = amount+ double.parse(vehicleData?.amount ??'');
                        });
                      }, child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5) )),
            ],)
          ],)

    ],),);
}

Widget ertigaView(){
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          SizedBox(
              width: double.maxFinite,
              child: Divider(
                thickness: 1,
                color: Colors.black26,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              vehicleSeats[0].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  : vehicleSeats[0].isBooked ?? false ?  InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[0].isBooked = !(vehicleSeats[0].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[0].isBooked = !(vehicleSeats[0].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount + double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              Image.asset(
                'assets/imgs/img1.png',
                height: 60,
                width: 60,
              ),
            ],),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              vehicleSeats[1].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  : vehicleSeats[1].isBooked ?? false ? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[1].isBooked = !(vehicleSeats[1].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[1].isBooked = !(vehicleSeats[1].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              vehicleSeats[2].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  :vehicleSeats[2].isBooked ?? false? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[2].isBooked = !(vehicleSeats[2].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)): InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[2].isBooked = !(vehicleSeats[2].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              vehicleSeats[3].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  : vehicleSeats[3].isBooked ?? false ? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[3].isBooked = !(vehicleSeats[3].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[3].isBooked = !(vehicleSeats[3].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
            ],),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              vehicleSeats[4].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  : vehicleSeats[4].isBooked ?? false ? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[4].isBooked = !(vehicleSeats[4].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[4].isBooked = !(vehicleSeats[4].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              vehicleSeats[5].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  :vehicleSeats[5].isBooked ?? false? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[5].isBooked = !(vehicleSeats[5].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)): InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[5].isBooked = !(vehicleSeats[5].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');
                    });
                  },
                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
              vehicleSeats[6].isSelected ?? false ? Image.asset('assets/imgs/chair3.png',height: 60, width: 60, scale: 5)
                  : vehicleSeats[6].isBooked ?? false ? InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[6].isBooked = !(vehicleSeats[6].isBooked ?? false);
                      seatCount = seatCount-1;
                      amount = amount- double.parse(vehicleData?.amount ??'');

                    });
                  },
                  child: Image.asset('assets/imgs/chair2.png',height: 60, width: 60, scale: 5)) : InkWell(
                  onTap: (){
                    setState(() {
                      vehicleSeats[6].isBooked = !(vehicleSeats[6].isBooked ?? false);
                      seatCount = seatCount+1;
                      amount = amount+ double.parse(vehicleData?.amount ??'');

                    });
                  },

                  child: Image.asset('assets/imgs/chair1.png',height: 60, width: 60, scale: 5)),
            ],),
      ],),
    );
}


Future <void> getBusDetail() async{

    setState(() {
      isLoading = true ;
    });
    var headers = {
      'Cookie': 'ci_session=a346d453efea89630b4f4a4fd3dc0b76e24b6f50'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiService.busDetail));
    request.fields.addAll({
      'bus_id': widget.id,
      'journey_date': widget.date ?? ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print('${result}') ;
      var finalresult = BusSeatBookingNewDataResponse.fromJson(jsonDecode(result));

      setState(() {
        busDetailData = finalresult.data ;
        seats = finalresult.data?.seatDesign ?? [] ;

        isLoading = false ;
      });
      getPoints();
    }
    else {
      setState(() {
        isLoading = false ;
      });
      print(response.reasonPhrase);
    }

  }

  List<PPoint> _boardingPoints = [];

  List<DPoint> _droppingPoints = [];

  Future <void> getVehicleDetail() async{

    setState(() {
      isLoading = true ;
    });
    var headers = {
      'Cookie': 'ci_session=a346d453efea89630b4f4a4fd3dc0b76e24b6f50'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiService.busDetail));
    request.fields.addAll({
      'bus_id': widget.id,
      'journey_date': widget.date ?? ''
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print('${result}') ;
      var finalresult = VehicleDataResponse.fromJson(jsonDecode(result));

      setState(() {
        vehicleData = finalresult.data ;
        vehicleSeats = finalresult.data?.seatDesign ?? [] ;

        isLoading = false ;
      });
      getPoints();

    }
    else {
      setState(() {
        isLoading = false ;
      });
      print(response.reasonPhrase);
    }

  }

  Future<void> getPoints() async {

    var headers = {
      'Cookie': 'ci_session=f4f89913a337979e74df18ee17719b79305ee037'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(ApiService.pickupDrop));
    request.fields.addAll({'bus_id': widget.type == 'bus' ? busDetailData?.id.toString() ?? '' : vehicleData?.id.toString() ?? ''});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    print('___________${request.fields}__________');

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print('___________${result}__________');
      var finalResult = PickupDropDataResponse.fromJson(jsonDecode(result));

      setState(() {
        _droppingPoints = finalResult.data?.dropPoints ?? [];
        _boardingPoints = finalResult.data?.pickupPoints ?? [];
      });
    } else {
      print(response.reasonPhrase);
      setState(() {
      });
    }
  }




/*Future <void> getBusDetail() async{

    setState(() {
      isLoading = true ;
    });
    var headers = {
      'Cookie': 'ci_session=a346d453efea89630b4f4a4fd3dc0b76e24b6f50'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiService.busDetail));
    request.fields.addAll({
      'bus_id': '10'//widget.id
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      print('${result}') ;
      var finalresult = BusDetailDataResponse.fromJson(jsonDecode(result));

      setState(() {
        busDetailData = finalresult.data ;
        allSeats = finalresult.data?.seatDesign ?? [] ;


        int count = 0;
        int count2 = 0;
        print('${allSeats.length}______');
        for (int i = 0; i < allSeats.length; i++) {
          if ((allSeats.length - 5) / 4 > i) {
            firstRowSeats.add(allSeats[i]);
          } else if ((allSeats.length - 5) / 2 > i) {
            secondRowSeats.add(allSeats[i]);
            count = i;
          } else if ((count + (allSeats.length - 5) / 4) >= i) {
            thirdRowSeats.add(allSeats[i]);
            count2 = i;
          } else if ((count2 + (allSeats.length - 5) / 4) >= i) {
            fourthRowSeats.add(allSeats[i]);
          } else {
            fifthRowSeats.add(allSeats[i]);
          }
        }

        print('${firstRowSeats.length}_____firstRowList');
        print('${secondRowSeats.length}_____secondRowList');
        print('${thirdRowSeats.length}_____thirdRowList');
        print('${fourthRowSeats.length}_____fourthRowList');
        print('${fifthRowSeats.length}_____fifthRowList');




        isLoading = false ;
      });
    }
    else {
      setState(() {
        isLoading = false ;
      });
      print(response.reasonPhrase);
    }

  }*/

/*  Widget seatsView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/imgs/img1.png',
            height: 40,
            width: 40,
          ),
          SizedBox(
              width: double.maxFinite,
              child: Divider(
                thickness: 1,
                color: Colors.black26,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: List.generate(
                      firstRowSeats.length,
                          (index) => Container(
                        margin: EdgeInsets.only(top: 15),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (firstRowSeats[index].isSelected ?? false) {
                            } else {
                              setState(() {
                                firstRowSeats[index].isBooked = !(firstRowSeats[index].isBooked ?? false);
                                if(firstRowSeats[index].isBooked ?? false){
                                  amount = amount + double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount + 1 ;
                                }else {
                                  amount = amount - double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount - 1 ;
                                }
                              });

                            }
                          },
                          child: Center(
                            child: firstRowSeats[index].isSelected ?? false
                                ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                : firstRowSeats[index].isBooked ?? false
                                ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                                :Image.asset('assets/imgs/chair1.png', height: 30, width: 30, scale: 5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: List.generate(
                      secondRowSeats.length,
                          (index) => Container(
                        margin: EdgeInsets.only(top: 15),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (secondRowSeats[index].isSelected ?? false) {
                            } else {
                              setState(() {
                                secondRowSeats[index].isBooked = !(secondRowSeats[index].isBooked ?? false);
                                if(secondRowSeats[index].isBooked ?? false){
                                  amount = amount + double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount + 1 ;
                                }else{
                                  amount = amount - double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount - 1 ;
                                }
                              });
                            }
                          },
                          child: Center(
                            child: secondRowSeats[index].isSelected ?? false
                                ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                : secondRowSeats[index].isBooked ??false
                                ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                :Image.asset('assets/imgs/chair1.png',
                                height: 30, width: 30, scale: 5)  ,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    children: List.generate(
                      thirdRowSeats.length,
                          (index) => Container(
                        margin: EdgeInsets.only(top: 15),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (thirdRowSeats[index].isSelected ?? false) {
                            } else {
                              setState(() {
                                thirdRowSeats[index].isBooked = !(thirdRowSeats[index].isBooked ?? false);
                                if(thirdRowSeats[index].isBooked ?? false){
                                  amount = amount + double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount + 1 ;
                                }else{
                                  amount = amount - double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount - 1 ;
                                }

                              });
                            }
                          },
                          child: Center(
                            child: thirdRowSeats[index].isSelected ?? false
                                ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                : thirdRowSeats[index].isBooked ?? false ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                : Image.asset('assets/imgs/chair1.png',
                                height: 30, width: 30, scale: 5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    children: List.generate(
                      fourthRowSeats.length,
                          (index) => Container(
                        margin: EdgeInsets.only(top: 15),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            if (fourthRowSeats[index].isSelected ?? false) {
                            } else {
                              setState(() {
                                fourthRowSeats[index].isBooked = !(fourthRowSeats[index].isBooked ?? false);
                                if(fourthRowSeats[index].isBooked ?? false){
                                  amount = amount + double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount + 1 ;
                                }else {
                                  amount = amount - double.parse(busDetailData?.amount ?? '');
                                  seatCount = seatCount - 1 ;
                                }
                              });
                            }
                          },
                          child: Center(
                            child: fourthRowSeats[index].isSelected ?? false
                                ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                : fourthRowSeats[index].isBooked ?? false
                                ? Image.asset('assets/imgs/chair2.png',
                                height: 30, width: 30, scale: 5)
                                : Image.asset('assets/imgs/chair1.png',
                                height: 30, width: 30, scale: 5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              fifthRowSeats.length,
                  (index) => Container(
                margin: EdgeInsets.only(top: 15),
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (fifthRowSeats[index].isSelected ?? false) {
                    } else {
                      setState(() {
                        fifthRowSeats[index].isBooked = !(fifthRowSeats[index].isBooked ?? false);
                        if(fifthRowSeats[index].isBooked ?? false){
                          amount = amount + double.parse(busDetailData?.amount ?? '');
                          seatCount = seatCount + 1 ;
                        }else{
                          amount = amount - double.parse(busDetailData?.amount ?? '');
                          seatCount = seatCount - 1 ;
                        }
                      });
                    }
                  },
                  child: Center(
                    child: fifthRowSeats[index].isBooked ?? false
                        ? Image.asset('assets/imgs/chair2.png',
                        height: 30, width: 30, scale: 5)
                        : fifthRowSeats[index].isBooked ?? false
                        ? Image.asset('assets/imgs/chair2.png',
                        height: 30, width: 30, scale: 5)
                        : Image.asset('assets/imgs/chair1.png',
                        height: 30, width: 30, scale: 5),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget seatView2 () {
    int i =  allSeats.length - 5;
    int y = (allSeats.length - (allSeats.length-5)) ;
    print('${i}________');
    print('${y}________');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/imgs/img1.png',
            height: 40,
            width: 40,
          ),
          SizedBox(
              width: double.maxFinite,
              child: Divider(
                thickness: 1,
                color: Colors.black26,
              )),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (allSeats.length-5)~/4,
            itemBuilder: (context, index) {
              return Column(

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        allSeats[index].isSelected ?? false
                            ?Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                            :Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5),
                        SizedBox(width: 5,),
                        allSeats[index+2].isSelected ?? false
                            ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                            : Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                      ],),
                      Row(children: [
                        allSeats[index+3].isSelected ?? false
                            ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                            :Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5),
                        SizedBox(width: 5,),
                        allSeats[index+4].isSelected ?? false
                            ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                            :Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5),
                      ],),
                    ],),
                  SizedBox(height: 15,),

                ],);
            },
          ),
          SizedBox(
              width: 200,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(y, (index) => Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)),) *//*ListView.builder(

              scrollDirection: Axis.horizontal,

              itemCount: 5,
              itemBuilder:(context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                  ],);
              },  ),*//*
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget seatView3 () {
    int i =  allSeats.length - 5;
    int y = (allSeats.length - (allSeats.length-5)) ;
    print('${i}________');
    print('${y}________');

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: 200,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,

        children: [
          SizedBox(
            height: 10,
          ),
          Image.asset(
            'assets/imgs/img1.png',
            height: 40,
            width: 40,
          ),
          SizedBox(
              width: double.maxFinite,
              child: Divider(
                thickness: 1,
                color: Colors.black26,
              )),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: (allSeats.length-5)~/4,
            itemBuilder: (context, index) {
              return Column(

                children: allSeats.map((elment) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      allSeats[index].isSelected ?? false
                          ?Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          :Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5),
                      SizedBox(width: 5,),
                      allSeats[index+2].isSelected ?? false
                          ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          : Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                    ],),
                    Row(children: [
                      allSeats[index+3].isSelected ?? false
                          ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          :Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5),
                      SizedBox(width: 5,),
                      allSeats[index+4].isSelected ?? false
                          ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          :Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5),
                    ],),
                  ],),).toList(),


              );
            },
          ),
          SizedBox(
              width: 200,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(y, (index) => Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)),) *//*ListView.builder(

              scrollDirection: Axis.horizontal,

              itemCount: 5,
              itemBuilder:(context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                  ],);
              },  ),*//*
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }

  Widget seatView4 () {


    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: 200,
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/imgs/img1.png',
              height: 40,
              width: 40,
            ),
            SizedBox(
                width: double.maxFinite,
                child: Divider(
                  thickness: 1,
                  color: Colors.black26,
                )),
            SizedBox(
              width: 180,
              child: GridView.builder(

                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 30,
                    crossAxisCount: 4,
                    childAspectRatio:1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing:10
                ),
                itemCount: allSeats.length - 5,
                itemBuilder: (context, index) => InkWell(
                  onTap: (){
                    if (allSeats[index].isSelected ?? false) {
                    } else {
                      setState(() {
                        allSeats[index].isBooked = !(allSeats[index].isBooked ?? false);
                        if(allSeats[index].isBooked ?? false){
                          amount = amount + double.parse(busDetailData?.amount ?? '');
                          seatCount = seatCount + 1 ;
                        }else {
                          amount = amount - double.parse(busDetailData?.amount ?? '');
                          seatCount = seatCount - 1 ;
                        }
                      });

                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      allSeats[index].isSelected ?? false
                          ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          : allSeats[index].isBooked ?? false
                          ? Image.asset('assets/imgs/chair2.png',height: 30, width: 30, scale: 5)
                          : Image.asset('assets/imgs/chair1.png',height: 30, width: 30, scale: 5),
                      index % 2==0 ? SizedBox.shrink() : SizedBox(width: 10,)

                    ],),
                ),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                fifthRowSeats.length,
                    (index) => Container(
                  margin: EdgeInsets.only(top: 15),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (fifthRowSeats[index].isSelected ?? false) {
                      } else {
                        setState(() {
                          fifthRowSeats[index].isBooked = !(fifthRowSeats[index].isBooked ?? false);
                          if(fifthRowSeats[index].isBooked ?? false){
                            amount = amount + double.parse(busDetailData?.amount ?? '');
                            seatCount = seatCount + 1 ;
                          }else{
                            amount = amount - double.parse(busDetailData?.amount ?? '');
                            seatCount = seatCount - 1 ;
                          }
                        });
                      }
                    },
                    child: Center(
                      child: fifthRowSeats[index].isBooked ?? false
                          ? Image.asset('assets/imgs/chair2.png',
                          height: 30, width: 30, scale: 5)
                          : fifthRowSeats[index].isBooked ?? false
                          ? Image.asset('assets/imgs/chair2.png',
                          height: 30, width: 30, scale: 5)
                          : Image.asset('assets/imgs/chair1.png',
                          height: 30, width: 30, scale: 5),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }*/
}

class EchoSeat {
  bool? isBooked ;
  String? seatNo;

  EchoSeat({this.isBooked, this.seatNo});
}




