import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Réactivité immédiate du détecteur de visibilité (pas de throttling)
  VisibilityDetectorController.instance.updateInterval = Duration.zero;
  await Firebase.initializeApp();
  runApp(const App());
}
