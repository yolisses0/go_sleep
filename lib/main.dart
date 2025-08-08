import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:system_alert_window/system_alert_window.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class CustomOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('hello')));
  }
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: CustomOverlay()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isShowingWindow = false;
  bool _isUpdatedWindow = false;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  static const String _mainAppPort = 'MainApp';
  final _receivePort = ReceivePort();
  SendPort? homePort;
  String? latestMessageFromOverlay;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _requestPermissions();
    if (homePort != null) return;
    final res = IsolateNameServer.registerPortWithName(
      _receivePort.sendPort,
      _mainAppPort,
    );
    log("$res: OVERLAY");
    _receivePort.listen((message) {
      log("message from OVERLAY: $message");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    // await SystemAlertWindow.enableLogs(true);
    String? platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SystemAlertWindow.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (platformVersion != null)
      setState(() {
        _platformVersion = platformVersion!;
      });
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow() async {
    if (!_isShowingWindow) {
      await SystemAlertWindow.sendMessageToOverlay('show system window');
      SystemAlertWindow.showSystemWindow(
        height: 200,
        width: MediaQuery.of(context).size.width.floor(),
        gravity: SystemWindowGravity.CENTER,
        prefMode: prefMode,
        layoutParamFlags: [SystemWindowFlags.FLAG_NOT_FOCUSABLE],
      );
      setState(() {
        _isShowingWindow = true;
      });
    } else if (!_isUpdatedWindow) {
      await SystemAlertWindow.sendMessageToOverlay('update system window');
      SystemAlertWindow.updateSystemWindow(
        height: 200,
        width: MediaQuery.of(context).size.width.floor(),
        gravity: SystemWindowGravity.CENTER,
        prefMode: prefMode,
        layoutParamFlags: [
          SystemWindowFlags.FLAG_NOT_FOCUSABLE,
          SystemWindowFlags.FLAG_NOT_TOUCHABLE,
        ],
        // isDisableClicks: true
      );
      setState(() {
        _isUpdatedWindow = true;
        SystemAlertWindow.sendMessageToOverlay(_isUpdatedWindow);
      });
    } else {
      setState(() {
        _isShowingWindow = false;
        _isUpdatedWindow = false;
        SystemAlertWindow.sendMessageToOverlay(_isUpdatedWindow);
      });
      SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'System Alert Window Example App \n with flutterview',
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: _showOverlayWindow,
                  child: !_isShowingWindow
                      ? Text("Show system alert window")
                      : !_isUpdatedWindow
                      ? Text("Update system alert window")
                      : Text("Close system alert window"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () => SystemAlertWindow.sendMessageToOverlay(
                    "message from main",
                  ),
                  child: Text("send message to overlay"),
                ),
              ),
              TextButton(
                onPressed: () async {
                  String? logFilePath = await SystemAlertWindow.getLogFile;
                  if (logFilePath != null && logFilePath.isNotEmpty) {
                    // final files = <XFile>[];
                    // files.add(XFile(logFilePath, name: "Log File from SAW"));
                    // await Share.shareXFiles(files);
                  } else {
                    print("Path is empty");
                  }
                },
                child: Text("Share Log file"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
