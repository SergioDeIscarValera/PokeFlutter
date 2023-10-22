import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

Widget getAxiTitles({
  required double value,
  required List<String> titles,
  required TitleMeta meta,
  double fontSize = 14,
  double angle = 0,
  Offset offset = Offset.zero,
  required Function(int) setIndex,
  required int index,
  required int limit,
  required Color Function(int value) color,
}) {
  final style = TextStyle(
    color: color.call(index),
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
  );

  Widget text = Transform.translate(
    offset: offset,
    child: Transform.rotate(
      angle: angle * math.pi / 180,
      child: Text(
        titles[index++], // NO INCREMENTA VALUE
        style: style,
      ),
    ),
  );

  if (index == limit) {
    setIndex.call(0);
  } else {
    setIndex.call(index);
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
