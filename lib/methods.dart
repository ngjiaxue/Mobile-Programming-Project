import 'loginscreen.dart';
import 'signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Methods {
  textOnly(String text, String fontFamily, double fontSize, Color color,
      FontWeight fontWeight, FontStyle fontStyle) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
    );
  }

  textField(
      TextInputType keyboardtype,
      bool obscureText,
      TextEditingController controller,
      Widget prefixIcon,
      Widget sufficIcon,
      String labelText,
      String fontFamily,
      double fontSize,
      InputBorder inputBorder) {
    return TextField(
      keyboardType: keyboardtype,
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: sufficIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
        ),
        border: inputBorder,
      ),
    );
  }

  textFormField(
      TextInputType keyboardtype,
      bool obscureText,
      TextEditingController controller,
      String Function(String) validator,
      Widget prefixIcon,
      Widget sufficIcon,
      String labelText,
      String fontFamily,
      double fontSize,
      InputBorder inputBorder) {
    return TextFormField(
      keyboardType: keyboardtype,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: sufficIcon,
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
        ),
        border: inputBorder,
      ),
    );
  }

  backPressed(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: textOnly("Are you sure?", "Oxanium Regular", 25.0,
                Colors.deepOrange[400], FontWeight.w600, null),
            content: textOnly("Do you want to exit Parcel Daddy?",
                "Oxanium Regular", 16.0, null, FontWeight.w500, null),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: textOnly("Exit", "Oxanium Regular", 18.0, Colors.orange,
                    FontWeight.bold, null),
              ),
              MaterialButton(
                color: Colors.orange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: textOnly("Cancel", "Oxanium Regular", 18.0, Colors.white,
                    FontWeight.bold, null),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        ) ??
        false;
  }

  showMessage(String msg, Toast toastLength, ToastGravity gravity,
      Color backgroundColor, Color textColor, double fontSize) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize);
  }

  Widget coverPhoto(double height) {
    return Container(
      width: double.infinity,
      height: height,
      child: Image.asset(
        "assets/images/cover.gif",
        fit: BoxFit.cover,
      ),
    );
  }

  appBarColor() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Colors.deepOrange[900],
              Colors.deepOrange,
              Colors.deepOrange[300],
            ]),
      ),
    );
  }

  divider() {
    return Divider(
      color: Colors.grey,
      thickness: 1.5,
    );
  }

  statusButton(String status, bool _color, Function method) {
    //start statusButton method
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      onPressed: method,
      child: _color
          ? Ink(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange[200],
                      Colors.orange[300],
                      Colors.orange[400],
                      Colors.orange[600],
                      Colors.orange[700],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                child:
                    textOnly(status, "Oxanium Regular", 20.0, null, null, null),
              ),
            )
          : textOnly(status, "Oxanium Regular", 20.0, null, null, null),
    );
  } //end statusButton method

  pendingOrDeliveringOrDelivered(String status) {
    //start _pendingOrDeliveringOrDelivered method
    if (status == "Pending") {
      return detailsShow(
          status, Colors.yellow[300]); //call _detailsShow method when Pending
    } else if (status == "Delivering") {
      return detailsShow(status,
          Colors.orange[200]); //call _detailsShow method when Delivering
    } else {
      return detailsShow(
          status, Colors.green[400]); //call _detailsShow method when Delivered
    }
  } //end _pendingOrDeliveringOrDelivered method

  detailsShow(String status, Color color) {
    //start _detailsShow method
    return Padding(
      padding: const EdgeInsets.only(left: 230.0, right: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: color,
        ),
        child: Align(
          alignment: Alignment.center,
          child: textOnly(status, "Oxanium Regular", 20.0, null, null, null),
        ),
      ),
    );
  } //end _detailsShow method

  showUnregisteredDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: Text(
          "Please login or sign up to continue!",
          textAlign: TextAlign.justify,
          style: TextStyle(fontFamily: "Oxanium Regular", fontSize: 18.0),
        ),
        actions: <Widget>[
          new FlatButton(
            child: textOnly("Login", "Oxanium Regular", 18.0, Colors.orange,
                FontWeight.bold, null),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen(1),
                ),
              );
            },
          ),
          new FlatButton(
            child: textOnly("Sign Up", "Oxanium Regular", 18.0, Colors.orange,
                FontWeight.bold, null),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen(),
                ),
              );
            },
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
