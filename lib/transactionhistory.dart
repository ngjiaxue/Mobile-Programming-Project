import 'user.dart';
import 'methods.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(TransactionHistory());

class TransactionHistory extends StatefulWidget {
  final User user;
  const TransactionHistory({Key key, this.user}) : super(key: key);
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  Methods methods = new Methods();
  int _i = 0;
  double screenHeight, screenWidth;
  List transactionHistory;
  List parcel;
  String _optionSelected = "topupcredit";
  String _text;
  bool _isLoading = true;
  bool _changeColor = true;
  bool _changeColor1 = false;
  String urlLoadTransactionHistory =
      "https://parceldaddy2020.000webhostapp.com/php/transactionhistory.php";
  @override
  void initState() {
    super.initState();
    _loadTransactionHistory(); //load transaction history in the database
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: methods.textOnly(
            "Transaction History", "Pacifico Regular", 30.0, null, null, null),
        flexibleSpace: methods.appBarColor(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Colors.deepOrange),
              ),
            )
          : SafeArea(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 1.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: methods.divider(), //call _divider method
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        methods.statusButton("Topup Credit", _changeColor,
                            _topupCreditPressed), //call statusButton method (when Pending status selected)
                        methods.statusButton("Make Payment", _changeColor1,
                            _makePaymentPressed), //call statusButton method (when Delivered status selected)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: methods.divider(), //call _divider method
                    ),
                    Expanded(
                      child: _testTransactionHistory(_i),
                    ), //call _testTransactionHistory method
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _loadTransactionHistory() async {
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

    http.post(urlLoadTransactionHistory, body: {
      //get data from database
      "email": widget.user.getEmail(),
      "option": _optionSelected,
    }).then((res) async {
      if (res.body != "no data") {
        setState(() {
          var extractdata = json.decode(res.body);
          transactionHistory = extractdata["transactionhistory"];
          _isLoading = false;
        });
        await pr.hide();
      } else {
        setState(() {
          _i = 2;
          transactionHistory = null;
          _isLoading = false;
        });
        await pr.hide();
      }
      await pr.hide();
    });
  }

  void _topupCreditPressed() {
    //start _topupCreditPressed method
    setState(() {
      _changeColor = true;
      _changeColor1 = false;
      _optionSelected = "topupcredit";
    });
    _loadTransactionHistory();
  } //end _topupCreditPressed method

  void _makePaymentPressed() {
    //start _makePaymentPressed method
    setState(() {
      _changeColor = false;
      _changeColor1 = true;
      _optionSelected = "makepayment";
    });
    _loadTransactionHistory();
  } //end _makePaymentPressed method

  _testTransactionHistory(int i) {
    //start _testTransactionHistory method
    _i++;
    if (transactionHistory != null) {
      return Swiper(
        outer: true,
        loop: false,
        viewportFraction: 0.9,
        scale: 0.9,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 6.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              side: BorderSide(
                color: Colors.black,
              ),
            ),
            child: _optionSelected == "makepayment"
                ? InkWell(
                    child: _officialReceipt(index),
                    onTap: () async {
                      print(transactionHistory[index]['date']);
                      await _loadParcelForCurrentReceipt(
                          transactionHistory[index]['date']);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                              builder: (context, newSetState) {
                            return AlertDialog(
                              title: methods.textOnly(
                                  "Payment for Tracking No:",
                                  "Acme Regular",
                                  24.0,
                                  Colors.deepOrange[400],
                                  null,
                                  null),
                              content: SingleChildScrollView(
                                child: methods.textOnly(_text, "Acme Regular",
                                    20.0, null, null, null),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  color: Colors.orange[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: methods.textOnly(
                                      "Close",
                                      "Acme Regular",
                                      18.0,
                                      Colors.white,
                                      FontWeight.bold,
                                      null),
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
                        },
                      );
                    },
                  )
                : _officialReceipt(index),
          );
        },
        itemCount: transactionHistory.length,
        pagination: new SwiperPagination(
          builder:
              new DotSwiperPaginationBuilder(activeColor: Colors.deepOrange),
        ),
      );
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
  } //end _testTransactionHistory method

  _officialReceipt(int index) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Text(
            "Official Receipt",
            style: TextStyle(
              color: Colors.deepOrange[300],
              fontFamily: "Pacifico Regular",
              fontSize: 36.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.asset("assets/images/chop.png", scale: 7),
          ),
          RichText(
            //app name start
            text: TextSpan(
              text: "Parcel",
              style: TextStyle(
                color: Colors.brown[500],
                fontFamily: "Pacifico Regular",
                fontSize: 30.0,
                letterSpacing: 1.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: " Daddy",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Pacifico Regular",
                    fontSize: 30.0,
                    letterSpacing: 1.0,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: methods.divider(),
          ),
          SizedBox(
            height: 10.0,
          ),
          _receiptDetails("Date Issued", transactionHistory[index]['date']),
          SizedBox(
            height: 15.0,
          ),
          _receiptDetails("Order ID", transactionHistory[index]['orderid']),
          SizedBox(
            height: 15.0,
          ),
          _receiptDetails("Billplz ID", transactionHistory[index]['billplzid']),
          SizedBox(
            height: 15.0,
          ),
          _receiptDetails(
              "Amount", "RM ${transactionHistory[index]['amount']}"),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }

  _loadParcelForCurrentReceipt(String date) async {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date);
    DateFormat dateFormat1 = DateFormat("yyyy-MM-dd HH:mm:ss");
    String formmatedDate = dateFormat1.format(dateTime);
    await http.post(urlLoadTransactionHistory, body: {
      'email': widget.user.getEmail(),
      'date': formmatedDate,
    }).then((res) {
      if (res.body != "no data") {
        setState(() {
          parcel = res.body.split(",");
          _text = parcel[0];
          for (int _i = 1; _i < parcel.length - 1; _i++) {
            _text = "$_text\n${parcel[_i]}";
          }
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _receiptDetails(String head, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        width: screenWidth - 100.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
        ),
        child: Column(
          children: <Widget>[
            Text(
              head,
              style: TextStyle(
                fontFamily: "Acme Regular",
                fontSize: 26.0,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: "Acme Regular",
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
