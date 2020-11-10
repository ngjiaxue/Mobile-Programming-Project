import 'user.dart';
import 'dart:convert';
import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(UserFirstPage());

class UserFirstPage extends StatefulWidget {
  final User user;
  final VoidCallback callback1;
  final Function(String) func1;
  UserFirstPage({this.callback1, this.func1, this.user});
  @override
  State<StatefulWidget> createState() {
    return _UserFirstPageState(callback2: () {
      callback1();
    }, func2: (string) {
      func1(string);
    });
  }
}

class _UserFirstPageState extends State<UserFirstPage>
    with AutomaticKeepAliveClientMixin<UserFirstPage> {
  VoidCallback callback2;
  Function(String) func2;
  _UserFirstPageState({this.callback2, this.func2});
  Methods methods = new Methods();
  FocusNode focusNode = new FocusNode();
  List parcelDetails;
  TextEditingController _searchController = new TextEditingController();
  int _i = 0;
  String _statusSelected = "Pending";
  String urlAddParcel =
      "https://parceldaddy2020.000webhostapp.com/php/addparcel.php";
  String urlLoadParcel =
      "https://parceldaddy2020.000webhostapp.com/php/loadparcel.php";
  String urlEditParcel =
      "https://parceldaddy2020.000webhostapp.com/php/editparcel.php";
  String urlDeleteParcel =
      "https://parceldaddy2020.000webhostapp.com/php/deleteparcel.php";
  double screenHeight, screenWidth;
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
                  hintText: "Search...",
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
                  if (widget.user.getEmail() != 'Unregistered') {
                    setState(() {
                      this._isSearching = !this._isSearching;
                      _searchController.clear();
                      if (this._isSearching == false) {
                        _loadParcel();
                      }
                    });
                  } else {
                    methods.showUnregisteredDialog(context);
                  }
                }),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  top: 5.0,
                  left: 5.0,
                  right: 5.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    "assets/images/cover1.gif",
                    height: screenHeight / 4.5,
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 1.0,
                  left: 10.0,
                  right: 10.0,
                ),
                child: methods.divider(), //call _divider method
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    methods.statusButton("Pending", _changeColor,
                        _pendingPressed), //call statusButton method (when Pending status selected)
                    methods.statusButton("Delivering", _changeColor1,
                        _deliveringPressed), //call statusButton method (when Delivering status selected)
                    methods.statusButton("Delivered", _changeColor2,
                        _deliveredPressed), //call statusButton method (when Delivered status selected)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: methods.divider(), //call _divider method
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    _testParcelRecord(_i), //call _testParcelRecord method
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          elevation: 8.0,
                          backgroundColor: Colors.orange[600],
                          onPressed: () {
                            if (widget.user.getEmail() != 'Unregistered') {
                              if (widget.user.getAddress() != "") {
                                _addParcel();
                              } else {
                                methods.showMessage(
                                    "Please add a new address before you add a new parcel",
                                    Toast.LENGTH_SHORT,
                                    ToastGravity.CENTER,
                                    Colors.deepOrange,
                                    Colors.white,
                                    16.0);
                              }
                            } else {
                              methods.showUnregisteredDialog(context);
                            }
                          }, //call _addParcel method
                          child: Ink(
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
                                borderRadius: BorderRadius.circular(80.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 300.0, minHeight: 35.0),
                              alignment: Alignment.center,
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
    if (widget.user.getEmail() != 'Unregistered') {
      http.post(urlLoadParcel, body: {
        "email": widget.user.getEmail(),
        "status": _statusSelected,
        "trackingno": search,
      }).then((res) {
        setState(() {
          if (res.body != "no data") {
            var extractdata = json.decode(res.body);
            parcelDetails = extractdata["parcel"];
          } else {
            parcelDetails = null;
          }
        });
      });
    } else {
      methods.showUnregisteredDialog(context);
    }
  }

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

  Future<void> _loadParcel() async {
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
    if (_i > 0) {
      await pr.show();
    }
    String email = widget.user.getEmail();
    String status = _statusSelected;
    http.post(urlLoadParcel, body: {
      //get data from database
      "email": email,
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
          _i = 2;
          parcelDetails = null;
        });
        await pr.hide();
      }
      await pr.hide();
    });
  } //end _loadParcel method

  _testParcelRecord(int i) {
    //start _testParcelRecord method
    _i++;
    if (parcelDetails != null) {
      return ListView.builder(
          itemCount: parcelDetails == null ? 1 : parcelDetails.length,
          itemBuilder: (context, index) {
            return _parcelDetails(
                parcelDetails[index]['trackingno'],
                parcelDetails[index]['status'],
                parcelDetails[index]['date']); //call parcelStatus method
          });
    } else if (i <= 1) {
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

  _parcelDetails(String trackingno, String status, String date) {
    //start _parcelStatus method
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: screenHeight / 7.5,
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
            onTap: () => _checkStatus(trackingno, status, 1),
            // _checkStatus(trackingno, status, 1),
            onLongPress: () => _checkStatus(
                trackingno, status, 2), //call _checkDeletable method
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
                      "Date: $date", "Oxanium Regular", 16.0, null, null, null),
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

  _checkStatus(String trackingno, String status, int i) {
    //start _checkDeletable method, i = 1 is edit i = 2 is delete
    if (status == "Pending") {
      if (i == 1) {
        return _editParcel(trackingno);
      } else {
        return _deleteParcel(trackingno, status);
      } //call _deleteParcel method}
    } else {
      methods.showMessage(
          "You can't edit \"$status\" parcel",
          Toast.LENGTH_SHORT,
          ToastGravity.CENTER,
          Colors.deepOrange,
          Colors.white,
          16.0);
    }
  } //end _checkDeletable method

  void _editParcel(String oldtrackingno) {
    //start _editParcel method
    TextEditingController _newTrackingNoController =
        new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.orange,
              cursorColor: Colors.deepOrange,
            ),
            child: AlertDialog(
              title: methods.textOnly("Edit Tracking No?", "Oxanium Regular",
                  25.0, Colors.deepOrange[400], FontWeight.w500, null),
              content: new Container(
                child: methods.textField(
                    null,
                    false,
                    _newTrackingNoController,
                    Icon(Icons.text_fields),
                    null,
                    "New Tracking No",
                    "Oxanium Regular",
                    null,
                    null),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: methods.textOnly("Cancel", "Oxanium Regular", 18.0,
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
                  child: methods.textOnly("Done", "Oxanium Regular", 18.0,
                      Colors.white, FontWeight.bold, null),
                  onPressed: () {
                    if (_newTrackingNoController.text.isEmpty) {
                      methods.showMessage(
                          "Please fill in the blank",
                          Toast.LENGTH_SHORT,
                          ToastGravity.CENTER,
                          Colors.red,
                          Colors.white,
                          16.0);
                    } else {
                      String email = widget.user.getEmail();
                      String newtrackingno = _newTrackingNoController.text;
                      http.post(urlEditParcel, body: {
                        //compare parcel to database
                        "oldtrackingno": oldtrackingno,
                        "newtrackingno": newtrackingno,
                        "email": email,
                      }).then((res) {
                        if (res.body == "success") {
                          setState(() {
                            _loadParcel();
                            _testParcelRecord(_i);
                            func2("1");
                          });
                        }
                      });
                      Navigator.of(context).pop();
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
  } //end _editParcel method

  void _deleteParcel(String parceltrackingno, String status) {
    //start _deleteParcel method
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: methods.textOnly("$parceltrackingno", "Oxanium Regular",
                25.0, Colors.deepOrange[400], FontWeight.w500, null),
            content: new Container(
              child: methods.textOnly(
                  "Are you sure to delete the selected tracking no?",
                  "Oxanium Regular",
                  20.0,
                  null,
                  null,
                  null),
            ),
            actions: <Widget>[
              new FlatButton(
                child: methods.textOnly("Yes", "Oxanium Regular", 18.0,
                    Colors.orange, FontWeight.bold, null),
                onPressed: () {
                  String email = widget.user.getEmail();
                  String trackingno = parceltrackingno;
                  http.post(urlDeleteParcel, body: {
                    //compare parcel to database
                    "trackingno": trackingno,
                    "email": email,
                  }).then((res) {
                    if (res.body == "success") {
                      setState(() {
                        _loadParcel();
                        _testParcelRecord(_i);
                        func2("1");
                      });
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                color: Colors.orange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: methods.textOnly("Cancel", "Oxanium Regular", 18.0,
                    Colors.white, FontWeight.bold, null),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          );
        });
  } //end _deleteParcel method

  void _addParcel() {
    //start _addParcel method
    TextEditingController _addParcelController = TextEditingController();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.orange,
            cursorColor: Colors.deepOrange,
          ),
          child: AlertDialog(
            title: methods.textOnly("Add new Parcel?", "Oxanium Regular", 25.0,
                Colors.deepOrange[400], FontWeight.w500, null),
            content: new Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  methods.textOnly("Enter parcel's tracking number",
                      "Oxanium Regular", 16.0, null, null, null),
                  methods.textField(
                      null,
                      false,
                      _addParcelController,
                      Icon(Icons.text_fields),
                      null,
                      "Tracking No",
                      "Oxanium Regular",
                      null,
                      null),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: methods.textOnly("Cancel", "Oxanium Regular", 18.0,
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
                child: methods.textOnly("Add", "Oxanium Regular", 18.0,
                    Colors.white, FontWeight.bold, null),
                onPressed: () {
                  String email = widget.user.getEmail();
                  String trackingno = _addParcelController.text;
                  if (_addParcelController.text.isEmpty) {
                    methods.showMessage(
                        "Please fill in the blank",
                        Toast.LENGTH_SHORT,
                        ToastGravity.CENTER,
                        Colors.red,
                        Colors.white,
                        16.0);
                  } else {
                    http.post(urlAddParcel, body: {
                      //add parcel to database
                      "trackingno": trackingno,
                      "email": email,
                    }).then((res) {
                      if (res.body == "success") {
                        methods.showMessage(
                            "Successfully added",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[400],
                            Colors.white,
                            16.0);
                        Navigator.of(context).pop();
                        setState(() {
                          _loadParcel();
                          _testParcelRecord(_i);
                          func2("1");
                        });
                      } else {
                        methods.showMessage(
                            "Failed to add, please contact admin",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.orange[400],
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
          ),
        );
      },
    );
  } //end _addParcel method

}
