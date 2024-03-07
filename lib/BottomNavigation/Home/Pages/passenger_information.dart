
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:quick_pay/BottomNavigation/Home/booking_confirmed.dart';


import 'package:quick_pay/Config/Razorpay.dart';
import 'package:quick_pay/Config/common.dart';


import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/helper/apiservices.dart';
import 'package:quick_pay/model/bus_detail_model.dart';

import 'package:quick_pay/model/bus_model/book_ticket_response.dart';
import 'package:quick_pay/model/bus_stopage_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../Config/ApiBaseHelper.dart';
import '../../../Config/constant.dart';
import '../../../model/walletdat_model.dart';


enum Gender{Male,Female}
class PassengerInformation extends StatefulWidget {
  const PassengerInformation(
      {Key? key,
      this.amount,
      this.date,
      this.boarding,
      this.busId,
        this.type,
        this.platformFee,
      this.cityFromAndTo,
      this.dropping,
      this.travelsName,
      this.seatNoList,
      this.timeFrom, this.timeTo})
      : super(key: key);

  final String? cityFromAndTo,
      travelsName,type,platformFee,

      timeFrom,
      timeTo,
      date,
      busId,

      amount;
  final StopageData? boarding,dropping;
  final List <String>? seatNoList ;

  @override
  State<PassengerInformation> createState() => _PassengerInformationState();
}

class _PassengerInformationState extends State<PassengerInformation> {
  TextEditingController mobileController = TextEditingController();

  String? countrycode, countryName;
  List<Map<String, dynamic>> information = [
    {
      'title': 'Ajay Tours And Travels',
      'address1': 'Kalani Nagar(Airport road)',
      'address2': 'Karol Bag(Bypass)',
      'City1': 'Indore',
      'City2': 'New Delhi',
      'time1': '8:50',
      'time2': '11:30',
      'Day&month1': 'Sat,Apr23',
      'Day&month2': 'Sun,Apr23'
    }
  ];
  WalletDataModel walletDataModel =WalletDataModel();
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  void getWalletApi(String userid) async {
    try {
      Map param = {
        "user_id":userid,

      };

      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}get_wallet_transactions"), param);
      print(response.toString()+"GGGGGGGGGGGGGGGGFTFGGGGGGGGGG");
      walletDataModel=WalletDataModel.fromJson(response);
      print(walletDataModel.data?.length);
      setState(() {

      });

    } catch (e) {

    } finally {

    }
  }

  /*Widget setCodeWithMono() {
    return Container(
        width:MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: setCountryCode(),
            ),
            Expanded(
              flex: 2,
              child: setMono(),
            ),
          ],
        ));
  }*/
  Widget setMono() {
    return TextFormField(
        keyboardType: TextInputType.number,
        maxLength: 10,
        controller: mobileController,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          counterText: "",
          hintText: 'mobile number',
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: Colors.black, fontWeight: FontWeight.normal),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.lightWhite),
          // ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(7.0),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ));
  }

  /*Widget setCountryCode() {
    double width =MediaQuery.of(context).size.width/1;
    double height =MediaQuery.of(context).size.height/1;
    return CountryCodePicker(
        showCountryOnly: false,
        searchStyle: const TextStyle(
          color:Colors.white,
        ),
        flagWidth: 20,
        boxDecoration: const BoxDecoration(
          color:Colors.white,
        ),
        searchDecoration: const InputDecoration(
          hintText: 'contry code',
          hintStyle: TextStyle(color:Colors.black),
          fillColor:Colors.black,
        ),
        showOnlyCountryWhenClosed: false,
        initialSelection: 'IN',
        dialogSize: Size(width, height),
        alignLeft: true,
        textStyle: const TextStyle(
            color:Colors.black,
            fontWeight: FontWeight.bold),
        onChanged: (CountryCode countryCode) {
          countrycode = countryCode.toString().replaceFirst("+", "");
          countryName = countryCode.name;
        },
        onInit: (code) {
          countrycode = code.toString().replaceFirst("+", "");
        });
  }*/
  var items = ['Male', 'Female'];

  String? dropdownValue;

  selectGender() {
    DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
        hint: Text("Select Gender"),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.blue,
        ),
        elevation: 16,
        style: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        underline: Container(
          // height: 2,
          color: Colors.black54,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  List <List<TextEditingController>> controllerList = [];
  List<List<String>> genderList = [];
  List <String> selectedGender = [];
  String? selectedGenderItem;
  List <Map<dynamic, String>> info = [];
  List  info2 = [];

  String? fromActualCity;
  String? toActualCity;

  late Razorpay _razorpay;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    separateCityName();
    getWalletApi(curUserId.toString());
   print(widget.seatNoList);
    for(int i = 0; i< widget.seatNoList!.length ; i++ ){
      controllerList.add([TextEditingController(),TextEditingController()]);
      genderList.add(['Male','Female']);
      selectedGender.add(selectedGenderItem ?? 'Male') ;
    }

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }


  void   separateCityName() {
    String inputString = widget.cityFromAndTo.toString();

    List<String> cityNames = inputString.split(" - ");
    String fromCity = cityNames[0].substring(5); // Extracting the city name after "From "
    String toCity = cityNames[1].substring(3);

    // Extracting the city name after "To "

    print("From City: $fromCity");
    print("To City: $toCity");

    fromActualCity = fromCity;
    toActualCity = toCity ;
  }
  bool loading =false;
  @override
  Widget build(BuildContext context) {
    print('${widget.type}_______dfsdf');
    return Scaffold(
      backgroundColor: Color(0xffEEF2F3),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total"),
                Text("₹${widget.amount}")
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          commonButton(
            onPressed: () {
              bool validate = true;
              for(int i = 0;i < controllerList.length;i++){
                if(controllerList[i][0].text==""||controllerList[i][1].text==""){
                  setSnackBar("Please All The Details", context);
                  validate = false;
                  break;
                }
              }
              if(!validate){
                return;
              }
             _showPaymentDialog(context);
              // RazorPayHelper razorpayHelper = RazorPayHelper(widget.amount ?? "0", context, (result) {
              //   if(result=="error"){
              //     setState(() {
              //       loading = false;
              //     });
              //     setSnackBar("Payment Cancelled", context);
              //   }else{
              //     bookTicketApi(result ?? "");
              //   }
              // });

              //razorpayHelper.init();
            },
            loading: loading,
            title: "Book Tickets",
            context: context,
          ),
          const SizedBox(
            height: 8,
          ),
          /*Container(
            padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // onPressedBook();
                RazorPayHelper razorpayHelper = RazorPayHelper(widget.amount ?? "0", context, (result) {
                  if(result=="error"){
                    setSnackBar("Payment Cancelled", context);
                  }else{
                    bookTicketApi(result ?? "");
                  }
                });
                razorpayHelper.init();
                UpiPayment upiPayment = new UpiPayment(widget.amount ?? "1", context, (value) {
                  // ApplicationMeta? app;
                  // var upiSucc = upiPayment.onTap(app!.upiApplication as ApplicationMeta);
                  print("fianl result here ${value}");
                  if(value.status==UpiTransactionStatus.success){
                    print("workingggg");
                    bookTicketApi(transtionId ?? "");
                    // Navigator.pop(context);
                    // placeOrder('');
                  } else {
                    Fluttertoast.showToast(msg: "Payment Failed");
                  }
                },
                );
                upiPayment.initPayment();
              },
              child: Center(
                child: Text(
                  'Book Tickets',
                  style: TextStyle(fontSize: 14),
                ),
              ))),*/
        ],
      ),
      appBar: AppBar(
        backgroundColor: primary,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Passenger Information',
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: Container(
                        child: Column(
                      children: [
                        Row(
                          children:  [
                            widget.type != 'bus' ? Icon(
                              Icons.directions_car,
                              color: Colors.red,
                            ) : Icon(
                              Icons.directions_bus_filled,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              '${widget.travelsName}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children:  [
                                    SizedBox(
                                      width: 140,
                                      child: Text(
                                        '${widget.boarding!.name??""}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Text(fromActualCity ?? 'indore',
                                        style: TextStyle(
                                          fontSize: 15,
                                        )),
                                  ],
                                ),
                                Icon(Icons.arrow_forward),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children:  [
                                    Container(
                                      width: 140,
                                      child: Text('${widget.dropping!.name??""}',
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,

                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ),
                                    Text(toActualCity ?? 'Bhopal',
                                        style: TextStyle(
                                          fontSize: 15,
                                        )),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            /*Row(
                                  children: [
                                    Row(
                                      children: const [
                                        Text('Time : 7:30pm,',style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text('Mon,Apr24'),
                                      ],
                                    ),
                                    SizedBox(width: 20,),
                                    Row(
                                      children: const [
                                        Text('Time : 9:30am,',style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text('Tue,Apr25'),
                                      ],
                                    ),
                                  ],
                                ),*/
                          ],
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            /*Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.contact_mail_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 18,
                            ),
                            Text(
                              'Contact Details',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Your ticket and bus details will be sent here'),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Email ID'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(hintText: 'Mobile no.'),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),*/
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                    child: Container(
                        child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.add_chart,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              'Add Passengers',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text('Your ticket and bus details will be sent here'),
                        SizedBox(
                          height: 20,
                        ),
                        ListView.builder(
                          itemCount: widget.seatNoList?.length ?? 0 ,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              height:
                                  MediaQuery.of(context).size.height / 2.5,
                              width: MediaQuery.of(context).size.width / 1.4,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20, top: 20),
                                      child: Container(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Passenger ${index+1}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children:  [
                                              Text('Seat no.:'),
                                              Text(
                                                '${widget.seatNoList?[index]}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            controller: controllerList[index][0],
                                            decoration: const InputDecoration(
                                                hintText: 'Name'),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: controllerList[index][1],
                                            decoration: const InputDecoration(
                                                hintText: 'Age'),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Gender',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(children: [
                                            Radio(
                                              value: genderList[index].first,
                                              groupValue: selectedGender[index],
                                              onChanged: ( value) {
                                                setState(() {
                                                  //selectedGender = value;
                                                  //String name=  value;
                                                  selectedGender[index] = value.toString();
                                                });
                                              },
                                            ),
                                            Text('Male'),
                                            Radio(
                                              value: genderList[index][1],
                                              groupValue: selectedGender[index],
                                              onChanged: ( value) {
                                                setState(() {
                                                  selectedGender[index] = value.toString();
                                                });
                                              },
                                            ),
                                            Text('Female'),
                                          ],)
                                          /*SizedBox(
                                            width: 150,
                                            height: 100,
                                            child: Column(children: genderList[index].map((option) {
                                              return RadioListTile(

                                                title: Text(option),
                                                value: option,
                                                groupValue: selectedGenderItem,
                                                onChanged: (value) {
                                                  setState(() {

                                                    selectedGenderItem = value.toString();

                                                  }
                                                  );
                                                },
                                              );
                                            } ).toList(),),
                                          ),*/
                                          /*TextFormField(
                                            decoration: const InputDecoration(
                                                hintText:
                                                    'City of Residence'),
                                          ),*/
                                        ],
                                      )),
                                    )
                                  ]),
                            );
                          },
                        )
                      ],
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height/6,
            ),
          ],
        ),
      ),
    );
  }

  void onPressedBook(){
    for(int i =0;i<widget.seatNoList!.length; i++ ){

      /*info.add({
        "name":controllerList[i][0].text,
        "age": controllerList[i][1].text,
        "gender": selectedGender[i],
        "seat_no": widget.seatNoList![i],
      });*/
      info2.add(json.encode({
        "name":controllerList[i][0].text,
        "age": controllerList[i][1].text,
        "gender": selectedGender[i],
        "seat_no": widget.seatNoList![i],
      }));
    }
    print('______');
    openCheckout();
    //bookTicketApi('545644446')
  }


  void openCheckout() async   {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userMobile = prefs.getString('mobile');
    String? userEmail = prefs.getString('email');
    double price1 = double.parse(widget.amount ?? '');
    int price = price1.toInt();

    // if(totalValue == null || totalValue == ""){
    //   pricerazorpayy= cartModel!.getCartList!.total! * 100;
    // }
    // else{
    //   pricerazorpayy= int.parse(totalValue.toString()) * 100;
    // }
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': price*100,
      'name': 'Assignment-assist',
      'description': 'Assignment-assist',
      'prefill': {'contact': '$userMobile', 'email': '$userEmail'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // RazorpayDetailApi();
    // Order_cash_ondelivery();
    bookTicketApi(response.paymentId ?? '646546446')    ;
    Fluttertoast.showToast(
        msg: "Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message!,
    //     toastLength: Toast.LENGTH_SHORT);


    Fluttertoast.showToast(
        msg: "Payment cancelled by user",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }
  Future<void> _showPaymentDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Payment Method'),
          content: Container(
            height: 200,
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.wallet),
                    title: Text('Wallet'),
                    onTap: () {
                      setState(() {
                        loading = true;
                      });
                     // bookTicketApi("wallet") ;

                      if(double.parse("${walletDataModel.tatalBalance??"0"}")>double.parse("${widget.amount??"0"}")){
                        bookTicketApi("wallet") ;
                      }else{
                        setSnackBar("insufficient balance", context);
                      }

                      setState(() {
                        loading = false;
                      });
                      // Add your payment processing logic here
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Online'),
                    onTap: () {
                      setState(() {
                        loading = true;
                      });
                      // Handle PayPal selection
                      RazorPayHelper razorpayHelper = RazorPayHelper(widget.amount ?? "0", context, (result) {
                        if(result=="error"){
                          setState(() {
                            loading = false;
                          });
                          setSnackBar("Payment Cancelled", context);
                        }else{
                          bookTicketApi(result ?? "");
                        }
                      });
                      razorpayHelper.init();
                      // Add your payment processing logic here
                    },
                  ),
                ),
                // Add more payment options as needed
              ],
            ),
          ),
        );
      },
    );
  }


  BookTicketDataResponse ? bookTicketDataResponse;


Future<void> bookTicketApi(String paymentId) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  var headers = {
    'Cookie': 'ci_session=22bda4b0e013fc8f58ecd91fafd43f7d44d3aa08'
  };
  var request = http.MultipartRequest('POST', Uri.parse(ApiService.bookTicket));
  for(int i =0;i<widget.seatNoList!.length; i++ ){
    info2.add(json.encode({
      "name":controllerList[i][0].text,
      "age": controllerList[i][1].text,
      "gender": selectedGender[i],
      "seat_no": widget.seatNoList![i],
    }));
  }

  request.fields.addAll({
    'bus_id': widget.busId ?? '10',
    'user_id': userId ?? '',
    'transaction_id': paymentId,
    'pickup_address': widget.boarding!.name ?? fromActualCity??"",
    'drop_address': widget.dropping!.name ?? toActualCity??"",
    'pickup_time': widget.boarding!.stopFromtime ?? '',
    'drop_time': widget.dropping!.stopTotime ?? '',
    'platform_fee': widget.platformFee ?? '',
    'amount': widget.amount ?? '',
    'gst_amount': '0',
    'total': widget.amount ?? '',
    'booking_date': widget.date ?? '',
    'passenger_detail': '$info2',
    'payment_type':paymentId=='wallet'?'Wallet':'razorpay'
  });

  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send();
  print('${ApiService.bookTicket}');
  print('${request.fields}');
  print('${response.statusCode}');
  setState(() {
    loading = false;
  });
  if (response.statusCode == 200) {
    var result = await response.stream.bytesToString();
    print('$result');
    var finalResult = jsonDecode(result);
    Fluttertoast.showToast(msg: '${finalResult['message']}');
    if(finalResult['status']){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BookingConfirmed(),));
    }
    //var finalResult = BookTicketDataResponse.fromJson(jsonDecode(result));
   //
    /*if(bookTicketDataResponse?.status ?? false){
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(),));
    }*/
  }
  else {
    print(response.reasonPhrase);
  }
}
}
