import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'call_page.dart';

import 'main.dart'; // Import your CallPage

class LandingPage3 extends StatefulWidget {
  final String assetpath;
  const LandingPage3({super.key, required this.assetpath});

  @override
  State<LandingPage3> createState() => _LandingPage3State();
}

class _LandingPage3State extends State<LandingPage3> {
  final TextEditingController callIdController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize the userId and userName fields with the globalName
    userIdController.text = "$globalName@123"; // Pre-fill userId
    userNameController.text = globalName; // Pre-fill userName
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Join a Call",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: callIdController,
                          hintText: "Invited Code",
                          icon: Icons.call,
                          isEditable: true,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: userIdController,
                          hintText: "User ID",
                          icon: Icons.person,
                          isEditable: false, // User ID is not editable
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: userNameController,
                          hintText: "Username",
                          icon: Icons.account_circle,
                          isEditable: false, // Username is not editable
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // if (widget.assetpath == '') {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => Elderpeoplecallpage(
                              //         callID: callIdController.text,
                              //         userID: userIdController.text,
                              //         username: userNameController.text,
                              //       ),
                              //     ),
                              //   );
                              // } else {
                                SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                                await prefs.setBool(
                                    'isLandingPageFirstTime', false);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CallPage(
                                      callID: callIdController.text,
                                      userID: userIdController.text,
                                      username: userNameController.text,
                                      assetPath: widget.assetpath,
                                    ),
                                  ),
                                );
                              }
                           // }
                          },
                          child: const Text(
                            "Join the Call",
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isEditable,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: !isEditable, // Make the field non-editable if isEditable is false
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        hintText: hintText,
        filled: true,
        fillColor: isEditable ? Colors.grey[200] : Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
    );
  }
}
