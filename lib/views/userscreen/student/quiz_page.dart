import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Color blueColor = const Color(0xFF365DA8);

  // 🔹 Exemple de quiz (tu pourras brancher une vraie BDD plus tard)
  final List<Map<String, dynamic>> _questions = [
    {
      "question": "Quelle est la capitale du Cameroun ?",
      "options": ["Douala", "Yaoundé", "Bafoussam", "Kribi"],
      "answer": "Yaoundé"
    },
    {
      "question": "Qui est le créateur de Flutter ?",
      "options": ["Apple", "Microsoft", "Google", "Meta"],
      "answer": "Google"
    },
    {
      "question": "Dart est principalement utilisé pour ?",
      "options": [
        "Le développement mobile",
        "Le montage vidéo",
        "Les bases de données",
        "Le machine learning"
      ],
      "answer": "Le développement mobile"
    },
  ];

  int _currentIndex = 0;
  String? _selectedOption;
  int _score = 0;

  void _nextQuestion() {
    if (_selectedOption == _questions[_currentIndex]["answer"]) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Résultats"),
        content: Text(
          "Vous avez obtenu $_score / ${_questions.length} bonnes réponses.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: blueColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Progression
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              color: blueColor,
              backgroundColor: Colors.grey[300],
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 24),

            // 🔹 Question
            Text(
              "Question ${_currentIndex + 1}/${_questions.length}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              currentQuestion["question"],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: blueColor,
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 Options
            ...currentQuestion["options"].map<Widget>((option) {
              final isSelected = _selectedOption == option;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedOption = option);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? blueColor.withOpacity(0.1) : Colors.white,
                    border: Border.all(
                      color: isSelected ? blueColor : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: isSelected ? blueColor : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? blueColor : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const Spacer(),

            // 🔹 Bouton suivant
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _selectedOption == null ? null : _nextQuestion,
                child: Text(
                  _currentIndex == _questions.length - 1
                      ? "Terminer"
                      : "Suivant",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
