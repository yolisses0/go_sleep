import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayPage extends StatefulWidget {
  const OverlayPage({super.key});

  @override
  State<OverlayPage> createState() => _OverlayPageState();
}

class _OverlayPageState extends State<OverlayPage> {
  bool _hasOverlayPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await FlutterOverlayWindow.isPermissionGranted();
    setState(() => _hasOverlayPermission = hasPermission);
  }

  Future<void> requestOverlayPermission() async {
    if (!_hasOverlayPermission) {
      await FlutterOverlayWindow.requestPermission();
      await _checkPermission();
    } else {
      await _showOverlay();
    }
  }

  Future<void> _showOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      enableDrag: true,
      height: MediaQuery.of(context).size.height.toInt(),
      width: MediaQuery.of(context).size.width.toInt(),
      alignment: OverlayAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Time to sleep!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: requestOverlayPermission,
                child: Text(
                  _hasOverlayPermission
                      ? 'Show Overlay'
                      : 'Request Overlay Permission',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
