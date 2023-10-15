class PokemonStatsToColor{
  static final Map<String, int> _statToColor = {
    "hp": 0xFFA8A878,
    "attack": 0xFFF08030,
    "defense": 0xFF6890F0,
    "special-attack": 0xFFF8D030,
    "special-defense": 0xFF78C850,
    "speed": 0xFF98D8D8,
  };

  static int? getColor(String stat){
    var formattedStat = stat.toLowerCase();
    var color = _statToColor[formattedStat];
    return color;
  }
}