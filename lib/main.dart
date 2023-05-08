import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

const maxNumber = 385;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'わかりやすい',
        key: ValueKey('myHomePageKey'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Map<String, dynamic>> pokemonDataList;
  late List<String> imageUrls;

  @override
  void initState() {
    pokemonDataList = [];
    imageUrls = [];
    fetchPokemonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GridView.builder(
        itemCount: pokemonDataList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, int index) {
          final pokemonData = pokemonDataList[index];
          return SizedBox(
            height: 120,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Text(
                  '#${pokemonData['id']} ${pokemonData['name']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchPokemonData() async {
    for (int index = 1; index <= maxNumber; index++) {
      final url = 'http://pokeapi.co/api/v2/pokemon/$index/';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        final imageUrl = jsonResponse['sprites']['front_default'];
        final pokemonData = {
          'id': jsonResponse['id'],
          'name': jsonResponse['name'],
        };
        setState(() {
          imageUrls.add(imageUrl);
          pokemonDataList.add(pokemonData);
        });
      } else {
        throw Exception('Failed to fetch Pokemon data');
      }
    }
  }
}
