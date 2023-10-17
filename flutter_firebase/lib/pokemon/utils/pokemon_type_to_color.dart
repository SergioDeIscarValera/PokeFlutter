class PokemonTypeToColor {
  static final Map<String, int> _typeToColor = {
    "normal": 0xFFA8A878,
    "fire": 0xFFF08030,
    "water": 0xFF6890F0,
    "electric": 0xFFF8D030,
    "grass": 0xFF78C850,
    "ice": 0xFF98D8D8,
    "fighting": 0xFFC03028,
    "poison": 0xFFA040A0,
    "ground": 0xFFE0C068,
    "flying": 0xFFA890F0,
    "psychic": 0xFFF85888,
    "bug": 0xFFA8B820,
    "rock": 0xFFB8A038,
    "ghost": 0xFF705898,
    "dragon": 0xFF7038F8,
    "dark": 0xFF705848,
    "steel": 0xFFB8B8D0,
    "fairy": 0xFFEE99AC,
  };

  static int? getColor(String type) {
    if (type.isEmpty || type == "null") {
      return null;
    }
    var formattedType = type.toLowerCase().replaceRange(0, 12, "");
    var color = _typeToColor[formattedType];
    return color;
  }
}
