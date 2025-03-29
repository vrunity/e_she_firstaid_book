// Flutter page for Topic 9: Fall Protection
// Contains info cards, quiz, and completion logic

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FallProtectionPage extends StatefulWidget {
  @override
  _FallProtectionPageState createState() => _FallProtectionPageState();
}

class _FallProtectionPageState extends State<FallProtectionPage> {
  bool isCompleted = false;
  int quizScore = -1;
  bool hasTakenQuiz = false;
  Map<int, String> userAnswers = {};
  final String topicName = "FallProtection";

  final Map<int, String> correctAnswers = {
    1: "To prevent injuries or fatalities from falling",
    2: "Harnesses, guardrails, safety nets",
    3: "Before each use for wear, damage, and fit",
    4: "When working at height or near edges",
    5: "Employers and workers share responsibility",
  };

  final List<Map<String, dynamic>> quizQuestions = [
    {
      "question": "Why is fall protection necessary?",
      "options": [
        "To take breaks",
        "To prevent injuries or fatalities from falling",
        "To help climb faster",
        "To look cool"
      ]
    },
    {
      "question": "What equipment is used for fall protection?",
      "options": [
        "Safety boots",
        "Harnesses, guardrails, safety nets",
        "Sunglasses",
        "Knee pads"
      ]
    },
    {
      "question": "How often should fall PPE be inspected?",
      "options": [
        "Only when new",
        "Monthly",
        "Before each use for wear, damage, and fit",
        "Once a year"
      ]
    },
    {
      "question": "When must fall protection be used?",
      "options": [
        "Only in elevators",
        "When watching others work",
        "When working at height or near edges",
        "During training only"
      ]
    },
    {
      "question": "Who is responsible for fall safety?",
      "options": [
        "Only the company",
        "Employers and workers share responsibility",
        "Government",
        "Visitors"
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
              title: Text("Fall Protection Quiz"),
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
      appBar: AppBar(title: Text("Fall Protection")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionAnswer("🧗 What is fall protection?", "It includes safety systems and equipment that prevent workers from falling from heights or reduce injury if they do."),
                  _buildQuestionAnswer("🧗 Why is it important?", "Falls are one of the leading causes of worksite injuries and deaths."),
                  _buildQuestionAnswer("🧗 What are fall hazards?", "Unprotected edges, ladders, roofs, scaffolds, and open holes."),
                  _buildQuestionAnswer("🧗 What equipment is used?", "Harnesses, anchor points, guardrails, safety nets."),
                  _buildQuestionAnswer("🧗 How should PPE be selected?", "Based on height, work environment, and duration of work."),
                  _buildQuestionAnswer("🧗 What are key inspection points?", "Check webbing, buckles, lanyards, and anchor points for damage."),
                  _buildQuestionAnswer("🧗 Can fall gear be reused after a fall?", "No. It must be removed from service and inspected by a qualified person."),
                  _buildQuestionAnswer("🧗 Who trains workers in fall safety?", "Supervisors, safety officers, or certified trainers."),
                  _buildQuestionAnswer("🧗 How is a fall arrest system different from restraint?", "Fall arrest stops a fall; restraint prevents reaching the fall edge."),
                  _buildQuestionAnswer("🧗 When is fall protection required?", "Whenever working at 6 feet or more above a lower level."),
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
