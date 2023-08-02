import 'package:chess/components/square.dart';
import 'package:flutter/material.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          int x = index ~/ 8;
          int y = index % 8;

          bool iswhite = (x + y) % 2 == 0;

          return Square(iswhite: iswhite);
        },
      ),
    );
  }
}
