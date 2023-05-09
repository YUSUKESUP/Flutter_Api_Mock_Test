import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon.freezed.dart';


@freezed
class Pokemon with _$Pokemon {
  const factory Pokemon({
    required int id,
    required String name,
    required String imageUrl,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final frontDefault = sprites['front_default'] as String;
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: frontDefault,
    );
  }
}
