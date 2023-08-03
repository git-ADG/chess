import 'package:chess/components/piece.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Square extends StatelessWidget {
  final bool iswhite;
  final ChessPiece? piece;
  final bool isSelected;
  final void Function()? onTap;
  final bool isValidMove;

  const Square(
      {super.key,
      required this.iswhite,
      required this.piece,
      required this.isSelected,
      required this.onTap,
      required this.isValidMove});

  @override
  Widget build(BuildContext context) {
    Color? squarecolor;

    if (isSelected) {
      squarecolor = Colors.green;
    }
    else if(isValidMove){
      squarecolor = Colors.green[300];
    }
    else {
      squarecolor = iswhite ? Colors.grey[400] : Colors.grey[700];
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squarecolor,
        child: piece != null
            ? SvgPicture.asset(
                piece!.imagePath,
                color: piece!.iswhite ? Colors.white : Colors.black,
              )
            : null,
      ),
    );
  }
}
