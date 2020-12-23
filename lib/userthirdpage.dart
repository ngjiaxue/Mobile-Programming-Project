import 'dart:io';
import 'user.dart';
import 'dart:async';
import 'dart:convert';
import 'methods.dart';
import 'loginscreen.dart';
import 'topupcredit.dart';
import 'makepayment.dart';
import 'resetpassword.dart';
import 'package:intl/intl.dart';
import 'transactionhistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

void main() => runApp(UserThirdPage());

class UserThirdPage extends StatefulWidget {
  final User user;
  final String paymentDue;
  const UserThirdPage({Key key, this.user, this.paymentDue}) : super(key: key);
  @override
  _UserThirdPageState createState() => _UserThirdPageState();
}

class _UserThirdPageState extends State<UserThirdPage> {
  var _userThirdPageKey = GlobalKey<FormState>();
  Methods methods = new Methods();
  bool _isCropping = false;
  bool _isChecked = false;
  File _image;
  Position _currentPosition;
  double latitude, longitude;
  double screenHeight, screenWidth;
  CameraPosition _home;
  CameraPosition _userpos;
  Set<Marker> markers = Set();
  MarkerId markerId1 = MarkerId("12");
  GoogleMapController gmcontroller;
  Completer<GoogleMapController> _controller = Completer();
  bool _informationValidate = false;
  String curaddress;
  int _i = 0; //if = 0 then use paymentDue get from the Tabs.dart
  String paymentDue;
  String urlUpdateAddress =
      "https://parceldaddy2020.000webhostapp.com/php/updateaddress.php";
  String urlPaymentDue =
      "https://parceldaddy2020.000webhostapp.com/php/paymentdue.php";
  String urlPayWithCredit =
      "https://parceldaddy2020.000webhostapp.com/php/paywithcredit.php";
  String urlGetNewCredit =
      "https://parceldaddy2020.000webhostapp.com/php/getnewcredit.php";
  String urlEditProfile =
      "https://parceldaddy2020.000webhostapp.com/php/editprofile.php";
  String urlUpdateProfilePic =
      "https://parceldaddy2020.000webhostapp.com/php/updateprofilepic.php";
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_i == 0) {
      paymentDue = widget.paymentDue;
    }
    _i++;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    if (_isCropping == false && paymentDue != null) {
      return Scaffold(
        backgroundColor: Colors.deepOrange[50],
        endDrawer: profileDrawer(context),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight / 2.8),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orange[800],
            flexibleSpace: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: GestureDetector(
                      onTap: _changeProfilePic,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          height: 120.0,
                          width: 120.0,
                          imageUrl:
                              "https://parceldaddy2020.000webhostapp.com/images/profileImages/${widget.user.getEmail()}.jpg",
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 60.0,
                            child: Image.asset(
                                "assets/images/defaultprofilepic.png"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                    child: methods.textOnly(
                        widget.user.getName(),
                        "Acme Regular",
                        30.0,
                        Colors.white,
                        FontWeight.bold,
                        null),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      widget.user.getAddress(),
                      style: TextStyle(
                        fontFamily: "Oxanium Regular",
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
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
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                _showDetails("Name", widget.user.getName(), 1),
                _showDetails("Email", widget.user.getEmail(), 2),
                _showDetails("Phone", widget.user.getPhone(), 3),
                _showDetails(
                    "Address   ",
                    widget.user.getAddress().toString().length > 25
                        ? widget.user.getAddress().toString().substring(0, 25) +
                            "..."
                        : widget.user.getAddress(),
                    4),
                SizedBox(
                  height: 13.0,
                ),
                _showDetails("Credit", "RM" + widget.user.getCredit(), 5),
                _showDetails(
                    "Payment due",
                    (paymentDue == "0.00" || paymentDue == "XX.XX")
                        ? "RM" + paymentDue
                        : "- RM" + paymentDue,
                    6),
                SizedBox(
                  height: 13.0,
                ),
                _showDetails("Transaction History", "", 7)
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.deepOrange[50],
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget profileDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: methods.textOnly(widget.user.getName(), "Acme Regular",
                18.0, null, FontWeight.bold, null),
            accountEmail: methods.textOnly(
                widget.user.getEmail(), "Acme Regular", 15.0, null, null, null),
            currentAccountPicture: GestureDetector(
              onTap: _changeProfilePic,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: CachedNetworkImage(
                  height: 120.0,
                  width: 120.0,
                  imageUrl:
                      "https://parceldaddy2020.000webhostapp.com/images/profileImages/${widget.user.getEmail()}.jpg",
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: 60.0,
                    child: Image.asset("assets/images/defaultprofilepic.png"),
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/drawerphoto.jpg"),
              ),
            ),
          ),
          InkWell(
              child: ListTile(
                leading: Icon(Icons.restore),
                title: methods.textOnly(
                    "Reset Password", "Acme Regular", 18.0, null, null, null),
              ),
              onTap: () {
                if (widget.user.getEmail() != 'Unregistered') {
                  Navigator.push(
                    context,
                    ScaleRoute(
                      page: ResetPassword(user: widget.user),
                    ),
                  );
                } else {
                  methods.showUnregisteredDialog(context);
                }
              }),
          InkWell(
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.deepOrange[600],
              ),
              title: methods.textOnly("Logout", "Acme Regular", 18.0,
                  Colors.deepOrange[600], null, null),
            ),
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: methods.textOnly("Do you wish to logout?",
                      "Oxanium Regular", 20.0, null, null, null),
                  actions: <Widget>[
                    new FlatButton(
                      child: methods.textOnly("Yes", "Oxanium Regular", 18.0,
                          Colors.orange, FontWeight.bold, null),
                      onPressed: () => Navigator.push(
                        context,
                        ScaleRoute(
                          page: LoginScreen(2),
                        ),
                      ),
                    ),
                    new FlatButton(
                      color: Colors.orange[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: methods.textOnly("No", "Oxanium Regular", 18.0,
                          Colors.white, FontWeight.bold, null),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showDetails(String leading, String content, int i) {
    Color color;
    if ((i == 4 && (content == "")) ||
        (i == 5 && (content == "RM0.00")) ||
        (i == 6 && (content != "RM0.00" && content != "RMXX.XX"))) {
      color = Colors.red;
    } else {
      color = Colors.black45;
    }
    Border border;
    if (widget.user.getEmail() == 'Unregistered') {
      content = 'Unregistered';
    }
    if (i % 2 != 0) {
      border = Border(
        top: BorderSide(
          color: Colors.black26,
        ),
        bottom: BorderSide(
          color: Colors.black26,
        ),
      );
    } else if (i == 4 || i == 6) {
      border = Border(
        bottom: BorderSide(
          color: Colors.black26,
        ),
      );
    } else {
      border = Border();
    }
    return InkWell(
      onTap: () {
        if (widget.user.getEmail() != 'Unregistered') {
          if (i == 1) {
            _editName();
          } else if (i == 2) {
            _editEmail();
          } else if (i == 3) {
            _editPhone();
          } else if (i == 4) {
            _loadMapDialog();
          } else if (i == 5) {
            _addCredit();
          } else if (i == 6) {
            _makePayment();
          } else if (i == 7) {
            Navigator.push(
              context,
              ScaleRoute(
                page: TransactionHistory(
                  user: widget.user,
                ),
              ),
            );
          }
        } else {
          methods.showUnregisteredDialog(context);
        }
      },
      child: Ink(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: border,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              methods.textOnly(leading, "Acme Regular", 22.0, null, null, null),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  methods.textOnly(
                      content, "Acme Regular", 18.0, color, null, null),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: color,
                    size: 26.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editName() {
    _showDialog("Edit Name?", "Insert New Name", "New Name", _validateName,
        Icon(Icons.sort_by_alpha), null, null);
  }

  void _editEmail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "You have to login again if you change your email, do you wish to continue?",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Oxanium Regular", fontSize: 20.0),
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
                Navigator.of(context).pop();
                _showDialog("Edit Email?", "Insert New Email", "New Email",
                    _validateEmail, Icon(Icons.email), null, null);
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        );
      },
    );
  }

  void _editPhone() {
    _showDialog(
      "Edit Phone?",
      "Insert New Phone",
      "New Phone",
      _validatePhone,
      Icon(Icons.phone),
      TextInputType.number,
      [FilteringTextInputFormatter.digitsOnly],
    );
  }

  void _addCredit() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: methods.textOnly("Topup Credit?", "Oxanium Regular", 25.0,
              Colors.deepOrange[400], null, null),
          content: Text(
            "Wish to topup credit?",
            style: TextStyle(fontFamily: "Oxanium Regular", fontSize: 20.0),
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
              onPressed: () async {
                Navigator.of(context).pop();
                if (widget.user.getEmail() != 'Unregistered') {
                  var now = new DateTime.now();
                  var formatter = new DateFormat('ddMMyyyy-');
                  String orderid = widget.user.getEmail() +
                      "-topup-" +
                      formatter.format(now) +
                      "-" +
                      randomAlphaNumeric(10);
                  await Navigator.push(
                    context,
                    ScaleRoute(
                      page: TopupCredit(
                          user: widget.user,
                          orderid: orderid,
                          option: "topupcredit"),
                    ),
                  );
                  _getNewCredit();
                } else {
                  methods.showUnregisteredDialog(context);
                }
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
        );
      },
    );
  }

  void _makePayment() {
    if (paymentDue == "0.00") {
      methods.showMessage("Payment Clear", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.orange[300], Colors.white, 16.0);
    } else {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              title: methods.textOnly("Make Payment?", "Oxanium Regular", 25.0,
                  Colors.deepOrange[400], null, null),
              content: Container(
                height: screenHeight / 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      methods.textOnly("Wish to make payment?",
                          "Oxanium Regular", 20.0, null, null, null),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Checkbox(
                              value: _isChecked,
                              activeColor: Colors.orange,
                              onChanged: (bool value) {
                                double _credit =
                                    double.parse(widget.user.getCredit());
                                double _paymentDue = double.parse(paymentDue);
                                if (_paymentDue > _credit) {
                                  methods.showMessage(
                                      "Insufficient credit! Please reload credit or make payment online.",
                                      Toast.LENGTH_LONG,
                                      ToastGravity.CENTER,
                                      Colors.orange[900],
                                      Colors.white,
                                      16.0);
                                } else {
                                  newSetState(() {
                                    _isChecked = value;
                                  });
                                }
                              },
                            ),
                            methods.textOnly("Pay with credit?",
                                "Oxanium Regular", null, null, null, null),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: methods.textOnly("No", "Oxanium Regular", 18.0,
                      Colors.orange, FontWeight.bold, null),
                  onPressed: () {
                    setState(() {
                      _isChecked = false;
                    });
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
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (widget.user.getEmail() != 'Unregistered') {
                      if (_isChecked) {
                        http.post(urlPayWithCredit, body: {
                          'email': widget.user.getEmail(),
                          'amount': paymentDue,
                        }).then((res) {
                          if (res.body == "success") {
                            methods.showMessage(
                                "Payment successful",
                                Toast.LENGTH_SHORT,
                                ToastGravity.CENTER,
                                Colors.orange[300],
                                Colors.white,
                                16.0);
                            _getNewCredit();
                            _getPaymentDue();
                          } else {
                            methods.showMessage(
                                "Payment failed, please contact admin!",
                                Toast.LENGTH_SHORT,
                                ToastGravity.CENTER,
                                Colors.orange[900],
                                Colors.white,
                                16.0);
                          }
                        });
                      } else {
                        var now = new DateTime.now();
                        var formatter = new DateFormat('ddMMyyyy');
                        String orderid = widget.user.getEmail() +
                            "-payment-" +
                            formatter.format(now) +
                            "-" +
                            randomAlphaNumeric(10);
                        await Navigator.push(
                          context,
                          ScaleRoute(
                            page: MakePayment(
                              user: widget.user,
                              amount: paymentDue,
                              orderid: orderid,
                              option: "makepayment",
                            ),
                          ),
                        );
                        _getPaymentDue();
                      }
                    } else {
                      methods.showUnregisteredDialog(context);
                    }
                  },
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
            );
          });
        },
      );
    }
  }

  String _validateName(String value) {
    //start _validateName method
    if (value.length < 3) {
      _informationValidate = false;
      return 'Name must be more than 2 charater';
    } else {
      _informationValidate = true;
      return null;
    }
  } //end _validateName method

  String _validateEmail(String value) {
    //start _validateEmail method
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[com]{3,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      _informationValidate = false;
      return 'Please enter a valid email';
    } else {
      _informationValidate = true;
      return null;
    }
  } //end _validateEmail method

  String _validatePhone(String value) {
    //start _validatePhone method
    if (value.length < 10) {
      _informationValidate = false;
      return 'Phone number must be only 10/11 digits';
    } else {
      _informationValidate = true;
      return null;
    }
  } //end _validatePhone method

  void _showDialog(
      String leading,
      String content,
      String hintText,
      String Function(String) validate,
      Icon icon,
      TextInputType textInputType,
      List<TextInputFormatter> inputFormatters) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.orange[600],
            cursorColor: Colors.deepOrange,
          ),
          child: AlertDialog(
            title: methods.textOnly(leading, "Oxanium Regular", 25.0,
                Colors.deepOrange[400], null, null),
            content: Form(
              key: _userThirdPageKey,
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                keyboardType: textInputType,
                inputFormatters: inputFormatters,
                controller: controller,
                validator: validate,
                decoration: InputDecoration(
                  prefixIcon: icon,
                  labelText: hintText,
                  labelStyle: TextStyle(
                    fontFamily: "Oxanium Regular",
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
                  String email = widget.user.getEmail();
                  String editContent = controller.text;
                  if (leading == "Edit Name?" &&
                      editContent.isNotEmpty &&
                      _informationValidate == true) {
                    http.post(urlEditProfile, body: {
                      "email": email,
                      "name": editContent,
                    }).then((res) {
                      List userDetails = res.body.split(",");
                      if (userDetails[0] == "success") {
                        setState(() {
                          widget.user.setName(userDetails[1]);
                        });
                        Navigator.of(context).pop();
                        methods.showMessage(
                            "Name updated successfully",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[300],
                            Colors.white,
                            16.0);
                      } else {
                        methods.showMessage(
                            "Please contact admin!",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[900],
                            Colors.white,
                            16.0);
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  } else if (leading == "Edit Email?" &&
                      editContent.isNotEmpty &&
                      _informationValidate == true) {
                    http.post(urlEditProfile, body: {
                      "email": email,
                      "newemail": editContent,
                    }).then((res) {
                      List userDetails = res.body.split(",");
                      if (userDetails[0] == "success") {
                        setState(() {
                          widget.user.setEmail(userDetails[2]);
                        });
                        Navigator.of(context).pop();
                        methods.showMessage(
                            "Email updated successfully, please check your new email to verify your account",
                            Toast.LENGTH_LONG,
                            ToastGravity.CENTER,
                            Colors.orange[300],
                            Colors.white,
                            16.0);
                        Navigator.push(
                          context,
                          ScaleRoute(
                            page: LoginScreen(3),
                          ),
                        );
                      } else {
                        methods.showMessage(
                            "Please contact admin!",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[900],
                            Colors.white,
                            16.0);
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  } else if (leading == "Edit Phone?" &&
                      editContent.isNotEmpty &&
                      _informationValidate == true) {
                    http.post(urlEditProfile, body: {
                      "email": email,
                      "phone": editContent,
                    }).then((res) {
                      List userDetails = res.body.split(",");
                      if (userDetails[0] == "success") {
                        setState(() {
                          widget.user.setPhone(userDetails[3]);
                        });
                        Navigator.of(context).pop();
                        methods.showMessage(
                            "Phone updated successfully",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[300],
                            Colors.white,
                            16.0);
                      } else {
                        methods.showMessage(
                            "Please contact admin!",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[900],
                            Colors.white,
                            16.0);
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  } else {
                    methods.showMessage(
                        "Please fill in the blank or amend the error!",
                        Toast.LENGTH_SHORT,
                        ToastGravity.CENTER,
                        Colors.orange[900],
                        Colors.white,
                        16.0);
                  }
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
      },
    );
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      if (widget.user.getAddress() == "" &&
          widget.user.getLatitude() == null &&
          widget.user.getLongitude() == null) {
        _updateAddress(curaddress);
        _updateLatLong(_currentPosition.latitude, _currentPosition.longitude);
      } else {
        curaddress = widget.user.getAddress();
        latitude = widget.user.getLatitude();
        longitude = widget.user.getLongitude();
      }
    });
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      _updateAddress(curaddress);
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      _updateAddress(curaddress);
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
  }

  _loadMapDialog() {
    latitude = widget.user.getLatitude();
    longitude = widget.user.getLongitude();
    try {
      if (_currentPosition.latitude == null) {
        methods.showMessage(
            "Location not available. Please wait...",
            Toast.LENGTH_LONG,
            ToastGravity.CENTER,
            Colors.orange[900],
            Colors.white,
            16.0);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Delivery Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                title: methods.textOnly(
                    "Select New Delivery Location",
                    "Oxanium Regular",
                    20.0,
                    Colors.orange,
                    FontWeight.bold,
                    null),
                titlePadding: EdgeInsets.all(5),
                actions: <Widget>[
                  methods.textOnly(
                      curaddress, "Oxanium Regular", 15.0, null, null, null),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('Close'),
                    color: Colors.orange[500],
                    textColor: Colors.white,
                    elevation: 10,
                    onPressed: () {
                      markers.clear();
                      setState(() {
                        curaddress = widget.user.getAddress();
                        latitude = widget.user.getLatitude();
                        longitude = widget.user.getLongitude();
                      });
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Delivery Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
    _updateLatLong(latitude, longitude);
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }

  void _updateLatLong(double lat, double long) {
    http.post(urlUpdateAddress, body: {
      "email": widget.user.getEmail(),
      "latitude": lat.toString(),
      "longitude": long.toString(),
    }).then((res) {
      if (res.body == "success") {
        setState(() {
          widget.user.setLatitude(lat);
          widget.user.setLongitude(long);
        });
      } else {
        methods.showMessage(
            "Update failed, please try again or contact admin",
            Toast.LENGTH_LONG,
            ToastGravity.CENTER,
            Colors.orange[900],
            Colors.white,
            16.0);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _updateAddress(String address) {
    http.post(urlUpdateAddress, body: {
      "email": widget.user.getEmail(),
      "address": address,
    }).then((res) {
      if (res.body == "success") {
        setState(() {
          widget.user.setAddress(curaddress);
        });
      } else {
        methods.showMessage(
            "Update failed, please try again or contact admin",
            Toast.LENGTH_LONG,
            ToastGravity.CENTER,
            Colors.orange[900],
            Colors.white,
            16.0);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _changeProfilePic() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                child: ListTile(
                  title: Center(
                    child: methods.textOnly("Select from gallery",
                        "Oxanium Regular", 20.0, null, null, null),
                  ),
                  onTap: () => _getImage(false),
                ),
              ),
              InkWell(
                child: ListTile(
                  title: Center(
                    child: methods.textOnly("Take photo", "Oxanium Regular",
                        20.0, null, null, null),
                  ),
                  onTap: () => _getImage(true),
                ),
              ),
            ],
          );
        });
  }

  void _getImage(bool isCamera) async {
    if (widget.user.getEmail() != 'Unregistered') {
      setState(() {
        _isCropping = true;
      });
      if (isCamera) {
        _image = (await ImagePicker().getImage(
            source: ImageSource.camera,
            maxHeight: 500.0,
            maxWidth: 500.0)) as File;
      } else {
        _image = (await ImagePicker().getImage(
            source: ImageSource.gallery,
            maxHeight: 500.0,
            maxWidth: 500.0)) as File;
      }
      if (_image == null) {
        setState(() {
          _isCropping = false;
        });
        return;
      } else {
        File _croppedFile = await ImageCropper.cropImage(
          sourcePath: _image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          maxHeight: 500,
          maxWidth: 500,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Image Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
        );
        if (_croppedFile == null) {
          setState(() {
            _isCropping = false;
          });
          return;
        } else {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
            _image = _croppedFile;
          });

          String base64Image = base64Encode(_image.readAsBytesSync());
          http.post(urlUpdateProfilePic, body: {
            "email": widget.user.getEmail(),
            "encoded_string": base64Image,
          }).then((res) {
            print(res.body);
            if (res.body == "success") {
              setState(() {
                _isCropping = false;
                Navigator.pop(context);
              });
            } else {
              methods.showMessage(
                  "Upload failed, please try again or contact admin",
                  Toast.LENGTH_LONG,
                  ToastGravity.CENTER,
                  Colors.orange[900],
                  Colors.white,
                  16.0);
              setState(() {
                _isCropping = false;
              });
            }
          }).catchError((err) {
            print(err);
          });
        }
      }
    } else {
      methods.showUnregisteredDialog(context);
    }
  }

  void _getPaymentDue() async {
    await http.post(urlPaymentDue, body: {
      "email": widget.user.getEmail(),
    }).then((res) {
      if (res.body != "no data") {
        setState(() {
          paymentDue = "${res.body}.00";
        });
      } else {
        setState(() {
          paymentDue = "0.00";
        });
      }
    });
  }

  void _getNewCredit() {
    http.post(urlGetNewCredit, body: {
      "email": widget.user.getEmail(),
    }).then((res) {
      if (res.body != "no data") {
        setState(() {
          widget.user.setCredit(res.body);
        });
      }
    });
  }
}
