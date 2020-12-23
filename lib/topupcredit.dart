import 'user.dart';
import 'dart:async';
import 'methods.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(TopupCredit());

class TopupCredit extends StatefulWidget {
  final User user;
  final String orderid, option;
  TopupCredit({Key key, this.user, this.orderid, this.option})
      : super(key: key);

  @override
  _TopupCreditState createState() => _TopupCreditState();
}

class _TopupCreditState extends State<TopupCredit> {
  Methods methods = new Methods();
  ImageProvider _image;
  List<bool> _list = [false, false, false];
  Completer<WebViewController> _controller = Completer<WebViewController>();
  TextEditingController _amountController = new TextEditingController();
  String _amount;
  @override
  void initState() {
    super.initState();
    _image = AssetImage("assets/images/coin.jpg");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(_image, context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.deepOrange[50],
        appBar: AppBar(
          backgroundColor: Colors.orange[800],
          title: methods.textOnly(
              "Topup Credit", "Pacifico Regular", 30.0, null, null, null),
          flexibleSpace: methods.appBarColor(),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _image,
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.transparent.withOpacity(0.3), BlendMode.dstATop),
            ),
          ),
          child: _selectAmount(),
        ),
      ),
    );
  }

  _selectAmount() {
    if (_amount != null) {
      return Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              initialUrl:
                  'https://parceldaddy2020.000webhostapp.com/php/payment.php?email=' +
                      widget.user.getEmail() +
                      '&mobile=' +
                      widget.user.getPhone() +
                      '&name=' +
                      widget.user.getName() +
                      '&amount=' +
                      _amount.toString() +
                      '.00' +
                      '&orderid=' +
                      widget.orderid +
                      '&option=' +
                      widget.option,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          )
        ],
      );
    } else {
      return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Colors.deepOrange,
          cursorColor: Colors.deepOrange,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _amountController,
                    style: TextStyle(
                      fontFamily: "Oxanium Regular",
                      fontSize: 25.0,
                      color: Colors.deepOrange,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white60,
                      prefixText: "RM ",
                      prefixStyle: TextStyle(
                        fontFamily: "Oxanium Regular",
                        fontSize: 25.0,
                        color: Colors.deepOrange,
                      ),
                      labelText: "Topup Credit",
                      labelStyle: TextStyle(
                        fontFamily: "Oxanium Regular",
                        fontSize: 18.0,
                        color: _amountController.text.isNotEmpty
                            ? Colors.deepOrange[600]
                            : null,
                      ),
                      enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(
                          color: _amountController.text.isNotEmpty
                              ? Colors.deepOrange
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        color: _list[0] ? Colors.orange[100] : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        child: methods.textOnly(
                            "RM 10", "Oxanium Regular", 18.0, null, null, null),
                        onPressed: () {
                          setState(() {
                            _list[0] = true;
                            _list[1] = false;
                            _list[2] = false;
                            _amountController.text = "10";
                          });
                        },
                      ),
                      RaisedButton(
                        color: _list[1] ? Colors.orange[100] : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        child: methods.textOnly(
                            "RM 50", "Oxanium Regular", 18.0, null, null, null),
                        onPressed: () {
                          setState(() {
                            _list[1] = true;
                            _list[0] = false;
                            _list[2] = false;
                            _amountController.text = "50";
                          });
                        },
                      ),
                      RaisedButton(
                        color: _list[2] ? Colors.orange[100] : Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        child: methods.textOnly("RM 100", "Oxanium Regular",
                            18.0, null, null, null),
                        onPressed: () {
                          setState(() {
                            _list[2] = true;
                            _list[0] = false;
                            _list[1] = false;
                            _amountController.text = "100";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                    splashColor: Colors.orange[800],
                    onPressed: () {
                      if (_amountController.text.isEmpty) {
                        methods.showMessage(
                            "Please fill in the amount",
                            Toast.LENGTH_SHORT,
                            ToastGravity.CENTER,
                            Colors.red,
                            Colors.white,
                            16.0);
                      } else {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _amount = _amountController.text;
                        });
                      }
                    },
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange[200],
                              Colors.orange,
                              Colors.orange[700],
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: 300.0, minHeight: 40.0),
                        alignment: Alignment.center,
                        child: methods.textOnly("Topup Credit",
                            "Oxanium Regular", 20.0, Colors.white, null, null),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
