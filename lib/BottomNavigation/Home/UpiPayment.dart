import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:upi_pay_x/upi_pay.dart';

String? transtionId;
class UpiPayment{
  String amount;

  BuildContext context;
  ValueChanged onResult;
  List<ApplicationMeta>? _apps;
  UpiPayment(this.amount, this.context, this.onResult);


  void initPayment() async{
    print("trasaction id in ${transtionId}");
    _apps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all);
    showModalBottomSheet(context: context, builder: (BuildContext context){
      return Container(
        //  color: Colors.red,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text("jhgsufgff"),
            appsGrid(_apps!),
          ],
        ),
      );
    });
  }

  GridView appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return
      GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        // childAspectRatio: 1.6,
        physics: NeverScrollableScrollPhysics(),
        children: apps
            .map(
              (it) => Material(
            key: ObjectKey(it.upiApplication),
            // color: Colors.grey[200],
            child: InkWell(
              onTap: Platform.isAndroid ? () async => await onTap(it) : null,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    it.iconImage(48),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      child: Text(
                        it.upiApplication.getAppName(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).toList(),
      );
  }


  onTap(ApplicationMeta app) async {
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with id $transactionRef");
    UpiTransactionResponse response = await UpiPay.initiateTransaction(
      amount: "${amount}",
      app: app.upiApplication,
      receiverName: 'Bus Booking',
      receiverUpiAddress: "comfo98287@barodampay",
      transactionRef: transactionRef,
      transactionNote: 'UPI Payment',
      // merchantCode: '7372',
    );
    onResult(response);
    print("sfsfsfsfsfsfsfsfsfsfsf ${response} and ${response.status}");
    print(response.status);
    transtionId = response.txnId;
    print(response.txnId);
    print(response.txnRef);
    print(response.approvalRefNo);
  }
}