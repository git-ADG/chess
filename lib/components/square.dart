import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool iswhite;
  const Square({super.key, required this.iswhite});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: iswhite? Colors.grey[200]: Colors.grey[500],
    );
  }
}
