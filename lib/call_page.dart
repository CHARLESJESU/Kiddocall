
import 'package:flutter/material.dart';
import 'package:flutterappkideld/screenshotbutton.dart';
import 'package:screenshot/screenshot.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'audio_recorder.dart';

class CallPage extends StatefulWidget {
  const CallPage({
    Key? key,
    required this.callID,
    required this.userID,
    required this.username,
    required this.assetPath,
  }) : super(key: key);

  final String callID;
  final String userID;
  final String username;
  final String assetPath;

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  bool _showImageSelection = false;
  String _backgroundImage = "assets/images/back2.png";
  late AudioRecorder _audioRecorder;
  bool _isRecordingIconRed = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioRecorder.initializeRecorder(context).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing recorder: $error')),
      );
    });

    ZegoExpressEngine.instance
        .setVoiceChangerPreset(ZegoVoiceChangerPreset.MenToChild);
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  void _selectBackgroundImage(String imagePath) {
    setState(() {
      _backgroundImage = imagePath;
      _showImageSelection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: ActionButtons.screenshotController,

      child: Scaffold(


        body: Stack(
          children: [
            // ZegoUIKitPrebuiltCall widget (background layer)
            ZegoUIKitPrebuiltCall(
              appID:2109091868,
              appSign: "468b732323f208f44d688b0f994827d8640ca1b6d8dc7ceb4d9c5f2690633217",
              userID: widget.userID,
              userName: widget.username,
              callID: widget.callID,
              config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()..useSpeakerWhenJoining=true,
            ),

            // Background image
            Positioned.fill(
              child: Image.asset(
                _backgroundImage,
                fit: BoxFit.cover,
              ),
            ),


            // ModelViewer widget
            Positioned.fill(
              child: ModelViewer(
                src: widget.assetPath,
                autoPlay: true,
                cameraControls: false,
                autoRotate: false,
                disableZoom: true,
                scale: '2 2 2',
                animationName: 'default',
                backgroundColor: Colors.transparent,
              ),
            ),



            // Vertical buttons on the right side
            Positioned(
              top: 50,
              right: 20,
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.videocam, size: 30, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () async {
                      if (_audioRecorder.isRecording) {
                        // Stop Recording
                        await _audioRecorder.stopRecording(context);
                        setState(() {
                          _isRecordingIconRed = false;
                        });
                      } else {
                        // Start Recording
                        await _audioRecorder.startRecording();
                        setState(() {
                          _isRecordingIconRed = true;
                        });
                      }
                    },

                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon( _isRecordingIconRed ? Icons.stop : Icons.mic,
                        size: 30,
                        color: _isRecordingIconRed ? Colors.red : Colors.blue,),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      ActionButtons.takeScreenshot(context); // Add your screenshot logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, size: 30, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showImageSelection = !_showImageSelection;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add_photo_alternate, size: 30, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            // Background image selection
            if (_showImageSelection)
              Positioned(
                top: 200,
                left: 50,
                right: 50,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Select Background",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () => _selectBackgroundImage("assets/images/back1.png"),
                            child: Image.asset(
                              "assets/images/back1.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _selectBackgroundImage("assets/images/back2.png"),
                            child: Image.asset(
                              "assets/images/back2.png",
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // End Call Button
            Positioned(
              bottom: 30,
              right: MediaQuery.of(context).size.width / 2 - 40, // Center the button horizontally
              child: GestureDetector(
                onTap: () {
                  ZegoUIKit().leaveRoom(); // End the call
                  Navigator.of(context).pop(); // Navigate back to the previous screen
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Colors.blue, // Button background color
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.call_end, size: 40, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

