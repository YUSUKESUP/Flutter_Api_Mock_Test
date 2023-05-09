import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Map<String, dynamic>> pokemonDataList;
  late List<String> imageUrls;

  static const maxNumber = 385;

  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://pokeapi.co/api/v2/'));

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'ポケモン',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: GridView.builder(
        itemCount: pokemonDataList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
                Text(
                  '#${pokemonData['id']} ${pokemonData['name']}',
                  style: const TextStyle(fontSize: 16),
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
      try {
        final Response<dynamic> response =
        await _dio.get('pokemon/$index/');
        if (response.statusCode == 200) {
          var jsonResponse = response.data;
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
      } catch (e) {
        throw Exception('Failed to fetch Pokemon data');
      }
    }
  }
}
