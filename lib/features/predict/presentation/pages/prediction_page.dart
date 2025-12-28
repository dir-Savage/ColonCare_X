// features/predict/presentation/pages/prediction_page.dart
import 'dart:io';
import 'package:coloncare/core/navigation/app_router.dart';
import 'package:coloncare/features/predict/presentation/blocs/prediction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/injector.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key});

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PredictionBloc>(
      create: (_) => getIt<PredictionBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Colon Polyp Prediction'),
        ),
        body: BlocConsumer<PredictionBloc, PredictionState>(
          listener: (context, state) {
            if (state is PredictionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Image Preview Area
                Expanded(
                  child: _buildPreviewOrPlaceholder(state),
                ),

                // Status / Result Area
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStatusOrResult(state),
                ),

                // Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pick Image Button
                      OutlinedButton.icon(
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Pick Image'),
                        onPressed: () => _pickImage(context),
                      ),

                      // Predict Button (only visible when image is selected)
                      if (_selectedImage != null)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Predict'),
                          onPressed: state is PredictionLoading
                              ? null
                              : () => _startPrediction(context),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, AppRouter.predictionHistory),
          child: const Icon(Icons.history),
        ),
      ),
    );
  }

  Widget _buildPreviewOrPlaceholder(PredictionState state) {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage!,
        fit: BoxFit.contain,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.image_search,
            size: 120,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            state is PredictionSuccess
                ? 'Prediction complete! Pick another image?'
                : 'Select an image to begin',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOrResult(PredictionState state) {
    if (state is PredictionLoading) {
      return const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing image...'),
          ],
        ),
      );
    }

    if (state is PredictionSuccess) {
      final result = state.result;
      final color = result.prediction == 'Normal' ? Colors.green : Colors.red;

      return Column(
        children: [
          Text(
            result.prediction,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Confidence: ${(result.probability * 100).toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 20),
          ),
          if (result.isOutOfDistribution)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                'Warning: Image may be out of distribution',
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            result.details.isNotEmpty ? result.details : 'No additional details',
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _startPrediction(BuildContext context) {
    if (_selectedImage != null) {
      context.read<PredictionBloc>().add(PredictFromImage(_selectedImage!));
    }
  }
}