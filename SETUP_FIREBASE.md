# Firebase connection

This ZIP contains the complete Flutter app source, but Firebase configuration is unique to your Firebase project.

## Do this once

Install Firebase CLI and FlutterFire CLI:

    dart pub global activate flutterfire_cli

In this project folder:

    flutter pub get
    flutterfire configure

Choose your Firebase project and Android platform. FlutterFire will replace `lib/firebase_options.dart` with the correct configuration.

In Firebase Console:
1. Authentication -> Sign-in method -> enable Email/Password.
2. Firestore Database -> Create database.
3. Deploy the included rules:

    firebase deploy --only firestore:rules

Then run:

    flutter run

## Suggested test data

Classes:
- BCA 1st Year / A
- BCA 2nd Year / A

Teachers:
- Rahul
- Priya
- Amit

Subjects:
- Python / 4 lectures per week
- DBMS / 3 lectures per week
- Java / 3 lectures per week

Rooms:
- Room 101
- Computer Lab

Slots:
- Monday 09:00 - 10:00
- Monday 10:00 - 11:00
- Tuesday 09:00 - 10:00
- Tuesday 10:00 - 11:00
- Wednesday 09:00 - 10:00
- Wednesday 10:00 - 11:00

Note: For a real college deployment, the scheduling algorithm should also enforce teacher-subject mapping, teacher availability, maximum lectures/day, breaks, lab requirements, and stronger optimization.
