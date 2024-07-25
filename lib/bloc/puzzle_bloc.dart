import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'puzzle_event.dart';
import 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  late Timer _timer;

  PuzzleBloc() : super(PuzzleInitial()) {
    on<InitializePuzzle>((event, emit) {
      emit(PuzzleInitial());
      _startTimer();
    });

    on<TileTapped>((event, emit) {
      List<int> newTiles = List.from(state.tiles);
      int emptyIndex = newTiles.indexOf(0);
      int tappedIndex = event.index;

      if ((tappedIndex - 1 == emptyIndex && tappedIndex % 4 != 0) ||
          (tappedIndex + 1 == emptyIndex && emptyIndex % 4 != 0) ||
          (tappedIndex - 4 == emptyIndex) ||
          (tappedIndex + 4 == emptyIndex)) {
        newTiles[emptyIndex] = newTiles[tappedIndex];
        newTiles[tappedIndex] = 0;

        bool isCompleted = _checkIfCompleted(newTiles);

        if (isCompleted) {
          _timer.cancel();
          emit(PuzzleCompleted(
            tiles: newTiles,
            score: state.score + 1,
            bestScore: state.bestScore,
            remainingTime: state.remainingTime,
          ));
        } else {
          emit(PuzzleUpdated(
            tiles: newTiles,
            score: state.score + 1,
            bestScore: state.bestScore,
            remainingTime: state.remainingTime,
          ));
        }
      }
    });

    on<TimerTicked>((event, emit) {
      if (state.remainingTime > 0) {
        emit(PuzzleUpdated(
          tiles: state.tiles,
          score: state.score,
          bestScore: state.bestScore,
          remainingTime: state.remainingTime - 1,
        ));
      } else {
        _timer.cancel();
        emit(PuzzleFailed(
          tiles: state.tiles,
          score: state.score,
          bestScore: state.bestScore,
          remainingTime: state.remainingTime,
        ));
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTicked());
    });
  }

  bool _checkIfCompleted(List<int> tiles) {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) {
        return false;
      }
    }
    return true;
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
