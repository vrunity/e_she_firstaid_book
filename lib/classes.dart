import 'package:e_she_book/topics/body_protection.dart';
import 'package:e_she_book/topics/eye_protection.dart';
import 'package:e_she_book/topics/fall_protection.dart';
import 'package:e_she_book/topics/foot_protection.dart';
import 'package:e_she_book/topics/hand_protection.dart';
import 'package:e_she_book/topics/head_protection.dart';
import 'package:e_she_book/topics/ppe_intro.dart';
import 'package:e_she_book/topics/respiratory_protection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_she_book/welcome.dart';
import 'certificate_page.dart';

class ClassPage extends StatefulWidget {
  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  Map<String, dynamic> topicProgress = {};
  bool allTopicsCompleted = false;
  String userName = "";

  final List<Map<String, dynamic>> topics = [
    {"title": "Introduction to PPE", "page": IntroductionToPPEPage(), "key": "IntroductionToPPE"},
    {"title": "Head Protection", "page": HeadProtectionPage(), "key": "HeadProtection"},
    {"title": "Eye Protection", "page": EyeProtectionPage(), "key": "EyeProtectionPage"},
    {"title": "Hand Protection", "page": HandProtectionPage(), "key": "HandProtectionPage"},
    {"title": "Respiratory Protection ", "page": RespiratoryProtectionPage(), "key": "RespiratoryProtectionPage"},
    {"title": "Foot Protection", "page": FootProtectionPage(), "key": "FootProtectionPage"},
    {"title": "Body Protection", "page": BodyProtectionPage(), "key": "BodyProtectionPage"},
    {"title": "Fall Protection", "page": FallProtectionPage(), "key": "FallProtectionPage"},
  ];

  @override
  void initState() {
    super.initState();
    _loadTopicProgress();
  }

  Future<void> _loadTopicProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> progress = {};
    bool allCompleted = true;

    for (var topic in topics) {
      String key = topic["key"];
      bool isCompleted = prefs.getBool('Completed_$key') ?? false;
      int quizScore = prefs.getInt('QuizScore_$key') ?? -1;

      progress[key] = {"completed": isCompleted, "score": quizScore};

      if (!isCompleted || quizScore < 0) {
        allCompleted = false;
      }
    }

    String storedUserName = prefs.getString('user_name') ?? "User";

    setState(() {
      topicProgress = progress;
      allTopicsCompleted = allCompleted;
      userName = storedUserName;
    });
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Welcome()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15),

          // 🔥 Progress Bar
          _buildProgressBar(),

          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: topics.map((topic) {
                String key = topic["key"];
                bool isCompleted = topicProgress[key]?["completed"] ?? false;
                int quizScore = topicProgress[key]?["score"] ?? -1;

                return _buildTopicCard(context, topic["title"], topic["page"], isCompleted, quizScore, key);
              }).toList(),
            ),
          ),
          if (allTopicsCompleted)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CertificatePage(userName: userName, topicProgress: topicProgress)),
                  );
                },
                child: Text("Generate Certificate"),
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Progress Bar Widget
  Widget _buildProgressBar() {
    int completedTopics = topicProgress.values.where((topic) => topic["completed"] == true).length;
    int totalTopics = topics.length;
    double progress = completedTopics / totalTopics;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress: $completedTopics / $totalTopics",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: Colors.deepOrange,
              minHeight: 12,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, String title, Widget page, bool isCompleted, int quizScore, String key) {
    String statusText;
    Color statusColor;

    if (quizScore >= 0) {
      statusText = "Score: $quizScore / 5 ✅";
      statusColor = Colors.green;
    } else if (isCompleted) {
      statusText = "✔ Completed";
      statusColor = Colors.blue;
    } else {
      statusText = "🔴 Not Completed";
      statusColor = Colors.red;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          ).then((_) {
            _loadTopicProgress();
          });
        },
      ),
    );
  }
}
