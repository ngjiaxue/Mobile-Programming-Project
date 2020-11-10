import 'user.dart';
import 'dart:convert';
import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(AdminFirstPage());

class AdminFirstPage extends StatefulWidget {
  final User user;
  const AdminFirstPage({Key key, this.user}) : super(key: key);
  @override
  _AdminFirstPageState createState() => _AdminFirstPageState();
}

class _AdminFirstPageState extends State<AdminFirstPage>
    with AutomaticKeepAliveClientMixin<AdminFirstPage> {
  Methods methods = new Methods();
  TextEditingController _searchController = new TextEditingController();
  List parcelDetails;
  List<String> _dropDownStatus = ["Delivering", "Delivered"];
  int _i = 0;
  double screenHeight, screenWidth;
  String _status;
  String _statusSelected = "Pending";
  String urlLoadAllParcel =
      "http://parceldaddy2020.000webhostapp.com/php/loadallparcel.php";
  String urlChangeParcelStatus =
      "https://parceldaddy2020.000webhostapp.com/php/changeparcelstatus.php";
  bool _changeColor = true;
  bool _changeColor1 = false;
  bool _changeColor2 = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadParcel(); //load parcel details recorded in the database
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    SystemChrome.setSystemUIOverlayStyle(
      //make andriod statusbar transparent
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.orange[800],
        title: !_isSearching
            ? methods.textOnly(
                "Home", "Pacifico Regular", 30.0, null, null, null)
            : TextField(
                autofocus: true,
                style: TextStyle(
                  fontFamily: "Oxanium Regular",
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(
                    fontFamily: "Oxanium Regular",
                    fontSize: 20.0,
                    color: Colors.white54,
                  ),
                ),
                onChanged: (_searchController) {
                  setState(() {
                    _searchParcel(_searchController);
                  });
                }),
        flexibleSpace: methods.appBarColor(),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: !_isSearching ? Icon(Icons.search) : Icon(Icons.clear),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    this._isSearching = !this._isSearching;
                    _searchController.clear();
                    if (this._isSearching == false) {
                      _loadParcel();
                    }
                  });
                }),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: methods.divider(), //call _divider method
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  methods.statusButton("Pending", _changeColor,
                      _pendingPressed), //call statusButton method (when Pending status selected)
                  methods.statusButton("Delivering", _changeColor1,
                      _deliveringPressed), //call statusButton method (when Delivering status selected)
                  methods.statusButton("Delivered", _changeColor2,
                      _deliveredPressed), //call statusButton method (when Delivered status selected)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: methods.divider(), //call _divider method
              ),
              Expanded(
                child: _testParcelRecord(_i), //call _testParcelRecord method
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  _searchParcel(String search) {
    http.post(urlLoadAllParcel, body: {
      "status": _statusSelected,
      "trackingnoorname": search,
    }).then((res) {
      setState(() {
        if (res.body != "no data") {
          var extractdata = json.decode(res.body);
          parcelDetails = extractdata["parcel"];
        } else {
          parcelDetails = null;
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> _loadParcel() async {
    //start _loadParcel method
    ProgressDialog pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: "Loading...",
      messageTextStyle: TextStyle(
        fontFamily: "Oxanium Regular",
        fontSize: 19.0,
      ),
    );
    if (_i > 0) {
      await pr.show();
    }
    String status = _statusSelected;
    http.post(urlLoadAllParcel, body: {
      "status": status,
    }).then((res) async {
      if (res.body != "no data") {
        setState(() {
          var extractdata = json.decode(res.body);
          parcelDetails = extractdata["parcel"];
        });
        await pr.hide();
      } else {
        setState(() {
          parcelDetails = null;
        });
        await pr.hide();
      }
      _i = 1;
    }).catchError((err) async {
      print(err);
      await pr.hide();
    });
    await pr.hide();
  } //end _loadParcel method

  void _pendingPressed() {
    //start _pendingPressed method
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _changeColor = true;
        _changeColor1 = false;
        _changeColor2 = false;
        _statusSelected = "Pending";
        _searchParcel(_searchController.text);
      });
    } else {
      setState(() {
        _changeColor = true;
        _changeColor1 = false;
        _changeColor2 = false;
        _statusSelected = "Pending";
        _loadParcel();
      });
    }
  } //end _pendingPressed method

  void _deliveringPressed() {
    //start _deliveringPressed method
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _changeColor = false;
        _changeColor1 = true;
        _changeColor2 = false;
        _statusSelected = "Delivering";
        _searchParcel(_searchController.text);
      });
    } else {
      setState(() {
        _changeColor = false;
        _changeColor1 = true;
        _changeColor2 = false;
        _statusSelected = "Delivering";
        _loadParcel();
      });
    }
  } //end _deliveringPressed method

  void _deliveredPressed() {
    //start _deliveredPressed method
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _changeColor = false;
        _changeColor1 = false;
        _changeColor2 = true;
        _statusSelected = "Delivered";
        _searchParcel(_searchController.text);
      });
    } else {
      setState(() {
        _changeColor = false;
        _changeColor1 = false;
        _changeColor2 = true;
        _statusSelected = "Delivered";
        _loadParcel();
      });
    }
  } //end _deliveredPressed method

  _testParcelRecord(int i) {
    //start _testParcelRecord method
    if (parcelDetails != null) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: parcelDetails == null ? 1 : parcelDetails.length,
          itemBuilder: (context, index) {
            return _parcelDetails(
                parcelDetails[index]['trackingno'],
                parcelDetails[index]['status'],
                parcelDetails[index]['name'],
                parcelDetails[index]['email']); //call parcelStatus method
          });
    } else if (i <= 0) {
      return Align(
        alignment: Alignment.center,
        child: methods.textOnly(
            "", "Oxanium Regular", 20.0, Colors.red, null, null),
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: methods.textOnly("No record found!", "Oxanium Regular", 20.0,
            Colors.red, null, null),
      );
    }
  } //end _testParcelRecord method

  _parcelDetails(String trackingno, String status, String name, String email) {
    //start _parcelStatus method
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: screenHeight / 7,
        width: screenWidth - 10.0,
        child: Card(
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            side: BorderSide(
              color: Colors.black,
            ),
          ),
          child: InkWell(
            onTap: () => _changeStatus(trackingno, status, email),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: methods.textOnly("Tracking No: $trackingno",
                      "Oxanium Regular", 20.0, null, null, null),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: methods.textOnly(
                      "Name: $name", "Oxanium Regular", 20.0, null, null, null),
                ),
                methods.pendingOrDeliveringOrDelivered(
                    status), //call _pendingOrDelivered method
              ],
            ),
          ),
        ),
      ),
    );
  } //end _parcelStatus method

  void _changeStatus(String trackingno, String status, String email) {
    //start _changeStatus method
    if (status == "Pending") {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: methods.textOnly("Change Status?", "Oxanium Regular",
                    25.0, Colors.deepOrange[400], null, null),
                content: DropdownButton<String>(
                  isExpanded: true,
                  value: _status,
                  items: _dropDownStatus
                      .map((value) => DropdownMenuItem(
                            child: methods.textOnly(value, "Oxanium Regular",
                                20.0, null, null, null),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (String value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  hint: methods.textOnly("Select Status", "Oxanium Regular",
                      20.0, null, null, null),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: methods.textOnly("No", "Oxanium Regular", 18.0,
                        Colors.orange, FontWeight.bold, null),
                    onPressed: () {
                      _status = null;
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
                      if (_status == null) {
                        methods.showMessage(
                            "Please select status that wanted to be update",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.red,
                            Colors.white,
                            16.0);
                      } else {
                        http.post(urlChangeParcelStatus, body: {
                          "trackingno": trackingno,
                          "status": _status,
                          "email": email,
                        }).then((res) {
                          if (res.body == "success") {
                            Navigator.of(context).pop();
                            setState(() {
                              _loadParcel();
                              _status = null;
                            });
                          } else {
                            methods.showMessage(
                                "Parcel not found!",
                                Toast.LENGTH_SHORT,
                                ToastGravity.CENTER,
                                Colors.orange[900],
                                Colors.white,
                                16.0);
                          }
                        });
                      }
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
        },
      );
    } else if (status == "Delivering") {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                title: methods.textOnly("Change Status?", "Oxanium Regular",
                    25.0, Colors.deepOrange[400], null, null),
                content: new Container(
                  child: methods.textOnly(
                      "Delivered", "Oxanium Regular", 20.0, null, null, null),
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: methods.textOnly("No", "Oxanium Regular", 18.0,
                        Colors.orange, FontWeight.bold, null),
                    onPressed: () {
                      _status = null;
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
                      String statusChanged = "Delivered";
                      http.post(urlChangeParcelStatus, body: {
                        "trackingno": trackingno,
                        "status": statusChanged,
                        "email": email,
                      }).then((res) {
                        if (res.body == "success") {
                          Navigator.of(context).pop();
                          setState(() {
                            _loadParcel();
                            _status = null;
                          });
                        } else {
                          methods.showMessage(
                              "Parcel not found!",
                              Toast.LENGTH_SHORT,
                              ToastGravity.CENTER,
                              Colors.orange[900],
                              Colors.white,
                              16.0);
                        }
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      methods.showMessage("Parcel already delivered!", Toast.LENGTH_SHORT,
          ToastGravity.CENTER, Colors.orange[900], Colors.white, 16.0);
    }
  } //end _changeStatus method
}
