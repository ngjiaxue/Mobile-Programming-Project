import 'user.dart';
import 'methods.dart';
import 'loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(ResetPassword());

class ResetPassword extends StatefulWidget {
  final User user;
  const ResetPassword({Key key, this.user}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _resetPasswordKey = GlobalKey<FormState>();
  Methods methods = new Methods();
  ImageProvider _image;
  bool _passwordHidden = true;
  bool _passwordHidden1 = true;
  bool _passwordHidden2 = true;
  List<bool> _informationValidate = [false, false];
  int _i = 0;
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _resetPasswordController = TextEditingController();
  TextEditingController _retypeResetPasswordController =
      TextEditingController();
  String urlResetPasswordVerify =
      "https://parceldaddy2020.000webhostapp.com/php/inappresetpasswordverify.php";
  String urlResetNewPassword =
      "https://parceldaddy2020.000webhostapp.com/php/inappresetpassword.php";
  @override
  void initState() {
    super.initState();
    _image = AssetImage("assets/images/password.jpg");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_image, context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.orange[600],
          cursorColor: Colors.deepOrange,
        ),
        child: Scaffold(
          backgroundColor: Colors.deepOrange[50],
          appBar: AppBar(
            backgroundColor: Colors.orange[800],
            title: methods.textOnly(
                "Reset Password?", "Pacifico Regular", 30.0, null, null, null),
            flexibleSpace: methods.appBarColor(),
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.transparent.withOpacity(0.3), BlendMode.dstATop),
              ),
            ),
            child: Form(
              key: _resetPasswordKey,
              autovalidateMode: AutovalidateMode.always,
              child: SafeArea(
                child: _resetPassword(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _resetPassword() {
    if (_i == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextField(
                  obscureText: _passwordHidden,
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordHidden = !_passwordHidden;
                        });
                      },
                    ),
                    labelText: "Old Password",
                    labelStyle: TextStyle(
                      fontFamily: "Oxanium Regular",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 50.0,
                  right: 50.0,
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Colors.black38,
                    ),
                  ),
                  splashColor: Colors.orange[800],
                  onPressed: () =>
                      _oldPasswordVerify(_oldPasswordController.text),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange[200],
                            Colors.orange,
                            Colors.orange[700],
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 40.0),
                      alignment: Alignment.center,
                      child: methods.textOnly("Submit", "Oxanium Regular", 20.0,
                          Colors.white, null, null),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TextFormField(
                obscureText: _passwordHidden1,
                controller: _resetPasswordController,
                validator: _validatePassword,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordHidden1
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordHidden1 = !_passwordHidden1;
                      });
                    },
                  ),
                  labelText: "New Password",
                  labelStyle: TextStyle(
                    fontFamily: "Oxanium Regular",
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  obscureText: _passwordHidden2,
                  controller: _retypeResetPasswordController,
                  validator: _validateRetypePassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordHidden2
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordHidden2 = !_passwordHidden2;
                        });
                      },
                    ),
                    labelText: "Re-type New Password",
                    labelStyle: TextStyle(
                      fontFamily: "Oxanium Regular",
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 50.0,
                  right: 50.0,
                ),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Colors.black38,
                    ),
                  ),
                  splashColor: Colors.orange[800],
                  onPressed: () => _resetNewPassword(
                      _resetPasswordController.text,
                      _retypeResetPasswordController.text),
                  padding: const EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange[200],
                            Colors.orange,
                            Colors.orange[700],
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 40.0),
                      alignment: Alignment.center,
                      child: methods.textOnly("Reset Password",
                          "Oxanium Regular", 20.0, Colors.white, null, null),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _oldPasswordVerify(String oldPassword) {
    String email = widget.user.getEmail();
    http.post(urlResetPasswordVerify, body: {
      "email": email,
      "oldpassword": oldPassword,
    }).then((res) {
      if (res.body == "success") {
        setState(() {
          _i = 1;
        });
      } else {
        methods.showMessage(
            "Password not match, please try again or contact admin.",
            Toast.LENGTH_SHORT,
            ToastGravity.CENTER,
            Colors.red,
            Colors.white,
            16.0);
        setState(() {
          _oldPasswordController.clear();
        });
      }
    });
  }

  String _validatePassword(String value) {
    //start _validatePassword method
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!value.contains(new RegExp(r"(?=.*?[A-Z])"))) {
      _informationValidate[0] = false;
      return 'Password must have at least 1 uppercase letter';
    } else if (!value.contains(new RegExp(r"(?=.*?[a-z])"))) {
      _informationValidate[0] = false;
      return 'Password must have at least 1 lowercase letter';
    } else if (!value.contains(new RegExp(r"(?=.*?[0-9])"))) {
      _informationValidate[0] = false;
      return 'Password must have at least 1 number';
    } else if (!value.contains(new RegExp(r"(?=.*?[#?!@$%^&*-])"))) {
      _informationValidate[0] = false;
      return 'Password must have at least 1 special character';
    } else {
      _informationValidate[0] = true;
      return null;
    }
  } //end _validatePassword method

  String _validateRetypePassword(String value) {
    //start _validateRetypePassword method
    if (value != _resetPasswordController.text) {
      _informationValidate[1] = false;
      return 'Password Not Match';
    } else {
      _informationValidate[1] = true;
      return null;
    }
  } //end _validateRetypePassword method

  void _resetNewPassword(String newPassword, String retypeNewPassword) {
    String email = widget.user.getEmail();
    if (newPassword == retypeNewPassword &&
        _informationValidate[0] &&
        _informationValidate[1]) {
      http.post(urlResetNewPassword, body: {
        "email": email,
        "password": newPassword,
      }).then((res) {
        if (res.body == "success") {
          methods.showMessage(
              "Password successfully changed, please login again to continue",
              Toast.LENGTH_SHORT,
              ToastGravity.CENTER,
              Colors.orange[400],
              Colors.white,
              16.0);
          Navigator.push(
            context,
            ScaleRoute(
              page: LoginScreen(2),
            ),
          );
        } else {
          methods.showMessage("Please contact admin!", Toast.LENGTH_SHORT,
              ToastGravity.CENTER, Colors.orange[400], Colors.white, 16.0);
        }
      });
    } else if (newPassword == retypeNewPassword &&
        _informationValidate[0] == false) {
      methods.showMessage("Please amend the error(s)", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
    } else {
      methods.showMessage("Password Not Match", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
    }
  }
}
