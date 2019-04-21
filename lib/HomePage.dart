
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'BankDetailsPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List list;
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
              onPressed: () {
                fetchData();
              },
            )
          ],
        ),
        body: Center(
          child: ListView.builder(
            itemCount: list == null ? 0 : list.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  elevation: 2,
                  child: Container(
                    height: 70,
                    child: Center(
                      child: InkWell(
                        child: Text(
                            list[index]['BankCode'] == null
                                ? '...'
                                : list[index]['BankCode'],
                            style: TextStyle(
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center),
                        onTap: () {
                          //currentBank = list[index]['BankCode'];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BankDetailsPage(currentBank: list[index]['BankCode'])));
                        },
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ));
            },
          ),
        ));
  }
}