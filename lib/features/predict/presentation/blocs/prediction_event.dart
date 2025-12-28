// prediction_event.dart
part of 'prediction_bloc.dart';

abstract class PredictionEvent extends Equatable {
  const PredictionEvent();
  @override
  List<Object> get props => [];
}

class PredictFromImage extends PredictionEvent {
  final File imageFile;
  const PredictFromImage(this.imageFile);
  @override
  List<Object> get props => [imageFile];
}

class LoadPredictionHistory extends PredictionEvent {
  const LoadPredictionHistory();
}

class DeletePrediction extends PredictionEvent {
  final String predictionId;
  const DeletePrediction(this.predictionId);
  @override
  List<Object> get props => [predictionId];
}