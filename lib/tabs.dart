import 'user.dart';
import 'methods.dart';
import 'signupscreen.dart';
import 'userfirstpage.dart';
import 'userthirdpage.dart';
import 'usersecondpage.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(Tabs());

class Tabs extends StatefulWidget {
  final User user;
  const Tabs({Key key, this.user}) : super(key: key);
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  Methods methods = new Methods();
  int _currentTab = 0;
  int _notiCount = 0;
  int _profileCount = 0;
  int _profileCount1 = 0;
  int _profileCount2 = 0;
  int _totalProfileCount = 0;
  int _notiColor = 0;
  String paymentDue = "0.00";
  String urlPaymentDue =
      "https://parceldaddy2020.000webhostapp.com/php/paymentdue.php";
  String urlGetNotificationCount =
      "https://parceldaddy2020.000webhostapp.com/php/getnotificationcount.php";
  String urlClearNotificationCount =
      "https://parceldaddy2020.000webhostapp.com/php/clearnotificationcount.php";
  bool _greeting = true;
  bool _showBadge = false;
  bool _showBadge1 = false;

  @override
  void initState() {
    super.initState();
    if (widget.user.getEmail() != "Unregistered") {
      _getAddressStatus();
      _getProfileStatus();
      _getPaymentDue();
      _getNotificationCount();
      if (_greeting == true) {
        methods.showMessage(
            "Welcome " + widget.user.getName(),
            Toast.LENGTH_SHORT,
            ToastGravity.CENTER,
            Colors.orange[400],
            Colors.white,
            16.0);
        _greeting = !_greeting;
      }
    } else {
      _showDialog();
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      onPageChanged: (index) {
        _onTapped(index);
      },
      controller: pageController,
      children: <Widget>[
        UserFirstPage(
          callback1: () {
            if (this.mounted) {
              setState(() {});
            }
          },
          func1: (string) {
            _notiCount++;

            _showBadge = true;
            setState(() {
              _notiColor = _notiCount;
            });
          },
          user: widget.user,
        ),
        UserSecondPage(
          user: widget.user,
          notiColor: _notiColor,
        ),
        UserThirdPage(
          user: widget.user,
          paymentDue: paymentDue,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //to prevent when user misclick back button
      onWillPop: _onBackPressed, //call _onBackPressed method
      child: Scaffold(
        body: buildPageView(),
        bottomNavigationBar: SizedBox(
          height: 70.0,
          child: BottomNavigationBar(
            onTap: _onTapped, //call _onTapped method
            currentIndex: _currentTab,
            selectedItemColor: Colors.orange[800],
            unselectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                activeIcon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.orange[50],
                        Colors.orange[300],
                        Colors.deepOrange[900],
                        Colors.black,
                      ],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.home,
                    size: 35.0,
                  ),
                ),
                icon: new Icon(
                  Icons.home,
                  size: 28.0,
                ),
                title: methods.textOnly("Home", "Oxanium Regular",
                    _currentTab == 0 ? 17.0 : 16.0, null, null, null),
              ),
              BottomNavigationBarItem(
                activeIcon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.orange[50],
                        Colors.orange[300],
                        Colors.orange[900],
                        Colors.black,
                      ],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.notifications,
                    size: 35.0,
                  ),
                ),
                icon: Badge(
                  animationDuration: Duration(milliseconds: 308),
                  animationType: BadgeAnimationType.scale,
                  elevation: 4.0,
                  showBadge: _showBadge,
                  badgeContent: methods.textOnly("$_notiCount",
                      "Oxanium Regular", null, Colors.white, null, null),
                  child: new Icon(
                    Icons.notifications,
                    size: 28.0,
                  ),
                ),
                title: methods.textOnly("Notification", "Oxanium Regular",
                    _currentTab == 1 ? 17.0 : 16.0, null, null, null),
              ),
              BottomNavigationBarItem(
                activeIcon: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.white,
                        Colors.orange[50],
                        Colors.orange[300],
                        Colors.deepOrange[900],
                        Colors.black,
                      ],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: Icon(
                    Icons.account_circle,
                    size: 35.0,
                  ),
                ),
                icon: Badge(
                  animationType: BadgeAnimationType.scale,
                  elevation: 4.0,
                  showBadge: _showBadge1,
                  badgeContent: methods.textOnly("$_totalProfileCount",
                      "Oxanium Regular", null, Colors.white, null, null),
                  child: Icon(
                    Icons.account_circle,
                    size: 28.0,
                  ),
                ),
                title: methods.textOnly("Profile", "Oxanium Regular",
                    _currentTab == 1 ? 17.0 : 16.0, null, null, null),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getAddressStatus() {
    if (widget.user.getAddress() != "") {
      setState(() {
        _profileCount2 = 0;
      });
    } else {
      setState(() {
        _profileCount2 = 1;
      });
    }
  }

  void _getProfileStatus() {
    if (double.parse(widget.user.getCredit()) <= 0.00) {
      setState(() {
        _profileCount = 1;
      });
    } else {
      setState(() {
        _profileCount = 0;
      });
    }
  }

  void _getPaymentDue() {
    http.post(urlPaymentDue, body: {
      "email": widget.user.getEmail(),
    }).then((res) {
      if (res.body != "no data") {
        setState(() {
          _profileCount1 = 1;
          paymentDue = "${res.body}.00";
        });
      } else {
        setState(() {
          _profileCount1 = 0;
          paymentDue = "0.00";
        });
      }
      _totalProfileCount = _profileCount + _profileCount1 + _profileCount2;
      if (_totalProfileCount > 0) {
        _showBadge1 = true;
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _getNotificationCount() {
    String email = widget.user.getEmail();
    http.post(urlGetNotificationCount, body: {
      "email": email,
    }).then((res) {
      if (res.body != "0") {
        setState(() {
          _notiCount = int.parse(res.body.toString());
          _notiColor = _notiCount;
          _showBadge = true;
        });
      } else {
        setState(() {
          _showBadge = false;
          _notiCount = 0;
        });
      }
    });
  }

  void _clearNotificationCount() {
    String email = widget.user.getEmail();
    http.post(urlClearNotificationCount, body: {
      "email": email,
    }).then((res) {
      setState(() {
        _showBadge = false;
        _notiCount = 0;
      });
    });
  }

  void _showDialog() async {
    await Future.delayed(Duration.zero);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "You are logged in as unregistered user, you may not be able to use the functions in this application.",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Oxanium Regular", fontSize: 18.0),
          ),
          actions: <Widget>[
            new FlatButton(
              child: methods.textOnly("Sign Up", "Oxanium Regular", 18.0,
                  Colors.orange, FontWeight.bold, null),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SignUpScreen(),
                  ),
                );
              },
            ),
            new FlatButton(
              child: methods.textOnly("Ok", "Oxanium Regular", 18.0,
                  Colors.orange, FontWeight.bold, null),
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
    );
  }

  _onTapped(int value) {
    //start _onTapped method
    int _oldValue = _currentTab;
    if (_oldValue == 2 && (value == 1 || value == 0)) {
      _getPaymentDue();
      _getProfileStatus();
      _getAddressStatus();
    }
    _getNotificationCount();
    setState(() {
      // _showBadge1 = false;
      _currentTab = value;
    });
    if (_currentTab == 1) {
      _clearNotificationCount();
    } else if (_currentTab == 2) {
      setState(() {
        _showBadge1 = false;
        _profileCount = 0;
        _notiColor = 0;
      });
    } else {
      setState(() {
        _notiColor = 0;
        // _showBadge1 = false;
      });
    }
    if (_oldValue - value == 1 || _oldValue - value == -1) {
      pageController.animateToPage(value,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    } else {
      pageController.jumpToPage(value);
    }
  } //end _onTapped method

  Future<bool> _onBackPressed() {
    //start _onBackPressed method
    return methods.backPressed(context);
  } //end _onBackPressed method
}
