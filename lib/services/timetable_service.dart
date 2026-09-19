import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

class TimetableService {
  final FirestoreService fs = FirestoreService();

  static const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  Future<int> generate() async {
    final classes = await fs.col('classes').get();
    final subjects = await fs.col('subjects').get();
    final teachers = await fs.col('teachers').get();
    final rooms = await fs.col('rooms').get();
    final slots = await fs.col('slots').get();

    if (classes.docs.isEmpty || subjects.docs.isEmpty ||
        teachers.docs.isEmpty || rooms.docs.isEmpty || slots.docs.isEmpty) {
      throw Exception('Please add classes, subjects, teachers, rooms and slots first.');
    }

    await fs.col('timetable').get().then((s) async {
      for (final d in s.docs) {
        await d.reference.delete();
      }
    });

    final teacherIds = teachers.docs.map((d) => d.id).toList();
    final roomIds = rooms.docs.map((d) => d.id).toList();

    final List<Map<String, dynamic>> jobs = [];
    for (final c in classes.docs) {
      for (final s in subjects.docs) {
        final count = (s.data()['lecturesPerWeek'] ?? 1) as int;
        for (int i = 0; i < count; i++) {
          jobs.add({
            'classId': c.id,
            'className': c.data()['name'] ?? '',
            'section': c.data()['section'] ?? '',
            'subjectId': s.id,
            'subjectName': s.data()['name'] ?? '',
            'teacherId': s.data()['teacherId'] ?? teacherIds.first,
          });
        }
      }
    }

    final usedClass = <String>{};
    final usedTeacher = <String>{};
    final usedRoom = <String>{};
    int created = 0;

    for (final job in jobs) {
      bool placed = false;
      for (final slot in slots.docs) {
        final slotData = slot.data();
        final day = slotData['day'] ?? 'Monday';
        final time = slotData['time'] ?? '';
        final teacher = job['teacherId'] as String;
        for (final room in rooms.docs) {
          final classKey = '${job['classId']}|$day|$time';
          final teacherKey = '$teacher|$day|$time';
          final roomKey = '${room.id}|$day|$time';
          if (usedClass.contains(classKey) ||
              usedTeacher.contains(teacherKey) ||
              usedRoom.contains(roomKey)) {
            continue;
          }

          await fs.addItem('timetable', {
            'day': day,
            'time': time,
            'className': job['className'],
            'section': job['section'],
            'subjectName': job['subjectName'],
            'teacherId': teacher,
            'roomName': room.data()['name'] ?? '',
          });

          usedClass.add(classKey);
          usedTeacher.add(teacherKey);
          usedRoom.add(roomKey);
          created++;
          placed = true;
          break;
        }
        if (placed) break;
      }
    }
    return created;
  }
}
