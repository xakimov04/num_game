sealed class PuzzleEvent {}

class InitializePuzzle extends PuzzleEvent {}

class TileTapped extends PuzzleEvent {
  final int index;
  TileTapped(this.index);
}

class UndoMove extends PuzzleEvent {}

class TimerTicked extends PuzzleEvent {}
