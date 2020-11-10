import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(SignUpScreen());

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _signUpKey = GlobalKey<FormState>();
  Methods methods = new Methods();
  FocusNode focusNode = new FocusNode();
  bool _passwordHidden = true;
  bool _passwordHidden1 = true;
  bool _isChecked = false;
  bool _validate = false;
  List<bool> _informationValidate = [false, false, false, false, false];
  double screenHeight;
  String urlSignUp = "https://parceldaddy2020.000webhostapp.com/php/signup.php";
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _retypepasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: WillPopScope(
        //to prevent when user misclick back button
        onWillPop: _onBackPressed, //call _onBackPressed method
        child: Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.orange[600],
            cursorColor: Colors.deepOrange,
          ),
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(-24.0),
              child: AppBar(
                backgroundColor: Colors.white,
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  methods.coverPhoto(screenHeight / 4), //call upperPhoto method
                  signUpCard(context), //call signUpCard method,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpCard(BuildContext context) {
    //start signUpCard method
    return Container(
      height: screenHeight / 1.3,
      margin: EdgeInsets.only(
        top: screenHeight / 4.7,
        left: 5.0,
        right: 5.0,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
          side: BorderSide(
            color: Colors.black26,
          ),
        ),
        color: Colors.white,
        elevation: 10.0,
        child: SingleChildScrollView(
          child: Form(
            key: _signUpKey,
            autovalidate: _validate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  //start Login and SignUp navigator
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        //start Login navigator
                        onTap: _login, //call _login method
                        child: methods.textOnly(
                            "Login",
                            "Oxanium Regular",
                            25.0,
                            Colors.black45,
                            null,
                            null), //end Login navigator
                      ),
                      methods.textOnly("Sign Up", "Oxanium Regular", 30.0,
                          Colors.deepOrange[400], FontWeight.bold, null),
                    ],
                  ),
                ), //end Login and SignUp navigator
                //start name to retype password textformfield
                Padding(
                  //end name textformfield
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: methods.textFormField(
                      null,
                      false,
                      _nameController,
                      _validateName,
                      Icon(Icons.sort_by_alpha),
                      null,
                      "Name",
                      "Oxanium Regular",
                      16.0,
                      null),
                ), //end name textformfield
                Padding(
                  //start email textformfield
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: methods.textFormField(
                      null,
                      false,
                      _emailController,
                      _validateEmail,
                      Icon(Icons.email),
                      null,
                      "Email",
                      "Oxanium Regular",
                      16.0,
                      null),
                ), //end email textformfield
                Padding(
                  //start phone textformfield
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    controller: _phoneController,
                    validator: _validatePhone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: "Phone",
                      labelStyle: TextStyle(
                          fontFamily: "Oxanium Regular",
                          fontSize: 16.0,
                          color: Colors.black54),
                    ),
                  ),
                ), //end phone textformfield

                Padding(
                  //start password textformfield
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: methods.textFormField(
                      null,
                      _passwordHidden,
                      _passwordController,
                      _validatePassword,
                      Icon(Icons.lock),
                      IconButton(
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
                      "Password",
                      "Oxanium Regular",
                      16.0,
                      null),
                ), //end password textformfield
                Padding(
                  //start retype password textformfield
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: methods.textFormField(
                      null,
                      _passwordHidden1,
                      _retypepasswordController,
                      _validateRetypePassword,
                      Icon(Icons.lock),
                      IconButton(
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
                      "Re-type Password",
                      "Oxanium Regular",
                      16.0,
                      null),
                ), //end retype password textformfield
                //end name to retype password textformfield
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        activeColor: Colors.orange[600],
                        onChanged: (bool value) {
                          _onTick(value); //call _onTick method
                        },
                      ),
                      methods.textOnly("I accept the terms in the ",
                          "Oxanium Regular", 12.0, null, null, null),
                      InkWell(
                        onTap: _showEULA, //call _showEULA method
                        child: Text(
                          "License Agreement",
                          style: TextStyle(
                              color: Colors.blue,
                              fontFamily: "Oxanium Regular",
                              fontSize: 12.0,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ), //end accept EULA
                Align(
                  //start register button
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      right: 23.0,
                      bottom: 20.0,
                    ),
                    child: SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: FloatingActionButton(
                        splashColor: Colors.orange[800],
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.orange[200],
                                  Colors.orange[300],
                                  Colors.orange,
                                  Colors.orange[700],
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 35.0),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30.0,
                            ),
                          ),
                        ),
                        onPressed: _signUp, //call _signUp method
                        backgroundColor: Colors.orange[300],
                      ),
                    ),
                  ),
                ), //end register button
              ],
            ),
          ),
        ),
      ),
    );
  } //end signUpCard method

  String _validateName(String value) {
    //start _validateName method
    if (value.length < 3) {
      _informationValidate[0] = false;
      return 'Name must be more than 2 charater';
    } else {
      _informationValidate[0] = true;
      return null;
    }
  } //end _validateName method

  String _validateEmail(String value) {
    //start _validateEmail method
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[com]{3,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      _informationValidate[1] = false;
      return 'Please enter a valid email';
    } else {
      _informationValidate[1] = true;
      return null;
    }
  } //end _validateEmail method

  String _validatePhone(String value) {
    //start _validatePhone method
    if (value.length < 10) {
      _informationValidate[2] = false;
      return 'Phone number must be only 10/11 digits';
    } else {
      _informationValidate[2] = true;
      return null;
    }
  } //end _validatePhone method

  String _validatePassword(String value) {
    //start _validatePassword method
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    } else if (!value.contains(new RegExp(r"(?=.*?[A-Z])"))) {
      _informationValidate[3] = false;
      return 'Password must have at least 1 uppercase letter';
    } else if (!value.contains(new RegExp(r"(?=.*?[a-z])"))) {
      _informationValidate[3] = false;
      return 'Password must have at least 1 lowercase letter';
    } else if (!value.contains(new RegExp(r"(?=.*?[0-9])"))) {
      _informationValidate[3] = false;
      return 'Password must have at least 1 number';
    } else if (!value.contains(new RegExp(r"(?=.*?[#?!@$%^&*-])"))) {
      _informationValidate[3] = false;
      return 'Password must have at least 1 special character';
    } else {
      _informationValidate[3] = true;
      return null;
    }
  } //end _validatePassword method

  String _validateRetypePassword(String value) {
    //start _validateRetypePassword method
    if (value != _passwordController.text) {
      _informationValidate[4] = false;
      return 'Password Not Match';
    } else {
      _informationValidate[4] = true;
      return null;
    }
  } //end _validateRetypePassword method

  void _login() {
    //start _login method
    if (_emailController.text.isNotEmpty ||
        _nameController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty ||
        _retypepasswordController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: methods.textOnly("Already have an account?",
                "Oxanium Regular", 20.0, null, null, null),
            actions: <Widget>[
              new FlatButton(
                child: methods.textOnly("No", "Oxanium Regular", 18.0,
                    Colors.orange, FontWeight.bold, null),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: methods.textOnly("Yes", "Oxanium Regular", 18.0,
                    Colors.orange, FontWeight.bold, null),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _passwordController.clear();
                    _retypepasswordController.clear();
                    _login();
                  });
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          );
        },
      );
    } else {
      Navigator.pop(context);
    }

    //if Login pressed then pop signupscreen
  } //end _login method

  void _onTick(bool value) {
    //start _onTick method
    setState(() {
      _isChecked = value;
      if (_signUpKey.currentState.validate()) {
        _signUpKey.currentState.save();
      } else {
        setState(() {
          _validate = true;
        });
      }
    });
  } //end _onTick method

  void _showEULA() {
    //start _showEULA method
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: methods.textOnly("EULA of Parcel Daddy", "Oxanium Regular",
              25.0, Colors.deepOrange[400], FontWeight.bold, null),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                        ),
                        text:
                            "This End-User License Agreement (\"EULA\") is a legal agreement between you and Parcel Daddy\n\nThis EULA agreement governs your acquisition and use of our Parcel Daddy software (\"Software\") directly from Parcel Daddy or indirectly through a Parcel Daddy authorized reseller or distributor (a \"Reseller\").\n\nPlease read this EULA agreement carefully before completing the installation process and using the Parcel Daddy software. It provides a license to use the Parcel Daddy software and contains warranty information and liability disclaimers.\n\nIf you register for a free trial of the Parcel Daddy software, this EULA agreement will also govern that trial. By clicking \"accept\" or installing and/or using the Parcel Daddy software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.\n\nIf you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.\n\nThis EULA agreement shall apply only to the Software supplied by Parcel Daddy herewith regardless of whether other software is referred to or described herein. The terms also apply to any Parcel Daddy updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Parcel Daddy.",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: methods.textOnly("Cancel", "Oxanium Regular", 18.0,
                  Colors.orange, FontWeight.bold, null),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
                setState(() {
                  _isChecked = false;
                });
              },
            ),
            new FlatButton(
              child: methods.textOnly("Accept", "Oxanium Regular", 18.0,
                  Colors.orange, FontWeight.bold, null),
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
                setState(() {
                  _isChecked = true;
                });
              },
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        );
      },
    );
  } //end _showEULA method

  void _signUp() {
    //start _signUp method
    if (_emailController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _retypepasswordController.text.isNotEmpty) {
      //test if all blanks is not empty
      if (_isChecked == false) {
        //test whether user agree EULA or not
        methods.showMessage(
            "Please accept the License Agreement",
            Toast.LENGTH_SHORT,
            ToastGravity.CENTER,
            Colors.red,
            Colors.white,
            16.0);
      } else if (_informationValidate[0] == true &&
          _informationValidate[1] == true &&
          _informationValidate[2] == true &&
          _informationValidate[3] == true &&
          _informationValidate[4] == true) {
        //add user data into database
        String name = _nameController.text;
        String email = _emailController.text;
        String phone = _phoneController.text;
        String password = _passwordController.text;
        http.post(urlSignUp, body: {
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
        }).then((res) {
          if (res.body == "success") {
            //if successfully added to database then pop signupscreen
            Navigator.pop(context);
            methods.showMessage(
                "Registration success, please check your email to verify your account",
                Toast.LENGTH_LONG,
                ToastGravity.CENTER,
                Colors.orange[400],
                Colors.white,
                16.0);
          } else {
            methods.showMessage("Registration Failed", Toast.LENGTH_SHORT,
                ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
          }
        }).catchError((err) {
          print(err);
        });
      } else {
        methods.showMessage("Please amend the error(s)", Toast.LENGTH_SHORT,
            ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
      }
    } else {
      //test if any blanks is empty
      methods.showMessage("Please fill in all the blanks", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
    }
  } //end _signUp method

  Future<bool> _onBackPressed() {
    //start _onBackPressed method
    return methods.backPressed(context);
  } //end _onBackPressed method
}
