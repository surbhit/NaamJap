# Firebase Setup Instructions

This document explains how to set up Firebase Realtime Database for the events count feature.

## Prerequisites

1. A Firebase project
2. Firebase Realtime Database enabled
3. FlutterFire CLI installed (optional but recommended)

## Setup Steps

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Follow the setup wizard

### 2. Enable Realtime Database

1. In your Firebase project, go to "Realtime Database"
2. Click "Create Database"
3. Choose a location (preferably close to your users)
4. Start in test mode (you can secure it later)

### 3. Configure Firebase for Web

1. In Firebase Console, go to Project Settings (gear icon)
2. Scroll down to "Your apps" section
3. Click "Add app" and select the web icon (`</>`)
4. Register your app with a nickname
5. Copy the Firebase configuration object

### 4. Update Firebase Configuration

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'your-actual-web-api-key',
  appId: 'your-actual-web-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  authDomain: 'your-actual-project-id.firebaseapp.com',
  databaseURL: 'https://your-actual-project-id-default-rtdb.firebaseio.com',
  storageBucket: 'your-actual-project-id.appspot.com',
);
```

### 5. Set Up Database Structure

In your Firebase Realtime Database, create the following structure:

```json
{
  "events": {
    "event1": {
      "title": "Sample Event 1",
      "date": "2024-01-15",
      "description": "A spiritual gathering"
    },
    "event2": {
      "title": "Sample Event 2", 
      "date": "2024-01-20",
      "description": "Meditation workshop"
    }
  }
}
```

### 6. Configure Database Rules (Optional)

For production, update your database rules in Firebase Console:

```json
{
  "rules": {
    "events": {
      ".read": true,
      ".write": false
    }
  }
}
```

This allows anyone to read events but prevents writing (you can manage events through Firebase Console).

## Testing

1. Run `flutter pub get` to install dependencies
2. Run `flutter run -d chrome` to test the web version
3. The events count should display the number of events in your database

## Features

The events count feature includes:

- **Real-time count**: Displays the total number of events
- **Error handling**: Shows error messages if Firebase connection fails
- **Loading states**: Shows loading indicator while fetching data
- **Refresh functionality**: Manual refresh button to update count
- **Responsive design**: Works on all screen sizes

## Troubleshooting

### Common Issues

1. **"Firebase not initialized" error**: Make sure Firebase is properly configured
2. **"Permission denied" error**: Check your database rules
3. **Count shows 0**: Verify events exist in your database
4. **Network errors**: Check your internet connection and Firebase project status

### Debug Mode

To see detailed error messages, run in debug mode:
```bash
flutter run -d chrome --debug
```

## Security Considerations

- Never commit real Firebase configuration to version control
- Use environment variables for production
- Implement proper database rules
- Consider using Firebase Authentication for write operations
