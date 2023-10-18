import 'package:PokeFlutter/pokemon/utils/pokemon_stat_to_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class PokemonStatsChart extends StatelessWidget {
  static int count = 0;
  final Map<String, int>? stats;
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
          final String statName = entry.key;
          final int statValue = entry.value;

          return BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: statValue.toDouble(),
                width: 20,
                color:
                    Color(PokemonStatsToColor.getColor(statName) ?? 0xFF000000),
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
                value,
                meta,
                stats?.values.map((e) => e.toString()).toList() ?? [],
                angle: angle,
                offset: offsetTop,
              ),
            )),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => getAxiTitles(
                  value,
                  meta,
                  stats?.keys.toList() ?? [],
                  angle: angle,
                  offset: offsetBottom,
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

Widget getAxiTitles(double value, TitleMeta meta, List<String> titles,
    {double fontSize = 14, double angle = 0, offset = Offset.zero}) {
  final style = TextStyle(
    color: Color(
        PokemonStatsToColor.getColor(titles[PokemonStatsChart.count++]) ??
            0xFF000000),
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
  );

  PokemonStatsChart.count--;

  Widget text = Transform.translate(
    offset: offset,
    child: Transform.rotate(
      angle: angle * math.pi / 180,
      child: Text(
        //titles[value.toInt()], // NO INCREMENTA VALUE
        titles[PokemonStatsChart.count++],
        style: style,
      ),
    ),
  );

  if (PokemonStatsChart.count == 6) {
    PokemonStatsChart.count = 0;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
