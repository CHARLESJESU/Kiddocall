import 'package:flutter/material.dart';

import 'package:flutterappkideld/landing_page.dart';
import 'package:flutterappkideld/landingpage2.dart';

class MeetingPage extends StatefulWidget {
  final String assetpath;
  const MeetingPage({super.key, required this.assetpath});

  @override
  _MeetingPageState createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  void _createNewMeeting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandingPage(assetpath: widget.assetpath),
      ),
    );
  }

  void _joinMeeting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandingPage3(assetpath: widget.assetpath),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '   Meeting Page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),

        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionCard(
                title: "Create New Meeting",
                icon: Icons.add,
                onTap: _createNewMeeting,
              ),
              SizedBox(height: 20),
              _buildActionCard(
                title: "Join the Meeting",
                icon: Icons.video_call,
                onTap: _joinMeeting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: 300,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.white),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
