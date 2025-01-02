import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const NewsSentimentAnalyzer());
}

class NewsSentimentAnalyzer extends StatelessWidget {
  const NewsSentimentAnalyzer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Roboto'),
      home: Scaffold(
        body: const SentimentAnalyzerBody(),
      ),
    );
  }
}

class SentimentAnalyzerBody extends StatefulWidget {
  const SentimentAnalyzerBody({Key? key}) : super(key: key);

  @override
  State<SentimentAnalyzerBody> createState() => _SentimentAnalyzerBodyState();
}

class _SentimentAnalyzerBodyState extends State<SentimentAnalyzerBody> {
  String? sentimentResult;
  File? selectedFile;
  bool isAnalyzing = false;

  void analyzeSentiment() async {
    if (selectedFile != null) {
      setState(() {
        isAnalyzing = true;
      });

      // Simulate sentiment analysis delay (replace with actual logic)
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        isAnalyzing = false;
        sentimentResult = "Positive"; // Example sentiment result
      });
    } else {
      setState(() {
        sentimentResult = "Please upload a file first.";
      });
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        sentimentResult = null; // Reset result on new file upload
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.indigo],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            const Text(
              'News Sentiment Analyzer',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cool Fading Description Text
            FadeTransitionText(
              text: "Analyze the sentiment of news articles effortlessly.",
            ),
            const SizedBox(height: 40),

            // Upload Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: pickFile,
              icon: const Icon(Icons.upload_file, color: Colors.blueAccent),
              label: const Text(
                'Upload File',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),

            if (selectedFile != null) ...[
              const SizedBox(height: 30),
              Card(
                elevation: 8,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Selected File: ${selectedFile!.path.split('/').last}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),

            // Analyze Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: isAnalyzing ? null : analyzeSentiment,
              icon: const Icon(Icons.analytics, color: Colors.white),
              label: const Text(
                'Analyze',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),

            // Loading Indicator
            if (isAnalyzing)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),

            // Sentiment Result
            if (sentimentResult != null && !isAnalyzing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      sentimentResult!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FadeTransitionText extends StatelessWidget {
  final String text;

  const FadeTransitionText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(seconds: 2),
      builder: (context, double opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
      ),
    );
  }
}
