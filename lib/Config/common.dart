import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_pay/Config/constant.dart';
import 'package:quick_pay/model/user_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';

class Common {


}
setSnackBar(String msg, BuildContext context1) {
  /*BootstrapAlert(
    visible: true,
    status: AlertStatus.primary,
    text: 'msg',
  );*/
  // Common().toast(msg);
  BuildContext context = context1;
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    content: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    width: getWidth( 80, context),
    behavior: SnackBarBehavior.values.last,
    showCloseIcon: true,
    closeIconColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: MyColorName.mainColor,
    elevation: 5.0,
  ));
}
class Ui{
  static Color parseColor(Color hexCode, {double? opacity}) {
    return hexCode.withOpacity(opacity ?? 1);
    /*try {
      return Color(int.parse(hexCode.replaceAll("#", "0xFF"))).withOpacity(opacity ?? 1);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity ?? 1);
    }*/
  }
}



class App {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
      // Can only be 0, 1, 2 or 3
      if (int.parse(cText) > 3) {
        // Remove char
        cText = '';
      }
    } else if (cLen == 2 && pLen == 1) {
      // Days cannot be greater than 31
      int dd = int.parse(cText.substring(0, 2));
      if (dd == 0 || dd > 31) {
        // Remove char
        cText = cText.substring(0, 1);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
      // Can only be 0 or 1
      if (int.parse(cText.substring(3, 4)) > 1) {
        // Remove char
        cText = cText.substring(0, 3);
      }
    } else if (cLen == 5 && pLen == 4) {
      // Month cannot be greater than 12
      int mm = int.parse(cText.substring(3, 5));
      if (mm == 0 || mm > 12) {
        // Remove char
        cText = cText.substring(0, 4);
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 3 && pLen == 4) || (cLen == 6 && pLen == 7)) {
      // Remove / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 6 && pLen == 5) {
      // Can only be 1 or 2 - if so insert a / char
      int y1 = int.parse(cText.substring(5, 6));
      if (y1 < 1 || y1 > 2) {
        // Replace char
        cText = cText.substring(0, 5) + '/';
      } else {
        // Insert / char
        cText = cText.substring(0, 5) + '/' + cText.substring(5, 6);
      }
    } else if (cLen == 7) {
      // Can only be 1 or 2
      int y1 = int.parse(cText.substring(6, 7));
      if (y1 < 1 || y1 > 2) {
        // Remove char
        cText = cText.substring(0, 6);
      }
    } else if (cLen == 8) {
      // Can only be 19 or 20
      int y2 = int.parse(cText.substring(6, 8));
      if (y2 < 19 || y2 > 20) {
        // Remove char
        cText = cText.substring(0, 7);
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
class AlertBox {
  final String title;
  final String content;
  final BuildContext context;

  AlertBox(this.title, this.content, this.context){
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context)
            .modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 500),
        transitionBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
            ) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0,-1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.linear,
                ),
              ),
              child: child,
            ),
        pageBuilder: (BuildContext buildContext,
            Animation animation,
            Animation secondaryAnimation) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.red[100],

                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 60,
                padding: EdgeInsets.all(5),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Text(title.toString(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,letterSpacing: 1,color: Colors.red),),
                                SizedBox(height: 5,),
                                Text(content.toString(),style: TextStyle(fontSize: 12,color: Colors.red))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(buildContext);
                          },
                          child: Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

}

Widget commonButton({String title = "Btn",bool loading = false,double? width = 70,double? height,BuildContext? context,VoidCallback? onPressed,double fontSize = 20}){
  return Container(
      height: height!=null?getHeight(height, context!):null,
      width: width!=null?getWidth(width, context!):null,
      decoration: BoxDecoration(
        gradient: commonGradient(),
        borderRadius: BorderRadius.circular(40),
      ),
      child:ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
        child: !loading
            ? Text(
          title,
          style: Theme.of(context!).textTheme.headlineSmall!.copyWith(color: Colors.white,fontSize: fontSize),
        )
            : CircularProgressIndicator(
          color: Colors.white,
        ),
      )
  );
}
Gradient commonGradient(){
  return LinearGradient(
    colors: [MyColorName.mainColor, MyColorName.secondColor],
    stops: [0, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}