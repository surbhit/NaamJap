import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

class FirebaseService {
  static FirebaseDatabase? _database;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    try {
      _database = FirebaseDatabase.instance;
    } catch (error) {
      debugPrint('Realtime Database is not available: $error');
    }
  }

  static FirebaseDatabase get database {
    if (_database == null) {
      throw Exception(
        'Firebase not initialized. Call FirebaseService.initialize() first.',
      );
    }
    return _database!;
  }
}
