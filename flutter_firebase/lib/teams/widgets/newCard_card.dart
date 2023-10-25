import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class NewCardCard extends StatelessWidget {
  const NewCardCard({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: DottedBorder(
        color: Colors.grey[700]!,
        radius: const Radius.circular(16),
        borderType: BorderType.RRect,
        dashPattern: const [8, 4],
        strokeWidth: 2,
        child: Center(
          child: Icon(Icons.add, color: Colors.grey[700], size: 50),
        ),
      ),
    );
  }
}
