class PuzzleState {
  final List<int> tiles;
  final int score;
  final int bestScore;
  final int remainingTime;

  PuzzleState({
    required this.tiles,
    required this.score,
    required this.bestScore,
    required this.remainingTime,
  });
}

class PuzzleInitial extends PuzzleState {
  PuzzleInitial()
      : super(
          tiles: _generateShuffledTiles(),
          score: 0,
          bestScore: 0,
          remainingTime: 300,
        );

  static List<int> _generateShuffledTiles() {
    List<int> tiles = List<int>.generate(16, (index) => index);
    tiles.shuffle();
    return tiles;
  }
}

class PuzzleUpdated extends PuzzleState {
  PuzzleUpdated({
    required super.tiles,
    required super.score,
    required super.bestScore,
    required super.remainingTime,
  });
}

class PuzzleCompleted extends PuzzleState {
  PuzzleCompleted(
      {required super.tiles,
      required super.score,
      required super.bestScore,
      required super.remainingTime});
}

class PuzzleFailed extends PuzzleState {
  PuzzleFailed(
      {required super.tiles,
      required super.score,
      required super.bestScore,
      required super.remainingTime});
}
