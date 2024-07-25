import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/puzzle_bloc.dart';
import '../../bloc/puzzle_event.dart';
import '../../bloc/puzzle_state.dart';

class PuzzleScreen extends StatelessWidget {
  const PuzzleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '15 Puzzle Game',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.undo,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<PuzzleBloc>().add(UndoMove());
            },
          ),
        ],
      ),
      body: BlocConsumer<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (state is PuzzleCompleted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Congratulations!'),
                content: const Text('You won the game!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<PuzzleBloc>().add(InitializePuzzle());
                    },
                    child: const Text('Restart'),
                  ),
                ],
              ),
            );
          } else if (state is PuzzleFailed) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Time Up!'),
                content: const Text('You lost the game.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.read<PuzzleBloc>().add(InitializePuzzle());
                    },
                    child: const Text('Restart'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: ${state.score}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Best: ${state.bestScore}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time: ${state.remainingTime ~/ 60}:${(state.remainingTime % 60).toString().padLeft(2, '0')}',
                  style: GoogleFonts.robotoMono(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: state.tiles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.read<PuzzleBloc>().add(TileTapped(index));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: state.tiles[index] == 0
                                ? Colors.grey[300]
                                : Colors.indigo,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2, 2),
                                blurRadius: 5.0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              state.tiles[index] == 0
                                  ? ''
                                  : state.tiles[index].toString(),
                              style: GoogleFonts.lobster(
                                fontSize: 32,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
