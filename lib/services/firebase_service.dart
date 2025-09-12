import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../firebase_options.dart';

class FirebaseService {
  static FirebaseDatabase? _database;
  
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _database = FirebaseDatabase.instance;
  }
  
  static FirebaseDatabase get database {
    if (_database == null) {
      throw Exception('Firebase not initialized. Call FirebaseService.initialize() first.');
    }
    return _database!;
  }
}
