import 'tabs.dart';
import 'user.dart';
import 'methods.dart';
import 'admintabs.dart';
import 'loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = new User("Unregistered", "Unregistered", "Unregistered",
      "Unregistered", null, null, "Unregistered");
  Methods methods = new Methods();
  ImageProvider _image;
  Image _image1;
  String _email, _password;
  int loggedIn =
      0; //0 navigate to LoginScreen as unregistered user //1 navigate to LoginScreen, 2 navigate to AdminTabs, 3 navigate to UserTabs
  String urlLogin = "http://parceldaddy2020.000webhostapp.com/php/login.php";
  @override
  void initState() {
    super.initState();
    _image = AssetImage("assets/images/splashbg.jpg");
    _image1 = Image.asset(
      "assets/images/profilepic.png",
      scale: 2.5,
    );

    loadpref();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_image, context);
    precacheImage(_image1.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Parcel Daddy",
      home: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _image,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.orange.withOpacity(0.3), BlendMode.dstATop),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(),
                  Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: _image1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ColorizeAnimatedTextKit(
                            isRepeatingAnimation: false,
                            speed: Duration(milliseconds: 280),
                            colors: <Color>[
                              Colors.brown[700],
                              Colors.brown[200],
                              Colors.brown[100],
                              // Colors.brown[700],
                            ],
                            text: <String>["Parcel "],
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              fontFamily: "Pacifico Regular",
                              letterSpacing: 1.0,
                            ),
                          ),
                          RotateAnimatedTextKit(
                            duration: Duration(seconds: 4),
                            isRepeatingAnimation: false,
                            text: ["Daddy"],
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              fontFamily: "Pacifico Regular",
                              letterSpacing: 1.0,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                  ProgressIndicator(
                    loggedIn: loggedIn,
                    user: user,
                  ), // call progress indicator class
                ],
              ),
            ),
          )),
    );
  }

  void loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email') ?? '');
    _password = (prefs.getString('pass') ?? '');
    if (_email.isNotEmpty && _password.isNotEmpty) {
      await http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      }).then((res) {
        List userDetails = res.body.split("&");
        if (userDetails[0] == "success admin") {
          user = new User(userDetails[1], userDetails[2], "ADMIN", "ADMIN",
              null, null, "XX.XX");
          setState(() {
            loggedIn = 2;
          });
        } else if (userDetails[0] == "success") {
          user = new User(
              userDetails[1],
              userDetails[2],
              userDetails[3],
              userDetails[4],
              userDetails[5] == "" ? null : double.parse(userDetails[5]),
              userDetails[6] == "" ? null : double.parse(userDetails[6]),
              userDetails[7]);
          setState(() {
            loggedIn = 3;
          });
        }
      }).catchError((err) {
        print(err);
      });
    } else if (_email.isNotEmpty) {
      setState(() {
        loggedIn = 1;
      });
    }
  }
}

class ProgressIndicator extends StatefulWidget {
  final int loggedIn;
  final User user;
  const ProgressIndicator({Key key, this.loggedIn, this.user})
      : super(key: key);
  //start progress indicator class
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  Methods methods = new Methods();
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          if (animation.value > 0.99) {
            if (widget.loggedIn == 0) {
              Navigator.push(
                context,
                ScaleRoute(
                  page: Tabs(
                    user: widget.user,
                  ),
                ),
              );
            } else if (widget.loggedIn == 1) {
              Navigator.push(
                context,
                ScaleRoute(
                  page: LoginScreen(1),
                ),
              );
            } else if (widget.loggedIn == 2) {
              Navigator.push(
                context,
                ScaleRoute(
                  page: AdminTabs(
                    user: widget.user,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                ScaleRoute(
                  page: Tabs(user: widget.user),
                ),
              );
            }
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Container(
        height: 10.0,
        child: LinearProgressIndicator(
          value: animation.value,
          backgroundColor: Colors.transparent,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
        ),
      ),
    );
  }
} //end progress indicator class
