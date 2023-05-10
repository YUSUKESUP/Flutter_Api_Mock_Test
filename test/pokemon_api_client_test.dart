import 'package:dio/dio.dart';
import 'package:flutter_api_mock_test/view_model/provider.dart';
import 'package:flutter_api_mock_test/model/pokemon.dart';
import 'package:flutter_api_mock_test/service/pokemon_api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  group('Repository test', () {
    late ProviderContainer container;
    late DioAdapter dioAdapter;
    late PokemonApiClient apiClient;

    setUp(() {
      // テスト用の Dio をインスタンス化
      final dio = Dio(BaseOptions(
        validateStatus: (status) => true,
      ));

      // HttpMockAdapter を使用して API リクエストをモック
      dioAdapter = DioAdapter(dio: Dio());


      apiClient = PokemonApiClient();

      container = ProviderContainer(
        overrides: [
          pokemonApiClientProvider.overrideWithValue(apiClient),
        ],
      );
    });

    test('fetchList 正常系', () async {
      final expectedList = [
        Pokemon(
          id: 1,
          name: 'Bulbasaur',
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        ),
        Pokemon(
          id: 2,
          name: 'Ivysaur',
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png',
        ),
        Pokemon(
          id: 3,
          name: 'Venusaur',
          imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/3.png',
        ),
      ];

      // HttpMockAdapter を使用して API のレスポンスをモック
      dioAdapter.onGet(
        'https://pokeapi.co/api/v2/pokemon?limit=151',
            (server) => server.reply(200, [
          {'name': 'Bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
          {'name': 'Ivysaur', 'url': 'https://pokeapi.co/api/v2/pokemon/2/'},
          {'name': 'Venusaur', 'url': 'https://pokeapi.co/api/v2/pokemon/3/'},
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
