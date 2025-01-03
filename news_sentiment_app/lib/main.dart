import 'package:flutter/material.dart';
import 'package:dart_sentiment/dart_sentiment.dart';

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
  String? headlineText;
  bool isAnalyzing = false;

  final TextEditingController _textController = TextEditingController();
  final Sentiment _sentiment = Sentiment();

  void analyzeSentiment() {
    if (headlineText != null && headlineText!.isNotEmpty) {
      setState(() {
        isAnalyzing = true;
      });

      try {
        // Perform sentiment analysis
        final result = _sentiment.analysis(headlineText!, emoji: true);
        final score = result['score'] as int?;

        setState(() {
          isAnalyzing = false;
          sentimentResult = _interpretScore(score);
        });
      } catch (e) {
        setState(() {
          isAnalyzing = false;
          sentimentResult = "Error analyzing sentiment. $e";
        });
      }
    } else {
      setState(() {
        sentimentResult = "Please enter a headline first.";
      });
    }
  }

  String _interpretScore(int? score) {
    if (score == null) return "No sentiment detected.";
    if (score > 0) return "Positive Sentiment";
    if (score < 0) return "Negative Sentiment";
    return "Neutral Sentiment";
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
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

            // Text Input Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: "Enter the news headline",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  headlineText = value;
                  sentimentResult = null; // Reset result on text change
                },
              ),
            ),
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