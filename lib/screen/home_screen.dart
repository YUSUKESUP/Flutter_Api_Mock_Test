import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/pokemon.dart';
import '../view_model/provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final asyncValue = ref.watch(listProvider); // 取得したAPIデータの監視

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon List'),
      ),
      body: Center(
        child: asyncValue.when(
          data: (List<Pokemon> data) {
            if (data.isNotEmpty) {
              return GridView.builder(
                itemCount: data.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, int index) {
                  final pokemonData = data[index];
                  return SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: pokemonData.imageUrl,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                        Text(
                          '#${pokemonData.id} ${pokemonData.name}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Text('Data is empty.');
            }
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text(error.toString()),
        ),
      ),
    );
  }
}
