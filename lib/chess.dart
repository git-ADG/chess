import 'package:chess/components/dead_piece.dart';
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

  List<ChessPiece> WhitePieceTaken = [];
  List<ChessPiece> BlackPieceTaken = [];

  List<List<int>> validMoves = [];

  bool isWhiteTurn = true;

  List<int> WhiteKingPosition = [7, 4];
  List<int> BlackKingPosition = [0, 4];

  bool checkStatus = false;

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
      if (SelectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.iswhite == isWhiteTurn) {
          SelectedPiece = board[row][col];
          SelectedRow = row;
          SelectedCol = col;
        }
      } else if (board[row][col] != null &&
          board[row][col]!.iswhite == SelectedPiece!.iswhite) {
        SelectedPiece = board[row][col];
        SelectedRow = row;
        SelectedCol = col;
      } else if (SelectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      validMoves = CalculateRealValidMoves(
          SelectedRow, SelectedCol, SelectedPiece, true);
    });
  }

  List<List<int>> CalculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    if (piece == null) {
      return [];
    }

    int direction = piece.iswhite ? -1 : 1;

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
            board[row + direction][col - 1]!.iswhite != piece.iswhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.iswhite != piece.iswhite) {
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
        var directions = [
          [1, 1],
          [-1, 1],
          [1, -1],
          [-1, -1],
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
      case ChessPieceType.queen:
        var directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
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
      case ChessPieceType.king:
        var directions = [
          [1, 0],
          [-1, 0],
          [0, 1],
          [0, -1],
          [1, 1],
          [1, -1],
          [-1, 1],
          [-1, -1],
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
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
    }
    return candidateMoves;
  }

  List<List<int>> CalculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool CheckSimulation) {
    List<List<int>> realValidMoves = [];
    List<List<int>> candidateMoves = CalculateRawValidMoves(row, col, piece);

    if (CheckSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];
        if (SimulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMoves.add(move);
        }
      }
    } else {
      realValidMoves = candidateMoves;
    }
    return realValidMoves;
  }

  bool SimulatedMoveIsSafe(
      ChessPiece piece, int StartRow, int StartCol, int EndRow, int EndCol) {
    ChessPiece? OriginalDestinationPiece = board[EndRow][EndCol];

    List<int>? OriginalKingPosition;

    if (piece.type == ChessPieceType.king) {
      OriginalKingPosition = piece.iswhite
          ? List.from(WhiteKingPosition)
          : List.from(BlackKingPosition);
      if (piece.iswhite) {
        WhiteKingPosition = [EndRow, EndCol];
      } else {
        BlackKingPosition = [EndRow, EndCol];
      }
    }

    board[EndRow][EndCol] = piece;
    board[StartRow][StartCol] = null;

    bool kingInCheck = isKingInCheck(piece.iswhite);

    board[StartRow][StartCol] = piece;
    board[EndRow][EndCol] = OriginalDestinationPiece;

    if (piece.type == ChessPieceType.king) {
      if (piece.iswhite) {
        WhiteKingPosition = OriginalKingPosition!;
      } else {
        BlackKingPosition = OriginalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  bool isKingInCheck(bool isWhiteKing) {
    List<int> KingPosition =
        isWhiteKing ? WhiteKingPosition : BlackKingPosition;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.iswhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            CalculateRealValidMoves(i, j, board[i][j], false);
        if (pieceValidMoves.any((move) =>
            move[0] == KingPosition[0] && move[1] == KingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.iswhite != isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves = CalculateRealValidMoves(
            i, j, board[i][j], false); // Check valid moves
        for (var move in pieceValidMoves) {
          if (SimulatedMoveIsSafe(board[i][j]!, i, j, move[0], move[1])) {
            return false;
          }
        }
      }
    }
    return true;
  }

  void movePiece(int newRow, int newCol) {
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.iswhite) {
        WhitePieceTaken.add(capturedPiece);
      } else {
        BlackPieceTaken.add(capturedPiece);
      }
    }

    board[newRow][newCol] = SelectedPiece;
    board[SelectedRow][SelectedCol] = null;

    if (SelectedPiece!.type == ChessPieceType.king) {
      if (SelectedPiece!.iswhite) {
        WhiteKingPosition = [newRow, newCol];
      } else {
        BlackKingPosition = [newRow, newCol];
      }
    }

    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      SelectedPiece = null;
      SelectedRow = -1;
      SelectedCol = -1;
      validMoves = [];
    });

    if (isCheckMate(!isWhiteTurn)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("CHECK MATE!!!"),
          actions: [
            TextButton(onPressed: resetGame, child: const Text("Play Again"))
          ],
        ),
      );
    }

    isWhiteTurn = !isWhiteTurn;
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

    newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        iswhite: false,
        imagePath: 'images/Chess_qlt45.svg');

    newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        iswhite: true,
        imagePath: 'images/Chess_qlt45.svg');

    //kings

    newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        iswhite: false,
        imagePath: 'images/Chess_klt45.svg');

    newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        iswhite: true,
        imagePath: 'images/Chess_klt45.svg');

    board = newBoard;
  }

  void resetGame() {
    Navigator.pop(context);
    _initializeBoard();
    checkStatus = false;
    WhitePieceTaken.clear();
    BlackPieceTaken.clear();
    WhiteKingPosition = [0, 4];
    BlackKingPosition = [7, 4];
    isWhiteTurn = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Column(
        children: [
          Expanded(
              child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: WhitePieceTaken.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8),
            itemBuilder: (context, index) => DeadPiece(
              ImagePath: WhitePieceTaken[index].imagePath,
              isWhite: true,
            ),
          )),
          Text(checkStatus ? "CHECK!!!" : ""),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 8 * 8,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8),
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
          ),
          Expanded(
              child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: BlackPieceTaken.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8),
            itemBuilder: (context, index) => DeadPiece(
              ImagePath: BlackPieceTaken[index].imagePath,
              isWhite: false,
            ),
          ))
        ],
      ),
    );
  }
}
