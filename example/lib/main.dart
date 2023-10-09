import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_crash_plugin/flutter_crash_plugin.dart';
import 'dart:io';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

/// Reports [error] along with its [stackTrace] to Sentry.io.
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');

  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Bugly.');
    return;
  }

  print('Reporting to Bugly...');

  FlutterCrashPlugin.postException(error, stackTrace);
}

Future<Null> main() async {
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stack) async {
    await _reportError(error, stack);
  });
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      FlutterCrashPlugin.setAppId('xxxx');
    } else if (Platform.isIOS) {
      FlutterCrashPlugin.setAppId('zzzzz');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crashy'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Dart exception'),
              onPressed: () {
                throw StateError('This is a Dart exception.');
              },
            ),
            ElevatedButton(
              child: Text('async Dart exception'),
              onPressed: () async {
                foo() async {
                  throw StateError('This is an async Dart exception.');
                }

                bar() async {
                  await foo();
                }

                await bar();
              },
            )
          ],
        ),
      ),
    );
  }
}
