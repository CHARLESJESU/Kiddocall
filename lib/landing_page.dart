import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart'; // For clipboard
import 'package:share_plus/share_plus.dart'; // For sharing
import 'call_page.dart';
// Import your CallPage
import 'dart:math';

import 'main.dart'; // For generating random Call ID

class LandingPage extends StatefulWidget {
  final String assetpath;
  const LandingPage({super.key, required this.assetpath});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final TextEditingController callIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateCallId();
  }

  void _generateCallId() {
    callIdController.text = (Random().nextInt(900000) + 100000).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Create a Call",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildReadOnlyField(
                        controller: callIdController,
                        hintText: "Generated Call ID",
                        icon: Icons.call,
                        copyCallback: () {
                          Clipboard.setData(ClipboardData(text: callIdController.text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Call ID copied to clipboard!")),
                          );
                        },
                        shareCallback: () {
                          Share.share("Join my call using Call ID: ${callIdController.text}");
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildReadOnlyFieldWithoutActions(
                        hintText: "User ID",
                        value: "$globalName@123",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      _buildReadOnlyFieldWithoutActions(
                        hintText: "Username",
                        value: globalName,
                        icon: Icons.account_circle,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E88E5),
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          // if (widget.assetpath == '') {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => Elderpeoplecallpage(
                          //         callID: callIdController.text,
                          //         userID: globalName,
                          //         username: globalName,
                          //       ),
                          //     ),
                          //   );
                          // } else {
                            await prefs.setBool('isLandingPageFirstTime', false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallPage(
                                  callID: callIdController.text,
                                  userID: "$globalName@123",
                                  username: globalName,
                                  assetPath: widget.assetpath,
                                ),
                              ),
                            );
                        //  }
                      },
                        child: const Text(
                          "Create Meet",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required VoidCallback copyCallback,
    required VoidCallback shareCallback,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.blueAccent),
              hintText: hintText,
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.blueAccent),
          onPressed: copyCallback,
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.blueAccent),
          onPressed: shareCallback,
        ),
      ],
    );
  }

  Widget _buildReadOnlyFieldWithoutActions({
    required String hintText,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }
}
