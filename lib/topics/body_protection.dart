// Flutter page for Topic 8: Body Protection
// Includes educational content, quiz, and local progress tracking

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BodyProtectionPage extends StatefulWidget {
  @override
  _BodyProtectionPageState createState() => _BodyProtectionPageState();
}

class _BodyProtectionPageState extends State<BodyProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "BodyProtection";

  final Map<int, String> correctAnswers = {
    1: "To protect the body from physical, chemical, and biological hazards",
    2: "Coveralls, aprons, and chemical suits",
    3: "Ensure proper fit and no damage",
    4: "Based on specific worksite risks",
    5: "Wear anytime the task involves body exposure to hazards",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is body protection necessary?",
      "options": [
        "To stay warm",
        "To protect the body from physical, chemical, and biological hazards",
        "To reduce uniform cost",
        "To look formal"
      ]
    },
    {
      "question": "Which items are considered body protection PPE?",
      "options": [
        "Socks",
        "Coveralls, aprons, and chemical suits",
        "Shoes",
        "Caps"
      ]
    },
    {
      "question": "How should body PPE be checked?",
      "options": [
        "Color preference",
        "Ensure proper fit and no damage",
        "Brand only",
        "Spray perfume on it"
      ]
    },
    {
      "question": "How do you select body PPE?",
      "options": [
        "Based on color",
        "Based on weather",
        "Based on specific worksite risks",
        "Any available item"
      ]
    },
    {
      "question": "When should you wear body protection?",
      "options": [
        "Only during inspection",
        "When traveling",
        "Wear anytime the task involves body exposure to hazards",
        "While resting"
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
              title: Text("Body Protection Quiz"),
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
      appBar: AppBar(title: Text("Body Protection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("👕 What is body protection?", "It refers to clothing and gear designed to protect the torso and limbs from hazardous substances and conditions."),
                  _buildQuestionAnswer("👕 Why is it important?", "Body protection helps prevent burns, infections, and injuries from chemicals or machinery."),
                  _buildQuestionAnswer("👕 What PPE types are used for body safety?", "Coveralls, flame-resistant suits, aprons, and lab coats depending on the risk."),
                  _buildQuestionAnswer("👕 When should it be used?", "During work involving chemicals, sparks, radiation, or heavy material handling."),
                  _buildQuestionAnswer("👕 Who needs body protection?", "Welders, lab workers, chemical handlers, and construction staff."),
                  _buildQuestionAnswer("👕 How should it be stored?", "In a clean, dry area, away from contamination sources."),
                  _buildQuestionAnswer("👕 Can you wear regular clothes instead?", "No. Regular clothes don’t meet industrial protection standards."),
                  _buildQuestionAnswer("👕 What are the maintenance steps?", "Wash as per guidelines, inspect before use, and replace when damaged."),
                  _buildQuestionAnswer("👕 What is fitment in body PPE?", "It means the protective gear must not be too loose or too tight to interfere with work."),
                  _buildQuestionAnswer("👕 Who ensures PPE availability?", "The employer must supply PPE and train workers to use it correctly."),
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
