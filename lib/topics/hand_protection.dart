// Flutter page for Topic 6: Hand Protection
// Full content, quiz, and logic

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandProtectionPage extends StatefulWidget {
  @override
  _HandProtectionPageState createState() => _HandProtectionPageState();
}

class _HandProtectionPageState extends State<HandProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "HandProtection";

  final Map<int, String> correctAnswers = {
    1: "To protect hands from cuts, burns, and chemicals",
    2: "Gloves",
    3: "Inspect for tears or contamination",
    4: "Based on job-specific hazards",
    5: "Dispose or clean properly after use",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is hand protection important?",
      "options": [
        "To look clean",
        "To protect hands from cuts, burns, and chemicals",
        "To prevent handshakes",
        "For style"
      ]
    },
    {
      "question": "What PPE is used for hand protection?",
      "options": [
        "Gloves",
        "Masks",
        "Hats",
        "Shoes"
      ]
    },
    {
      "question": "How should gloves be maintained?",
      "options": [
        "Throw them anywhere",
        "Inspect for tears or contamination",
        "Never wash",
        "Paint them"
      ]
    },
    {
      "question": "How do you select gloves?",
      "options": [
        "Color match",
        "Based on job-specific hazards",
        "Cheapest option",
        "Use friend's gloves"
      ]
    },
    {
      "question": "What should be done after glove use?",
      "options": [
        "Store in lunchbox",
        "Dispose or clean properly after use",
        "Give away",
        "Hang on wall"
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicStatus();
  }

  Future<void> _loadTopicStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCompleted = prefs.getBool('Completed_$topicName') ?? false;
      quizScore = prefs.getInt('QuizScore_$topicName') ?? -1;
      hasTakenQuiz = prefs.getBool('QuizTaken_$topicName') ?? false;
    });
  }

  Future<void> _saveTopicCompletion(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('Completed_$topicName', value);
    setState(() {
      isCompleted = value;
    });
    if (value) {
      _showQuizDialog();
    }
  }

  Future<void> _saveQuizScore(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('QuizScore_$topicName', score);
    await prefs.setBool('QuizTaken_$topicName', true);
    setState(() {
      quizScore = score;
      hasTakenQuiz = true;
    });
  }

  void _showQuizDialog() {
    userAnswers.clear();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Hand Protection Quiz"),
              content: SingleChildScrollView(
                child: Column(
                  children: quizQuestions.map((question) {
                    int index = quizQuestions.indexOf(question) + 1;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question["question"], style: TextStyle(fontWeight: FontWeight.bold)),
                        ...question["options"].map<Widget>((option) {
                          return RadioListTile<String>(
                            title: Text(option),
                            value: option,
                            groupValue: userAnswers[index],
                            onChanged: (String? value) {
                              setState(() {
                                userAnswers[index] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: Text("Submit"),
                  onPressed: () {
                    if (userAnswers.length < quizQuestions.length) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please answer all questions")),
                      );
                    } else {
                      Navigator.of(context).pop();
                      _evaluateQuiz();
                    }
                  },
                )
              ],
            );
          },
        );
      },
    );
  }

  void _evaluateQuiz() {
    int score = 0;
    userAnswers.forEach((key, value) {
      if (correctAnswers[key] == value) {
        score++;
      }
    });
    _saveQuizScore(score);
    _showQuizResult(score);
  }

  void _showQuizResult(int score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Quiz Result"),
          content: Text("You scored $score out of ${quizQuestions.length}.",),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Retest"),
              onPressed: () {
                Navigator.pop(context);
                _showQuizDialog();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionAnswer(String question, String answer) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(answer, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hand Protection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧤 What is hand protection?", "It includes gloves and guards that protect hands from injuries like cuts, burns, or chemical exposure."),
                  _buildQuestionAnswer("🧤 Why is it important?", "Hands are frequently exposed to sharp tools, chemicals, and hot surfaces in the workplace."),
                  _buildQuestionAnswer("🧤 What are common types of gloves?", "Latex gloves, leather gloves, cut-resistant gloves, and chemical-resistant gloves."),
                  _buildQuestionAnswer("🧤 How do you select gloves?", "By assessing the type of hazard like sharp edges, heat, or chemicals."),
                  _buildQuestionAnswer("🧤 Can gloves be reused?", "Some can be reused after proper cleaning; disposables should be discarded after one use."),
                  _buildQuestionAnswer("🧤 When should gloves be replaced?", "When damaged, torn, or after exposure to dangerous substances."),
                  _buildQuestionAnswer("🧤 Are all gloves the same?", "No, they vary based on protection level, material, and task."),
                  _buildQuestionAnswer("🧤 Who should provide gloves?", "The employer is responsible for supplying appropriate PPE."),
                  _buildQuestionAnswer("🧤 Can damaged gloves still be used?", "No. They should be discarded and replaced immediately."),
                  _buildQuestionAnswer("🧤 What is glove fitment?", "Ensuring the gloves fit snugly without restricting hand movement."),
                ],
              ),
            ),
            CheckboxListTile(
              title: Text("Mark as Completed"),
              value: isCompleted,
              onChanged: (value) => _saveTopicCompletion(value ?? false),
            ),
            if (hasTakenQuiz)
              Text("Last Quiz Score: $quizScore / ${quizQuestions.length}"),
            if (hasTakenQuiz)
              ElevatedButton(
                onPressed: _showQuizDialog,
                child: Text("Retest"),
              )
          ],
        ),
      ),
    );
  }
}
