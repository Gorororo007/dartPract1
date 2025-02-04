import 'dart:io';
import 'dart:math';

enum Player { none, x, o }

class TicTacToe {
  late List<List<Player>> board;
  late int size;
  Player currentPlayer = Player.none;
  bool gameRunning = false;
  bool againstRobot = false;

  void startNewGame() {
    print('Размер поля (3-9):');
    try {
      size = int.parse(stdin.readLineSync()!);
      if (size < 3 || size > 9) {
        print('Недоспустимое значение');
        startNewGame();
        return;
      }
    } catch (e) {
      print('Введите целое число.');
      startNewGame();
      return;
    }

    print('Выберите режим игры:');
    print('1. Игрок vs Игрок');
    print('2. Игрок vs Робота');

    String? modeChoice = stdin.readLineSync();
    if (modeChoice == '2') {
      againstRobot = true;
    } else {
      againstRobot = false;
    }

    board = List.generate(size, (_) => 
    List.filled(size, Player.none));
    Random random = Random();
    currentPlayer = random.nextBool() ? Player.x : Player.o;
    gameRunning = true;
    printBoard();
    playGame();
  }

  void printBoard() {
    // Print column numbers
    stdout.write('  ');
    for (int i = 1; i <= size; i++) {
      stdout.write('$i');
    }
    stdout.writeln();

    for (int i = 0; i < size; i++) {
      // Print row numbers
      stdout.write('${i + 1} ');
      for (int j = 0; j < size; j++) {
        String mark;
        switch (board[i][j]) {
          case Player.x:
            mark = 'X';
            break;
          case Player.o:
            mark = 'O';
            break;
          default:
            mark = '.';
        }
        stdout.write(mark);
      }
      stdout.writeln();
    }
  }

  void playGame() {
    while (gameRunning) {
      if (againstRobot && currentPlayer == Player.o) {
        robotTurn();
      } else {
        playerTurn();
      }

      if (checkWin(currentPlayer)) {
        printBoard();
        print('${currentPlayer.toString().split('.').last.toUpperCase()} победа!');
        gameRunning = false;
        askPlayAgain();
      } else if (checkDraw()) {
        printBoard();
        print('\'Ничья!');
        gameRunning = false;
        askPlayAgain();
      } else {
        currentPlayer = (currentPlayer == Player.x) ? Player.o : Player.x;
      }
    }
  }

  void playerTurn() {
    print("${currentPlayer.toString().split('.').last.toUpperCase()}'Введите строку и стобец (например 12):");
    try {
      String? input = stdin.readLineSync();
      if (input == null || input.length != 2) {
        print('Недопустимое значение. Введите строку и стобец (например 12):');
        playerTurn();
        return;
      }

      int row = int.parse(input[0]) - 1;
      int col = int.parse(input[1]) - 1;

      if (row < 0 || row >= size || col < 0 || col >= size || board[row][col] != Player.none) {
        print('Неверный ход. Попробуйте еще раз.');
        playerTurn();
        return;
      }

      board[row][col] = currentPlayer;
      printBoard();
    } catch (e) {
      print('Недопустимое значение. Введите строку и стобец (например 12):');
      playerTurn();
    }
  }

  void robotTurn() {
    print("Робот ходит...");
    Random random = Random();
    int row, col;

    do {
      row = random.nextInt(size);
      col = random.nextInt(size);
    } while (board[row][col] != Player.none);

    board[row][col] = currentPlayer;
    printBoard();
  }

  bool checkWin(Player player) {
    // Check rows
    for (int i = 0; i < size; i++) {
      bool win = true;
      for (int j = 0; j < size; j++) {
        if (board[i][j] != player) {
          win = false;
          break;
        }
      }
      if (win) return true;
    }

    // Check columns
    for (int j = 0; j < size; j++) {
      bool win = true;
      for (int i = 0; i < size; i++) {
        if (board[i][j] != player) {
          win = false;
          break;
        }
      }
      if (win) return true;
    }

    // Check diagonals
    bool winDiagonal1 = true;
    for (int i = 0; i < size; i++) {
      if (board[i][i] != player) {
        winDiagonal1 = false;
        break;
      }
    }
    if (winDiagonal1) return true;

    bool winDiagonal2 = true;
    for (int i = 0; i < size; i++) {
      if (board[i][size - 1 - i] != player) {
        winDiagonal2 = false;
        break;
      }
    }
    if (winDiagonal2) return true;

    return false;
  }

  bool checkDraw() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == Player.none) {
          return false;
        }
      }
    }
    return true;
  }

  void askPlayAgain() {
    print('Играть снова? (y/n)');
    String? answer = stdin.readLineSync();
    if (answer?.toLowerCase() == 'y') {
      startNewGame();
    } else {
      print('Спасибо за игру!');
    }
  }
}

void main() {
  TicTacToe game = TicTacToe();
  game.startNewGame();
}
