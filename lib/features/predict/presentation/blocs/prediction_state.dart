// prediction_state.dart
part of 'prediction_bloc.dart';

abstract class PredictionState extends Equatable {
  const PredictionState();
  @override
  List<Object> get props => [];
}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final PredictionResult result;
  const PredictionSuccess(this.result);
  @override
  List<Object> get props => [result];
}

class PredictionError extends PredictionState {
  final String message;
  const PredictionError(this.message);
  @override
  List<Object> get props => [message];
}

class HistoryLoading extends PredictionState {}

class HistoryLoaded extends PredictionState {
  final List<PredictionHistoryEntry> history;
  const HistoryLoaded(this.history);
  @override
  List<Object> get props => [history];
}

class HistoryError extends PredictionState {
  final String message;
  const HistoryError(this.message);
  @override
  List<Object> get props => [message];
}