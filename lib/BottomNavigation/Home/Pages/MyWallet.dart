import 'dart:convert';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_pay/Components/custom_button.dart';
import 'package:quick_pay/Locale/locales.dart';
import 'package:quick_pay/Theme/colors.dart';
import 'package:quick_pay/model/getwalletmodel.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../../../Config/ApiBaseHelper.dart';
import '../../../Config/common.dart';
import '../../../Config/constant.dart';
import '../../../model/userprofile.dart';
import '../../../model/walletdat_model.dart';
import 'add_money.dart';

class MyWallet extends StatefulWidget {
  UserProfile? getprofile;
  MyWallet({required this.getprofile});
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amtC = TextEditingController();
  TextEditingController msgC = TextEditingController();
  Razorpay _razorpay = Razorpay();
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  WalletDataModel walletDataModel =WalletDataModel();
  void addwalletApi(String userid,String amount,String txtid) async {
    try {
      Map param = {
        "user_id":userid,
        "amount":amount,
        "transaction_id":txtid,
        "user_type":"2"
      };
      print("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
      var response = await apiBaseHelper.postAPICall(
          Uri.parse("${baseUrl}add_wallet"), param);
         print(response.toString()+"GGGGGGGGGGGGGGGGFTFGGGGGGGGGG");

    } catch (e) {

    } finally {

    }
  }
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

  _showDialog() async {
    bool payWarn = false;
    await showDialog(context: context, builder: (context){
      return  AlertDialog(
        contentPadding: const EdgeInsets.all(0.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                child: Text("Add Money",
                  // getTranslated(context, 'ADD_MONEY')!,
                  style: Theme.of(this.context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.black),
                  //  Theme.of(context).colorScheme.fontColor),
                ),
              ),
              Divider(),
              Form(
                key: _formKey,
                child: Flexible(
                  child: SingleChildScrollView(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val){
                                  if(val!.isEmpty){
                                    return "Enter amount";
                                  }
                                },
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Amount",
                                  // getTranslated(context, "AMOUNT"),
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                      fontWeight: FontWeight.normal),
                                ),
                                controller: amtC,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                              child: TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                style: TextStyle(
                                  color:Colors.black,
                                ),
                                decoration: new InputDecoration(
                                  hintText: "Message",
                                  //(context, 'MSG'),
                                  hintStyle: Theme.of(this.context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                      color: Colors.black,
                                      // Theme.of(context)
                                      //     .colorScheme
                                      //     .lightBlack,
                                      fontWeight: FontWeight.normal),
                                ),
                                controller: msgC,
                              ),
                            ),
                            //Divider(),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(20.0, 10, 20.0, 5),
                            //   child: Text("Select Payment Method",
                            //     //getTranslated(context, 'SELECT_PAYMENT')!,
                            //     style: Theme.of(context).textTheme.subtitle2,
                            //   ),
                            // ),
                            Divider(),
                            payWarn
                                ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: Text("Please Select Payment Method..!!",
                                //  getTranslated(context, 'payWarning')!,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.red),
                              ),
                            )
                                : Container(),

                            // paypal == null
                            //     ? Center(child: CircularProgressIndicator())
                            //     : Column(
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: getPayList()),
                          ])),
                ),
              )
            ]),
        actions: <Widget>[
          new
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            commonButton(
                title: "Send",
                loading: false,
                context: context,
                onPressed: ()
                {
                  if(_formKey.currentState!.validate()!){
                    openCheckout(amtC.text);
                  }

                }
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            commonButton(
                title: "Cancel",
                loading: false,
                context: context,
                onPressed: ()
                {
                Navigator.pop(context);
                }
            ),
          ),
        ],
      );
    });
  }
  void openCheckout(String amount) async   {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userMobile = prefs.getString('mobile');
    String? userEmail = prefs.getString('email');
    double price1 = double.parse(amount ?? '');
    int price = price1.toInt();


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
    // bookTicketApi(response.paymentId ?? '646546446')    ;
    print("canCeGHHHHHHHHHHHH");
    print(curUserId);
    addwalletApi("${curUserId}", amtC.text, "${response.paymentId}");
    amtC.clear();
    getWalletApi(curUserId.toString());
    Navigator.pop(context);
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

   Getwalletmodel? walletData;
  //
  //  getWallet() async {
  //    SharedPreferences preferences = await SharedPreferences.getInstance();
  //    String? id = preferences.getString("id");
  //
  //    print('_________________>>>>>>>>>>>>>>>>>>>>>${id}');
  //    var headers = {
  //      'Cookie': 'ci_session=8c2275d8af8aa49a38366843cf03ea05190bd53b'
  //    };
  //    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/bus_booking/api/get_wallet_transaction'));
  //    request.fields.addAll({
  //      'user_id': id.toString()
  //    });
  //
  //    request.headers.addAll(headers);
  //
  //    http.StreamedResponse response = await request.send();
  //
  //    if (response.statusCode == 200) {
  //      var walletresult = await response.stream.bytesToString();
  //      final finalresponse = Getwalletmodel.fromJson(json.decode(walletresult));
  //      setState((){
  //        walletData = finalresponse;
  //      });
  //
  //    }
  //    else {
  //    print(response.reasonPhrase);
  //    }
  //  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // getWallet();
    getWalletApi(curUserId.toString());
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        iconTheme: IconThemeData(color: white),
        title: Text(
          "My Wallet",
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontWeight: FontWeight.w700,color:white),
        ),
      ),
      body:
      FadedSlideAnimation(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 90,
                    width: 170,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, border: Border.all(color: primary)),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        children:[
                      Text(
                        "Current Balance",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      Text('\₹' + "${walletDataModel.tatalBalance??0}",
                          style: Theme.of(context).textTheme
                              .headline4!
                              .copyWith(color: blackColor),
                          textAlign: TextAlign.center),
                  ]))),
                  // Text(
                  //   "Your Balance",
                  //   style: Theme.of(context).textTheme.bodyText2,
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(
                  //   height: 4,
                  // ),
                  // Text('\₹' + balance.toString(),
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .headline4!
                  //         .copyWith(color: blackColor),
                  //     textAlign: TextAlign.center),
                  // SizedBox(
                  //   height: 50,
                  // ),
                  // Image.asset("assets/mywallet.jpg", height: 300, width: 300,),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                commonButton(
                    title: "Add Money",
                    loading: false,
                    context: context,
                    onPressed: ()
                 {
                   _showDialog();
                 }
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                  itemCount: walletDataModel.data?.length??0,
                  itemBuilder: (context,index){

                    return  Card(
                      child: ListTile(
                        
                         title:Text("${walletDataModel.data?[index].amount??0}") ,
                        subtitle: Text("${walletDataModel.data?[index].transactionId??0}"),
                        trailing: Text("${walletDataModel.data?[index].createdAt??0}"),
                       ),
                    );
              }),
            )

          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
