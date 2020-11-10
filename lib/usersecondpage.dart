import 'user.dart';
import 'methods.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(UserSecondPage());

class UserSecondPage extends StatefulWidget {
  final User user;
  final int notiColor;
  const UserSecondPage({Key key, this.user, this.notiColor}) : super(key: key);
  @override
  _UserSecondPageState createState() => _UserSecondPageState();
}

class _UserSecondPageState extends State<UserSecondPage> {
  Methods methods = new Methods();
  List notification;
  String urlNotification =
      "https://parceldaddy2020.000webhostapp.com/php/notification.php";
  double screenHeight, screenWidth;
  int _i = 0;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool _deleteNoti = false;
  @override
  void initState() {
    super.initState();
    _loadNotification(); //load parcel details recorded in the database
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange[800],
        title: !_isDeleting
            ? methods.textOnly(
                "Notification", "Pacifico Regular", 30.0, null, null, null)
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _deleteNoti = false;
                          _isDeleting = !_isDeleting;
                        });
                      }),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 15.0,
                    ),
                    child: methods.textOnly("Delete Notifications?",
                        "Pacifico Regular", 24.0, null, null, null),
                  ),
                ],
              ),
        flexibleSpace: methods.appBarColor(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: !_isDeleting
                    ? Icon(Icons.delete_sweep)
                    : Icon(Icons.delete),
                color: Colors.white,
                onPressed: () {
                  if (widget.user.getEmail() != 'Unregistered' &&
                      notification != null) {
                    if (!_deleteNoti) {
                      setState(() {
                        _isDeleting = !_isDeleting;
                        _deleteNoti = !_deleteNoti;
                      });
                    } else {
                      _deleteNotification("delete");
                    }
                  } else if (widget.user.getEmail() != 'Unregistered' &&
                      notification == null) {
                    methods.showMessage(
                        "No record found!",
                        Toast.LENGTH_SHORT,
                        ToastGravity.CENTER,
                        Colors.deepOrange,
                        Colors.white,
                        16.0);
                  } else {
                    methods.showUnregisteredDialog(context);
                  }
                }),
          ),
        ],
      ),
      body: _showNotification(),
    );
  }

  Widget _showNotification() {
    if (notification != null && _isLoading) {
      return SafeArea(
        child: ListView.builder(
            itemCount: notification == null ? 1 : notification.length,
            itemBuilder: (context, index) {
              return Container(
                height: screenHeight / 9,
                width: screenWidth - 10.0,
                child: Card(
                  color: (index < widget.notiColor)
                      ? Colors.orange[50]
                      : Colors.white,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    side: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        methods.textOnly(notification[index]['message'],
                            "Oxanium Regular", 18.0, null, null, null),
                        methods.textOnly(notification[index]['date'],
                            "Oxanium Regular", 14.0, null, null, null),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    } else if (_isLoading == false) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        ),
      );
    } else {
      return Center(
        child: _i == 0
            ? methods.textOnly(
                "", "Oxanium Regular", 20.0, Colors.red, null, null)
            : Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    methods.textOnly("No record found!", "Oxanium Regular",
                        20.0, Colors.red, null, null),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: InkWell(
                        child: Text(
                          "Recover notifications?",
                          style: TextStyle(
                            fontFamily: "Oxanium Regular",
                            fontSize: 14.0,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          _deleteNotification("recover");
                        },
                      ),
                    ),
                  ],
                ),
              ),
      );
    }
  }

  void _loadNotification() {
    http.post(urlNotification, body: {
      "email": widget.user.getEmail(),
    }).then((res) {
      if (res.body != "no data") {
        setState(() {
          var extractdata = json.decode(res.body);
          notification = extractdata["notification"];
          _isLoading = true;
        });
      } else {
        setState(() {
          _isLoading = true;
          notification = null;
          _i = 1;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _deleteNotification(String option) async {
    ProgressDialog pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(
      message: "Loading...",
      messageTextStyle: TextStyle(
        fontFamily: "Oxanium Regular",
        fontSize: 19.0,
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.orange,
              cursorColor: Colors.deepOrange,
            ),
            child: AlertDialog(
              title: methods.textOnly(
                  option == "delete"
                      ? "Delete notifications?"
                      : "Recover notifications?",
                  "Oxanium Regular",
                  25.0,
                  Colors.deepOrange[400],
                  FontWeight.w500,
                  null),
              content: new Container(
                child: methods.textOnly(
                    option == "delete"
                        ? "Do you wish to delete all notifications?"
                        : "Do you wish to recover all notifications?",
                    "Oxanium Regular",
                    20.0,
                    null,
                    null,
                    null),
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
                    await pr.show();
                    await http.post(urlNotification, body: {
                      "email": widget.user.getEmail(),
                      "option": option,
                    }).then((res) async {
                      if (res.body == "success") {
                        _loadNotification();
                        setState(() {
                          _isDeleting = false;
                          _deleteNoti = false;
                          _isLoading = true;
                        });
                        await pr.hide();
                        methods.showMessage(
                            option == "delete"
                                ? "Successfully deleted"
                                : "Successfully recovered",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[400],
                            Colors.white,
                            16.0);
                      } else if (res.body == "no record") {
                        methods.showMessage(
                            "No record found! Please contact admin if you believe this is an error",
                            Toast.LENGTH_LONG,
                            ToastGravity.CENTER,
                            Colors.red,
                            Colors.white,
                            16.0);
                      } else {
                        setState(() {
                          _isDeleting = false;
                          _deleteNoti = false;
                          notification = null;
                          _isLoading = true;
                          _i = 1;
                        });
                        await pr.hide();
                      }
                      await pr.hide();
                    }).catchError((err) {
                      print(err);
                    });
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
  }
}
