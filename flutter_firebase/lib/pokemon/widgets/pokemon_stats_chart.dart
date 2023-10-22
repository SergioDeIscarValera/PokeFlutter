import 'package:PokeFlutter/pokemon/models/pokemon_stats.dart';
import 'package:PokeFlutter/pokemon/utils/pokemon_stat_to_color.dart';
import 'package:PokeFlutter/pokemon/widgets/barchart_axieTitle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PokemonStatsChart extends StatelessWidget {
  static int count = 0; // NO INCREMENTA VALUE EN getAxiTitles
  final Map<PokemonStats, int>? stats;
  final double angle;
  final Offset offsetBottom;
  final Offset offsetTop;
  final double height;

  const PokemonStatsChart({
    super.key,
    required this.stats,
    this.angle = 0,
    this.offsetBottom = const Offset(0, 20),
    this.offsetTop = const Offset(0, -10),
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> chartData = stats?.entries.map((entry) {
          final PokemonStats statName = entry.key;
          final int statValue = entry.value;

          return BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: statValue.toDouble(),
                width: 20,
                color: PokemonStatsToColor.getColor(statName, Colors.white),
                borderRadius: BorderRadius.circular(4),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: 255,
                  color: Colors.grey[300],
                ),
              ),
            ],
          );
        }).toList() ??
        [];

    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => getAxiTitles(
                  value: value,
                  titles: stats?.values.map((e) => e.toString()).toList() ?? [],
                  meta: meta,
                  angle: angle,
                  offset: offsetTop,
                  setIndex: (newIndex) => count = newIndex,
                  index: count,
                  limit: PokemonStats.values.length,
                  color: (index) => PokemonStatsToColor.getColor(
                      PokemonStats.values[index], Colors.black),
                ),
              ),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => getAxiTitles(
                  value: value,
                  titles: PokemonStats.values
                      .map((e) => PokemonStatsNamed(e).name)
                      .toList(),
                  meta: meta,
                  angle: angle,
                  offset: offsetBottom,
                  setIndex: (newIndex) => count = newIndex,
                  index: count,
                  limit: PokemonStats.values.length,
                  color: (index) => PokemonStatsToColor.getColor(
                      PokemonStats.values[index], Colors.black),
                ),
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: chartData,
          minY: 0,
          maxY: 255,
        ),
      ),
    );
  }
}
