import '../service/pokemon_api_client.dart';

class Repository {
  final api = PokemonApiClient();
  dynamic fetchList() async {
    return await api.fetchPokemonData();
  }
}