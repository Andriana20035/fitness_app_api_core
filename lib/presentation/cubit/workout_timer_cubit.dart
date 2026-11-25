import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/ticker.dart';

enum TimerStatus { initial, running, paused, finished }

class WorkoutTimerState extends Equatable {
  final int totalSeconds;
  final int remainingSeconds;
  final TimerStatus status;

  const WorkoutTimerState({
    required this.totalSeconds,
    required this.remainingSeconds,
    required this.status,
  });

  int get elapsedSeconds => totalSeconds - remainingSeconds;

  double get progress => totalSeconds == 0 ? 0 : elapsedSeconds / totalSeconds;

  bool get hasStarted => elapsedSeconds > 0 || status != TimerStatus.initial;

  WorkoutTimerState copyWith({int? remainingSeconds, TimerStatus? status}) =>
      WorkoutTimerState(
        totalSeconds: totalSeconds,
        remainingSeconds: remainingSeconds ?? this.remainingSeconds,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [totalSeconds, remainingSeconds, status];
}

class WorkoutTimerCubit extends Cubit<WorkoutTimerState> {
  WorkoutTimerCubit({
    required int durationSeconds,
    Ticker ticker = const Ticker(),
  })  : _ticker = ticker, // ignore: prefer_initializing_formals
        super(WorkoutTimerState(
          totalSeconds: durationSeconds,
          remainingSeconds: durationSeconds,
          status: TimerStatus.initial,
        ));

  final Ticker _ticker;
  StreamSubscription<int>? _subscription;

  void start() {
    if (state.status == TimerStatus.running ||
        state.status == TimerStatus.finished) {
      return;
    }
    _subscription?.cancel();
    emit(state.copyWith(status: TimerStatus.running));
    _subscription = _ticker.tick(ticks: state.remainingSeconds).listen(
      (remaining) => emit(state.copyWith(
        remainingSeconds: remaining,
        status: remaining > 0 ? TimerStatus.running : TimerStatus.finished,
      )),
    );
  }

  void pause() {
    if (state.status != TimerStatus.running) return;
    _subscription?.pause();
    emit(state.copyWith(status: TimerStatus.paused));
  }

  void resume() {
    if (state.status != TimerStatus.paused) return;
    _subscription?.resume();
    emit(state.copyWith(status: TimerStatus.running));
  }

  /// Ends the session early (keeps the elapsed time).
  void finish() {
    if (state.status == TimerStatus.finished) return;
    _subscription?.cancel();
    emit(state.copyWith(status: TimerStatus.finished));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
