enum PokemonStats { hp, attack, defense, specialAttack, specialDefense, speed }

extension PokemonStatsNamed on PokemonStats {
  String get name {
    switch (this) {
      case PokemonStats.hp:
        return "Hp";
      case PokemonStats.attack:
        return "Att";
      case PokemonStats.defense:
        return "Def";
      case PokemonStats.specialAttack:
        return "S-Att";
      case PokemonStats.specialDefense:
        return "S-Def";
      case PokemonStats.speed:
        return "Spe";
    }
  }
}
