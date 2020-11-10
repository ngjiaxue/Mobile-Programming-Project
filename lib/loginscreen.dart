import 'user.dart';
import 'tabs.dart';
import 'methods.dart';
import 'admintabs.dart';
import 'signupscreen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LoginScreen(1));

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
              ),
            ),
            child: child,
          ),
        );
}

class LoginScreen extends StatefulWidget {
  final int
      userLogout; //1 = do ntg, 2 = clear password & remember me, 3 = clear email & password & remember me
  LoginScreen(this.userLogout);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _loginKey = GlobalKey<FormState>();
  Methods methods = new Methods();
  List<bool> _informationValidate = [false, false];
  bool _passwordHidden = true;
  bool _passwordHidden1 = true;
  bool _passwordHidden2 = true;
  bool _isChecked = false;
  double screenHeight;
  String urlLogin = "https://parceldaddy2020.000webhostapp.com/php/login.php";
  String urlResend =
      "https://parceldaddy2020.000webhostapp.com/php/resendverify.php";
  String urlForgetPassword =
      "https://parceldaddy2020.000webhostapp.com/php/forgetpassword.php";
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _resetPasswordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadPref(); //call _loadPref method
  }

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
        onWillPop: _onBackPressed,
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
                  loginCard(context), //call loginCard method
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginCard(BuildContext context) {
    //start loginCard method
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                //start Login and SignUp navigator
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    methods.textOnly("Login", "Oxanium Regular", 30.0,
                        Colors.deepOrange[400], FontWeight.bold, null),
                    GestureDetector(
                      //start Sign Up navigator
                      onTap: _signUp, //call _signUp method
                      child: methods.textOnly("Sign Up", "Oxanium Regular",
                          25.0, Colors.black45, null, null),
                    ), //end Sign Up navigator
                  ],
                ),
              ), //end Login and SignUp navigator
              //start Welcome to Parcel Daddy text
              Padding(
                //start Welcome to text
                padding: const EdgeInsets.only(
                  top: 30.0,
                  left: 20.0,
                ),
                child: methods.textOnly("Welcome to", "Oxanium Regular", 40.0,
                    Colors.black, FontWeight.normal, null),
              ), //end Welcome to text
              Padding(
                //start Parcel Daddy text
                padding: const EdgeInsets.only(left: 20.0),
                child: methods.textOnly("Parcel Daddy!", "Oxanium Regular",
                    40.0, Colors.black, FontWeight.normal, null),
              ), //end Parcel Daddy text
              //end Welcome to Parcel Daddy text
              //start email & password textfield
              Padding(
                //start email textfield
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: methods.textField(
                  TextInputType.emailAddress,
                  false,
                  _emailController,
                  Icon(Icons.email),
                  null,
                  "Email",
                  "Oxanium Regular",
                  16.0,
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ), //end email textfield
              Padding(
                //start password textfield
                padding: const EdgeInsets.only(
                  top: 20.0,
                  left: 20.0,
                  right: 20.0,
                ),
                child: methods.textField(
                  TextInputType.emailAddress,
                  _passwordHidden,
                  _passwordController,
                  Icon(Icons.lock),
                  IconButton(
                    icon: Icon(
                      _passwordHidden ? Icons.visibility_off : Icons.visibility,
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
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ), //start password textfield
              //end email & password textfield
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
                    methods.textOnly("Remember Me", "Oxanium Regular", null,
                        null, null, null),
                  ],
                ),
              ), //end remember me
              Padding(
                //start Forget Password
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () => _forgetPassword(), //call _forgetPassword method
                  child: methods.textOnly(
                      "Forget Password?",
                      "Oxanium Regular",
                      18.0,
                      Colors.blue[600],
                      FontWeight.normal,
                      FontStyle.italic),
                ),
              ), //end Forget Password
              Padding(
                //start Resend Verification Email
                padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                child: GestureDetector(
                  onTap:
                      _resendVerificationEmail, //call _resendVerificationEmail method
                  child: methods.textOnly(
                      "Resend Verification Email?",
                      "Oxanium Regular",
                      18.0,
                      Colors.blue[600],
                      null,
                      FontStyle.italic),
                ),
              ), //start Resend Verification Email
              Align(
                //start login button
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 21.0,
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
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 35.0),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 30.0,
                          ),
                        ),
                      ),
                      onPressed: _login,
                      backgroundColor: Colors.orange[300],
                    ),
                  ),
                ),
              ),
              //end login button
            ],
          ),
        ),
      ),
    );
  } //end loginCard method

  void _savePref(int value) async {
    //start _savePref method
    String email = _emailController.text;
    String password = _passwordController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == 1) {
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      methods.showMessage("Email & Password saved", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.orange[400], Colors.white, 16.0);
    } else if (value == 2) {
      await prefs.setString('email', email);
      await prefs.setString('pass', '');
      setState(() {
        _emailController.text = email;
        _passwordController.text = '';
        _isChecked = false;
      });
    } else {
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailController.text = '';
        _passwordController.text = '';
        _isChecked = false;
      });
      methods.showMessage("Email & Password removed", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.orange[400], Colors.white, 16.0);
    }
  } //end _savePref method

  void _loadPref() async {
    //start _loadPref method
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (widget.userLogout == 1 && email.length > 1) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        if (_passwordController.text.isNotEmpty) {
          _isChecked = true;
        } else {
          _isChecked = false;
        }
      });
    } else if (widget.userLogout == 2) {
      setState(() {
        _emailController.text = email;
        _passwordController.clear();
        _savePref(2);
      });
    } else {
      setState(() {
        prefs.setString('email', null);
        prefs.setString('pass', null);
        _emailController.clear();
        _passwordController.clear();
      });
    }
  } //end _loadPref method

  void _signUp() {
    //start _signUp method
    Navigator.push(
      context,
      ScaleRoute(
        page: SignUpScreen(),
      ),
    ); //route to signupscreen
  } //end _signUp method

  void _onTick(bool value) {
    //start _onTick method
    setState(() {
      _isChecked = value;
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        if (_isChecked) {
          _savePref(1); //call _savePref method
        } else {
          _savePref(3); //call _savePref method
        }
      } else {
        methods.showMessage("Please fill in all the blanks", Toast.LENGTH_SHORT,
            ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
        _isChecked = false;
      }
    });
  } //end _onTick method

  void _forgetPassword() {
    //start _forgetPassword method
    TextEditingController _forgetPasswordEmailController =
        TextEditingController();
    TextEditingController _retypeResetPasswordController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, newSetState) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.orange[600],
              cursorColor: Colors.deepOrange,
            ),
            child: AlertDialog(
              title: methods.textOnly("Forgot Password?", "Oxanium Regular",
                  25.0, Colors.deepOrange[400], null, null),
              content: new Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: _loginKey,
                    autovalidate: true,
                    child: Column(
                      children: <Widget>[
                        methods.textFormField(
                            null,
                            false,
                            _forgetPasswordEmailController,
                            _validateEmail,
                            Icon(Icons.email),
                            null,
                            "Email",
                            "Oxanium Regular",
                            null,
                            null),
                        methods.textFormField(
                            null,
                            _passwordHidden1,
                            _resetPasswordController,
                            _validatePassword,
                            Icon(Icons.lock),
                            IconButton(
                              icon: Icon(
                                _passwordHidden1
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                newSetState(() {
                                  _passwordHidden1 = !_passwordHidden1;
                                });
                              },
                            ),
                            "New Password",
                            "Oxanium Regular",
                            null,
                            null),
                        methods.textFormField(
                            null,
                            _passwordHidden2,
                            _retypeResetPasswordController,
                            _validateRetypePassword,
                            Icon(Icons.lock),
                            IconButton(
                              icon: Icon(
                                _passwordHidden2
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                newSetState(() {
                                  _passwordHidden2 = !_passwordHidden2;
                                });
                              },
                            ),
                            "Re-type New Password",
                            "Oxanium Regular",
                            null,
                            null),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: methods.textOnly("No", "Oxanium Regular", 18.0,
                      Colors.orange, FontWeight.bold, null),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  color: Colors.orange[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: methods.textOnly("Yes", "Oxanium Regular", 18.0,
                      Colors.white, FontWeight.bold, null),
                  onPressed: () {
                    String email = _forgetPasswordEmailController.text;
                    String password = _resetPasswordController.text;
                    String retypePassword = _retypeResetPasswordController.text;
                    if (email.isNotEmpty &&
                        password.isNotEmpty &&
                        retypePassword.isNotEmpty) {
                      if (password == retypePassword) {
                        http.post(urlForgetPassword, body: {
                          "email": email,
                          "password": password,
                        }).then((res) {
                          if (res.body == "success") {
                            methods.showMessage(
                                "Please check your email to reset password",
                                Toast.LENGTH_SHORT,
                                ToastGravity.CENTER,
                                Colors.orange,
                                Colors.white,
                                16.0);
                            Navigator.of(context).pop();
                            setState(() {
                              _passwordController.clear();
                              _isChecked = false;
                            });
                          } else {
                            methods.showMessage(
                                "Failed, please try again or contact admin!",
                                Toast.LENGTH_SHORT,
                                ToastGravity.CENTER,
                                Colors.red,
                                Colors.white,
                                16.0);
                          }
                        });
                      } else {
                        methods.showMessage(
                            "Password not match",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.red,
                            Colors.white,
                            16.0);
                      }
                    } else {
                      methods.showMessage(
                          "Please fill in all the blanks",
                          Toast.LENGTH_SHORT,
                          ToastGravity.CENTER,
                          Colors.red,
                          Colors.white,
                          16.0);
                    }
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
          );
        });
      },
    );
    _passwordHidden1 = true;
    _passwordHidden2 = true;
  } //end _forgetPassword method

  void _resendVerificationEmail() {
    //start _resendVerificationEmail method
    TextEditingController _resendverificationEmailController =
        TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.orange[600],
            cursorColor: Colors.deepOrange,
          ),
          child: AlertDialog(
            title: methods.textOnly("Resend Verification?", "Oxanium Regular",
                25.0, Colors.deepOrange[400], null, null),
            content: methods.textField(
                null,
                false,
                _resendverificationEmailController,
                Icon(Icons.email),
                null,
                "Email",
                "Oxanium Regular",
                null,
                null),
            actions: <Widget>[
              new FlatButton(
                child: methods.textOnly("No", "Oxanium Regular", 18.0,
                    Colors.orange, FontWeight.bold, null),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                color: Colors.orange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: methods.textOnly("Yes", "Oxanium Regular", 18.0,
                    Colors.white, FontWeight.bold, null),
                onPressed: () {
                  if (_resendverificationEmailController.text.isNotEmpty) {
                    String email = _resendverificationEmailController.text;
                    http.post(urlResend, body: {
                      //find database with the email inserted
                      "email": email,
                    });
                    Navigator.of(context).pop();
                    methods.showMessage(
                        "Confimation email resend, please check your email",
                        Toast.LENGTH_SHORT,
                        ToastGravity.CENTER,
                        Colors.orange,
                        Colors.white,
                        16.0);
                  } else {
                    methods.showMessage(
                        "Please insert email",
                        Toast.LENGTH_SHORT,
                        ToastGravity.CENTER,
                        Colors.red,
                        Colors.white,
                        16.0);
                  }
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
        );
      },
    );
  } //end _resendVerificationEmail method

  _login() async {
    //start _login method
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var res = await http.post(urlLogin, body: {
        'email': _emailController.text,
        'password': _passwordController.text
      });
      List userDetails = res.body.split("&");
      if (userDetails[0] == "success admin") {
        User user = new User(userDetails[1], userDetails[2], "ADMIN", "ADMIN",
            null, null, "XX.XX");
        Navigator.push(
          //route to tabs
          context,
          ScaleRoute(
            page: AdminTabs(user: user),
          ),
        );
      } else if (userDetails[0] == "success") {
        User user = new User(
            userDetails[1],
            userDetails[2],
            userDetails[3],
            userDetails[4],
            userDetails[5] == "" ? null : double.parse(userDetails[5]),
            userDetails[6] == "" ? null : double.parse(userDetails[6]),
            userDetails[7]);
        Navigator.push(
          context,
          ScaleRoute(
            page: Tabs(user: user),
          ),
        );
      } else if (res.body == "incorrect password") {
        methods.showMessage("Incorrect Password", Toast.LENGTH_LONG,
            ToastGravity.CENTER, Colors.orange[900], Colors.white, 16.0);
        setState(() {
          _passwordController.clear();
          _isChecked = false;
        });
        _savePref(2);
      } else if (res.body == "no verify success") {
        methods.showMessage(
            "Please check your email to activate this account",
            Toast.LENGTH_LONG,
            ToastGravity.CENTER,
            Colors.orange,
            Colors.white,
            16.0);
      } else {
        methods.showMessage("Incorrect Email/Password", Toast.LENGTH_SHORT,
            ToastGravity.CENTER, Colors.orange[900], Colors.white, 16.0);
        setState(() {
          _emailController.clear();
          _passwordController.clear();
          _isChecked = false;
        });
        _savePref(3);
      }
    } else {
      methods.showMessage("Please fill in all the blanks", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.red, Colors.white, 16.0);
    }
  } //end _login method

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

  Future<bool> _onBackPressed() {
    //start _onBackPressed method
    return methods.backPressed(context);
  } //end _onBackPressed method
}
