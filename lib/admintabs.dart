import 'user.dart';
import 'methods.dart';
import 'userthirdpage.dart';
import 'adminfirstpage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(AdminTabs());

class AdminTabs extends StatefulWidget {
  final User user;
  const AdminTabs({Key key, this.user}) : super(key: key);
  @override
  _AdminTabsState createState() => _AdminTabsState();
}

class _AdminTabsState extends State<AdminTabs> {
  Methods methods = new Methods();
  bool _greeting = true;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    if (_greeting == true) {
      methods.showMessage(
          "Welcome Admin " + widget.user.getName(),
          Toast.LENGTH_SHORT,
          ToastGravity.CENTER,
          Colors.orange[400],
          Colors.white,
          16.0);
      _greeting = !_greeting;
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        _onSlide(index);
      },
      children: <Widget>[
        AdminFirstPage(user: widget.user),
        UserThirdPage(
          user: widget.user,
          paymentDue: "XX.XX",
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
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onTapped, //call _onTapped method
          currentIndex: _currentTab,
          selectedItemColor: Colors.orange[800],
          unselectedItemColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.blueGrey[50],
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
                  size: 30.0,
                ),
              ),
              icon: new Icon(
                Icons.home,
                size: 30.0,
              ),
              label: methods.textOnly(
                  "Home", "Oxanium Regular", 16.0, null, null, null),
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
                  size: 30.0,
                ),
              ),
              icon: Icon(
                Icons.account_circle,
                size: 30.0,
              ),
              label: methods.textOnly(
                  "Profile", "Oxanium Regular", 16.0, null, null, null),
            ),
          ],
        ),
      ),
    );
  }

  void _onSlide(int value) {
    //start _onSlide method
    setState(() {
      _currentTab = value;
    });
  } //end _onSlide method

  void _onTapped(int value) {
    //start _onTapped method
    setState(() {
      _currentTab = value;
    });
    pageController.animateToPage(value,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  } //end _onTapped method

  Future<bool> _onBackPressed() {
    //start _onBackPressed method
    return methods.backPressed(context);
  } //end _onBackPressed method
}
