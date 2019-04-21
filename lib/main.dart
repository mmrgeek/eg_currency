import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

List list;
String currentBank = null;
int i;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EG currency',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'EG currency'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String url = 'https://currency-spidey.herokuapp.com/api/fetch';

  Future<String> fetchData() async {
    var response = await http.get(Uri.encodeFull(url));

    this.setState(() {
      list = json.decode(response.body);
    });
    //print(list[1]["title"]);

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){
                
              },
            )
          ],
        ),
        body: Center(
          child: ListView.builder(
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: InkWell(
                  child: Text( list[index]['BankCode'] == null ? '...' : list[index]['BankCode'],
                      style: TextStyle(fontSize: 20, height: 3),
                      textAlign: TextAlign.center),
                  onTap: () {
                    currentBank = list[index]['BankCode'];
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BankDetailsPage()));
                  },
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              );
            },
          ),
        ));
  }
}

class BankDetailsPage extends StatefulWidget {
  BankDetailsPage({Key key, this.title}) : super(key: key);

  final String title;

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
    var response = await http.get(Uri.encodeFull(url + currentBank));

    this.setState(() {
      data = json.decode(response.body);
    });
    return "Success!";
  }

  Future<String> fetchCurrencies() async {
    var response = await http.get(Uri.encodeFull(bankUrl + currentBank));

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
          title: Text('Bank Details'),
        ),
        body: Center(
          child:ListView.builder (

                itemCount: currencies==null ? 0 : currencies.length,
                itemBuilder: (BuildContext context,int index){
                  return Card (
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Align(
                              alignment: FractionalOffset(0.5, 0),
                              child: Text(currencies[index]['CurrencyID'],style: TextStyle(fontSize: 18, )),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Buy rate: '+currencies[index]['BuyRate'].toString(),textAlign: TextAlign.left,style: TextStyle(fontSize: 16),),
                                Text('Sell rate: '+ currencies[index]['SellRate'].toString(),textAlign: TextAlign.right,style: TextStyle(fontSize: 16)),
                              ],
                            )
                          ],
                        ),
                        height: 60,
                    )
                  );
                },
                
              )
          ),
        );
  }
}
