import 'firebase_service.dart';

class EventsService {
  static const String _eventsPath = 'events';
  
  /// Fetches the total count of events from Firebase Realtime Database
  static Future<int> getEventsCount() async {
    try {
      final database = FirebaseService.database;
      final snapshot = await database.ref(_eventsPath).get();
      
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return data.length;
        } else if (data is int) {
          return data;
        }
      }
      return 0;
    } catch (e) {
      print('Error fetching events count: $e');
      return 0;
    }
  }
  
  /// Listens to real-time updates of events count
  static Stream<int> getEventsCountStream() {
    final database = FirebaseService.database;
    return database.ref(_eventsPath).onValue.map((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value;
        if (data is Map) {
          return data.length;
        } else if (data is int) {
          return data;
        }
      }
      return 0;
    });
  }
  
  /// Fetches specific event details by ID
  static Future<Map<String, dynamic>?> getEventById(String eventId) async {
    try {
      final database = FirebaseService.database;
      final snapshot = await database.ref('$_eventsPath/$eventId').get();
      
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return Map<String, dynamic>.from(data);
        }
      }
      return null;
    } catch (e) {
      print('Error fetching event by ID: $e');
      return null;
    }
  }
  
  /// Gets all events as a list
  static Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      final database = FirebaseService.database;
      final snapshot = await database.ref(_eventsPath).get();
      
      if (snapshot.exists) {
        final data = snapshot.value;
        if (data is Map) {
          return data.entries.map((entry) {
            final eventData = entry.value;
            if (eventData is Map) {
              return Map<String, dynamic>.from(eventData)..['id'] = entry.key;
            }
            return {'id': entry.key, 'data': eventData};
          }).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error fetching all events: $e');
      return [];
    }
  }
}
