import 'package:equatable/equatable.dart';

import '../../domain/entities/fitness_data.dart';

abstract class FitnessState extends Equatable {
  const FitnessState();

  @override
  List<Object?> get props => [];
}

class FitnessInitial extends FitnessState {
  const FitnessInitial();
}

class FitnessLoading extends FitnessState {
  const FitnessLoading();
}

class FitnessSuccess extends FitnessState {
  final FitnessData data;

  const FitnessSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class FitnessEmpty extends FitnessState {
  final FitnessData data;
  final String message;

  const FitnessEmpty(
    this.data, {
    this.message = 'No workouts found',
  });

  @override
  List<Object?> get props => [data, message];
}

class FitnessError extends FitnessState {
  final String message;

  const FitnessError(this.message);

  @override
  List<Object?> get props => [message];
}
