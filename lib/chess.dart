import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:flutter/material.dart';

class Chess extends StatefulWidget {
  const Chess({super.key});

  @override
  State<Chess> createState() => _ChessState();
}

class _ChessState extends State<Chess> {
  late List<List<ChessPiece?>> board;

  ChessPiece? SelectedPiece;

  int SelectedRow = -1;
  int SelectedCol = -1;

  List<List<int>> validMoves = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeBoard();
  }

  bool isInBoard(int row, int col) {
    return row >= 0 && row < 8 && col >= 0 && col < 8;
  }

  void PieceSelected(int row, int col) {
    setState(() {
      if (board[row][col] != null) {
        SelectedPiece = board[row][col];
        SelectedRow = row;
        SelectedCol = col;
      }
      validMoves =
          CalculateRawValidMoves(SelectedRow, SelectedCol, SelectedPiece);
    });
  }

  List<List<int>> CalculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    int direction = piece!.iswhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        if ((row == 1 && !piece.iswhite) || (row == 6 && piece.iswhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.iswhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.iswhite) {
          candidateMoves.add([row + direction, col + 1]);
        }

        break;

      case ChessPieceType.rook:
        var directions = [
          [0, 1],
          [0, -1],
          [1, 0],
          [-1, 0]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.iswhite != piece.iswhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;

      case ChessPieceType.knight:
        var knightMoves = [
          [1, 2],
          [-1, 2],
          [1, -2],
          [-1, -2],
          [2, 1],
          [2, -1],
          [-2, 1],
          [-2, -1],
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.iswhite != piece.iswhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }

        break;
      case ChessPieceType.bishop:
        var directions=[
          [1,1],
          [-1,1],
          [1,-1],
          [-1,-1],
        ];

        break;
      case ChessPieceType.queen:
        break;
      case ChessPieceType.king:
        break;
    }
    return candidateMoves;
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
        8,
        (index) => List.generate(
              8,
              (index) => null,
            ));

    //pawns
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          type: ChessPieceType.pawn,
          iswhite: false,
          imagePath: 'images/Chess_plt45.svg');

      newBoard[6][i] = ChessPiece(
          type: ChessPieceType.pawn,
          iswhite: true,
          imagePath: 'images/Chess_plt45.svg');
    }

    //rooks

    newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        iswhite: false,
        imagePath: 'images/Chess_rlt45.svg');

    newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        iswhite: false,
        imagePath: 'images/Chess_rlt45.svg');

    newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        iswhite: true,
        imagePath: 'images/Chess_rlt45.svg');

    newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        iswhite: true,
        imagePath: 'images/Chess_rlt45.svg');

    //knights

    newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        iswhite: false,
        imagePath: 'images/Chess_nlt45.svg');

    newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        iswhite: false,
        imagePath: 'images/Chess_nlt45.svg');

    newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        iswhite: true,
        imagePath: 'images/Chess_nlt45.svg');

    newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        iswhite: true,
        imagePath: 'images/Chess_nlt45.svg');

    //bishops

    newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        iswhite: false,
        imagePath: 'images/Chess_blt45.svg');

    newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        iswhite: false,
        imagePath: 'images/Chess_blt45.svg');

    newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        iswhite: true,
        imagePath: 'images/Chess_blt45.svg');

    newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        iswhite: true,
        imagePath: 'images/Chess_blt45.svg');

    //queens

    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.queen,
        iswhite: false,
        imagePath: 'images/Chess_qlt45.svg');

    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        iswhite: true,
        imagePath: 'images/Chess_qlt45.svg');

    //kings

    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        iswhite: false,
        imagePath: 'images/Chess_klt45.svg');

    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.queen,
        iswhite: true,
        imagePath: 'images/Chess_klt45.svg');

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;

          bool iswhite = (row + col) % 2 == 0;
          bool isSelected = SelectedRow == row && SelectedCol == col;

          bool isValidMove = false;

          for (var position in validMoves) {
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
            }
          }

          return Square(
            iswhite: iswhite,
            piece: board[row][col],
            isSelected: isSelected,
            onTap: () => PieceSelected(row, col),
            isValidMove: isValidMove,
          );
        },
      ),
    );
  }
}
