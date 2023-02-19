import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: FutureBuilder(
          future: getStock('StockData'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List data = jsonDecode(snapshot.data!.body);
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      // "#": "1", "TRADING CODE": "AAMRANET", "LTP*": "61.5", "HIGH": "64", "LOW": "61.3", "CLOSEP*": "61.5", "YCP*": "63.2", "% CHANGE": "-2.69", "TRADE": "1,386", "VALUE (mn)": "74.1860", "VOLUME": "1,188,658"
                      Expanded(child: Text(data[index]['TRADING CODE'])),
                      Expanded(child: Text(data[index]['LTP*'])),
                      Expanded(child: Text(data[index]['HIGH'])),
                      Expanded(child: Text(data[index]['LOW'])),
                      Expanded(child: Text(data[index]['CLOSEP*'])),
                      Expanded(child: Text(data[index]['YCP*'])),
                      Expanded(child: Text(data[index]['% CHANGE'])),
                      Expanded(child: Text(data[index]['TRADE'])),
                      Expanded(child: Text(data[index]['VALUE (mn)'])),
                      Expanded(child: Text(data[index]['VOLUME'])),
                    ],
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        )),
      ),
    );
  }
}

Future<Response> getStock(String collection) async {
  Uri url =
      Uri.https('ApiFetchFromFlutter.muhammadbadrul1.repl.co', '/$collection');
  // print(url);
  return get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  });
}
