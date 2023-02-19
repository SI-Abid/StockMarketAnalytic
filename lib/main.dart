import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final collections = [
    'StockData',
    'Top10Gainer',
    'Top10Looser',
    'TopGainer',
    'TopLooser',
    'News'
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF126172,
          <int, Color>{
            50: Color(0xFF126172),
            100: Color(0xFF126172),
            200: Color(0xFF126172),
            300: Color(0xFF126172),
            400: Color(0xFF126172),
            500: Color(0xFF126172),
            600: Color(0xFF126172),
            700: Color(0xFF126172),
            800: Color(0xFF126172),
            900: Color(0xFF126172),
          },
        )
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stock Market Api'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Center(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: collections.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10),
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF126172),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StockPage(
                            collection: collections[index],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      collections[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<List> getStock(String collection) async {
  Uri url =
      Uri.https('ApiFetchFromFlutter.muhammadbadrul1.repl.co', '/$collection');
  // print(url);
  return get(url, headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  }).then((value) {
    final data = jsonDecode(value.body);
    return data;
  });
}

class StockPage extends StatefulWidget {
  const StockPage({Key? key, required this.collection}) : super(key: key);
  final String collection;

  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  late Future<List> _futureResponse;
  late List keys;
  @override
  void initState() {
    super.initState();
    _futureResponse = getStock(widget.collection).then((value) {
      keys = value[0].keys.toList();
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collection),
        centerTitle: true,
      ),
      body: FutureBuilder<List>(
        future: _futureResponse,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        for (var i = 0; i < keys.length; i++)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                                height: 75,
                                width: snapshot.data![index][keys[i]].length *
                                    10.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child:
                                    SingleChildScrollView(child: Text('${snapshot.data![index][keys[i]]}'))),
                          )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
