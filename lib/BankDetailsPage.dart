import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class BankDetailsPage extends StatefulWidget {

  final String currentBank;
  BankDetailsPage({this.currentBank});

  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  var data;
  var bank;
  List currencies;
  final String url = 'https://currency-spidey.herokuapp.com/api/info/';
  final String bankUrl = 'https://currency-spidey.herokuapp.com/api/fetch/';

  Future<String> fetchData() async {
    var response = await http.get(Uri.encodeFull(url + widget.currentBank));

    this.setState(() {
      data = json.decode(response.body);
    });
    return "Success!";
  }

  Future<String> fetchCurrencies() async {
    var response = await http.get(Uri.encodeFull(bankUrl + widget.currentBank));

    this.setState(() {
      bank = json.decode(response.body);
      currencies = bank['currencies'];
    });
    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.fetchData();
    this.fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( data == null ? 'Bank Details' : data['fullName']['en']),
      ),
      body: Center(
          child: ListView.builder(
        itemCount: currencies == null ? 0 : currencies.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Container(
                height:60,
            margin: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                
                Container(
                  
                  child: Row(
                    children: <Widget>[
                      Text(
                        currencies[index]['CurrencyID'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Buy rate: ' + currencies[index]['BuyRate'].toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                          'Sell rate: ' +
                              currencies[index]['SellRate'].toString(),
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
               
              ],
              
            ),
          ));
        },
      )),
    );
  }
}