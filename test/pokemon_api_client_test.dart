import 'package:dio/dio.dart';
import 'package:flutter_api_mock_test/view_model/provider.dart';
import 'package:flutter_api_mock_test/model/pokemon.dart';
import 'package:flutter_api_mock_test/service/pokemon_api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('repository test', () {
    late ProviderContainer container;
    late DioAdapter dioAdapter;
    late PokemonApiClient apiClient;

    setUp(() async {
      final dio = Dio(BaseOptions(
        validateStatus: (status) => true,
      ));

      dioAdapter = DioAdapter(dio: dio);

      const path ='https://pokeapi.co/api/v2/pokemon/';

      dioAdapter.onGet(
        path,
            (server) => server.reply(
          200,
          {'message': 'Success!'},
        ),
      );

      final response = await dio.get(path);

      // PokemonApiClientの初期化に必要な引数を用意する
      final httpClient = dioAdapter;
      final baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

      // PokemonApiClientを初期化する
      apiClient = PokemonApiClient();

      container = ProviderContainer(
        overrides: [
          pokemonApiClientProvider.overrideWithValue(apiClient),
        ],
      );
    });
    test('fetchList 正常系', () async {
      final expectedList = [
        const Pokemon(
          id: 1,
          name: 'bulbasaur', // 修正
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        ),
        const Pokemon(
          id: 2,
          name: 'ivysaur', // 修正
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
        ),
        const Pokemon(
          id: 3,
          name: 'venusaur', // 修正
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
        ),
      ];

      // HttpMockAdapter を使用して API のレスポンスをモック
      dioAdapter.onGet(
        'https://pokeapi.co/api/v2/pokemon?limit=151',
            (server) => server.reply(200, [
          {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'}, // 修正
          {'name': 'ivysaur', 'url': 'https://pokeapi.co/api/v2/pokemon/2/'}, // 修正
          {'name': 'venusaur', 'url': 'https://pokeapi.co/api/v2/pokemon/3/'}, // 修正
        ]),
      );

      final result = await container.read(listProvider.future);

      expect(result, equals(expectedList));
    });


    test(
      'fetchList 異常系 APIからエラーが返ってきた場合、例外がスローされる。',
          () async {
        // HttpMockAdapter を使用してエラーをシミュレート
        dioAdapter.onGet(
          'https://pokeapi.co/api/v2/pokemon?limit=151',
              (server) =>
              server.reply(500, {'message': 'Internal Server Error'}),
        );

        expect(
              () => container.read(listProvider.future),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}