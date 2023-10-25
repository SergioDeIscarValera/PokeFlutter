import 'package:PokeFlutter/pokemon/models/pokemon_dto.dart';
import 'package:PokeFlutter/pokemon/services/pokemon_repository.dart';

class TeamDto {
  // id of the team
  String? UUID;

  // email of the owner
  String? owner;

  // name of the team, 15 characters max
  String? name;

  // list of pokemons
  List<PokemonDto>? pokemons;

  // list of emails with their permission (true = read/write, false = read)
  Map<String, bool>? users;

  TeamDto({
    required this.UUID,
    required this.owner,
    required this.name,
    required this.pokemons,
    required this.users,
  });

  TeamDto.fromJson(Map<String, dynamic> json, String email) {
    UUID = json['UUID'].toString();
    owner = email;
    name = json['name'];
    pokemons = (json['pokemons'] as List<dynamic>)
        .map((id) => PokemonRepository().getPokemonFromCacheById(id: id))
        .toList();
    users = Map<String, bool>.from(json['invited']);
  }
}
