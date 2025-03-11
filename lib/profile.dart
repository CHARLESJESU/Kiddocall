import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterappkideld/meetingpage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'landing_page.dart';
import 'main.dart';
import 'snakegame.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  int _selectedButtonIndex = 0;
  String assetpath = " ";
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
    _loadProfileImage();
  }

  void _initializePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setBool('isLandingPageFirstTime', false);
  }

  void _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }

  void _saveProfileImage(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath', path);
  }

  void _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
        _saveProfileImage(image.path); // Save the selected image path
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _playSimpleGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SnakeGamePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.black, size: 30),
                    onPressed: () async {
                      // Show confirmation dialog
                      bool shouldLogout = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Confirm Logout"),
                            content: Text("Are you sure you want to logout?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false); // Cancel logout
                                },
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true); // Confirm logout
                                },
                                child: Text("Confirm"),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldLogout == true) {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('isLoggedIn', false);
                        await prefs.setBool('isLandingPageFirstTime', true);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blueAccent,
                      backgroundImage: _profileImagePath != null
                          ? FileImage(File(_profileImagePath!))
                          : null,
                      child: _profileImagePath == null
                          ? Icon(
                        Icons.account_circle,
                        size: 70,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 24.0, color: Colors.black),
                    children: [
                      TextSpan(text: 'Hello '),
                      TextSpan(
                        text: globalName,
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: '!'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      _buildOptionCard(
                        icon: Icons.image,
                        label: 'View Image',
                        onTap: _pickImage,
                      ),
                      _buildOptionCard(
                        icon: Icons.gamepad,
                        label: 'Play Game',
                        onTap: _playSimpleGame,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              bool isSelected = index == _selectedButtonIndex;

              final buttonImages = [
                "assets/images/image 4.png",
                "assets/images/image 6.png",
              ];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedButtonIndex = index;
                  });
                  if (isSelected) {
                    assetpath = index == 0
                        ? "assets/talking.glb"
                        : "assets/doreamon.glb";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MeetingPage(assetpath: assetpath),
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isSelected ? 70 : 50,
                  height: isSelected ? 70 : 50,
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(buttonImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
