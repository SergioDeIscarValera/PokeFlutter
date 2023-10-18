class PokemonStatsToColor {
  static final Map<String, int> _statToColor = {
    "hp": 0xFFA8A878,
    "att": 0xFFF08030,
    "def": 0xFF6890F0,
    "s-att": 0xFFF8D030,
    "s-def": 0xFF78C850,
    "spe": 0xFF98D8D8,
  };

  static int? getColor(String stat) {
    var formattedStat = stat.toLowerCase();
    var color = _statToColor[formattedStat];
    return color;
  }
}
