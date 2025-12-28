import 'package:coloncare/features/predict/presentation/blocs/prediction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/navigation/app_router.dart';

class PredictionHistoryPage extends StatelessWidget {
  const PredictionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PredictionBloc>(
      create: (_) => getIt<PredictionBloc>()..add(const LoadPredictionHistory()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Prediction History')),
        body: BlocBuilder<PredictionBloc, PredictionState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is HistoryError) {
              return Center(child: Text(state.message));
            }
            if (state is HistoryLoaded) {
              if (state.history.isEmpty) {
                return const Center(child: Text('No predictions yet'));
              }
              return ListView.builder(
                itemCount: state.history.length,
                itemBuilder: (context, index) {
                  final entry = state.history[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: entry.result.prediction == 'Normal' ? Colors.green : Colors.red,
                      child: Text(
                        entry.result.prediction[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(entry.result.prediction),
                    subtitle: Text(
                      '${(entry.result.probability * 100).toStringAsFixed(1)}% • ${entry.createdAt.toString().substring(0, 16)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<PredictionBloc>().add(DeletePrediction(entry.id));
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}