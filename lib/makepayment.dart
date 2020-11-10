import 'user.dart';
import 'dart:async';
import 'methods.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MakePayment());

class MakePayment extends StatefulWidget {
  final User user;
  final String amount, orderid, option;
  MakePayment({Key key, this.user, this.amount, this.orderid, this.option})
      : super(key: key);

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  Methods methods = new Methods();
  Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[800],
        title: methods.textOnly(
            "Make Payment", "Pacifico Regular", 30.0, null, null, null),
        flexibleSpace: methods.appBarColor(),
      ),
      body: Column(
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
                      widget.amount +
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
      ),
    );
  }
}
