import 'package:flutter/material.dart';
import '../services/timetable_service.dart';
import '../services/firestore_service.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});
  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final service = TimetableService();
  final fs = FirestoreService();
  bool generating = false;

  Future<void> generate() async {
    setState(() => generating = true);
    try {
      final count = await service.generate();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$count lectures arranged successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => generating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Timetable'),
        actions: [
          IconButton(
            onPressed: generating ? null : generate,
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Generate',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: generating ? null : generate,
                icon: generating
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_awesome),
                label: Text(generating ? 'Generating...' : 'Generate Timetable'),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: fs.stream('timetable'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return const Center(child: Text('Generate a timetable to see results.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final d = docs[i];
                    final x = d.data();
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.calendar_today, color: Colors.redAccent),
                        title: Text('${x['subjectName']} • ${x['className']} ${x['section']}'),
                        subtitle: Text('${x['day']}  |  ${x['time']}  |  Room: ${x['roomName']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => fs.deleteItem('timetable', d.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
