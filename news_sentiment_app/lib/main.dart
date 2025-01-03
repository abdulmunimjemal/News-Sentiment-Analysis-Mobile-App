import 'package:flutter/material.dart';
import 'package:dart_sentiment/dart_sentiment.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(const NewsSentimentAnalyzer());
}

class NewsSentimentAnalyzer extends StatelessWidget {
  const NewsSentimentAnalyzer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
      ),
      home: const SentimentAnalyzerBody(),
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

  void pasteText() {
    Clipboard.getData('text/plain').then((value) {
      setState(() {
        _textController.text = value?.text ?? '';
        headlineText = _textController.text;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Sentiment Analyzer'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF84fab0),
              Color(0xFF8fd3f4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: TextField(
                      controller: _textController,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Enter a news headline",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.paste),
                          onPressed: pasteText,
                        ),
                      ),
                      onChanged: (value) {
                        headlineText = value;
                        sentimentResult = null;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Instructions: Paste or type a news headline to analyze its sentiment.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  onPressed: isAnalyzing ? null : analyzeSentiment,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.analytics, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Analyze',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (isAnalyzing)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                if (sentimentResult != null && !isAnalyzing)
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
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
                const SizedBox(height: 20),
                const Text(
                  "Note: The AI could be wrong 5% of the time.",
                  style: TextStyle(fontSize: 12, color: Colors.black45, fontFamily: 'Courier'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
