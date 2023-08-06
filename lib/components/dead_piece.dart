import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DeadPiece extends StatelessWidget {
  final String ImagePath;
  final bool isWhite;
  const DeadPiece({super.key, required this.ImagePath, required this.isWhite});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ImagePath,
    color: isWhite ? Colors.white : Colors.black,);
  }
}
