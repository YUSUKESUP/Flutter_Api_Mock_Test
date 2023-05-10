import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pokemon.dart';

final pokemonApiClientProvider = Provider<PokemonApiClient>(
      (ref) => PokemonApiClient(),
);


class PokemonApiClient {



  Future<List<Pokemon>?> fetchPokemonData() async {
    final dio = Dio();
    const maxNumber = 898; // ポケモンの最大番号
    final pokemonList = <Pokemon>[]; // 空のリストを用意

    for (int index = 1; index <= maxNumber; index++) {
      try {
        final Response<dynamic> response = await dio.get('https://pokeapi.co/api/v2/pokemon/$index/');
        if (response.statusCode == 200) {
          final jsonResponse = response.data;
          final imageUrl = jsonResponse['sprites']['front_default'];
          final pokemonData = Pokemon.fromJson(jsonResponse);
          pokemonList.add(pokemonData); // リストに追加
        } else {
          throw Exception('Failed to fetch Pokemon data');
        }
      } catch (e) {
        throw Exception('Failed to fetch Pokemon data');
      }
    }
    return pokemonList; // リストを返す
  }
}
