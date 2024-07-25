sealed class PuzzleEvent {}

class InitializePuzzle extends PuzzleEvent {}

class TileTapped extends PuzzleEvent {
  final int index;

  TileTapped(this.index);
}

class TimerTicked extends PuzzleEvent {}
