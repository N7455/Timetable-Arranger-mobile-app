import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class ManageScreen extends StatefulWidget {
  final String title;
  final String collection;
  const ManageScreen({super.key, required this.title, required this.collection});

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  final fs = FirestoreService();
  final name = TextEditingController();
  final section = TextEditingController();
  final extra = TextEditingController();

  String selectedDay = 'Monday';

  String get hint {
    switch (widget.collection) {
      case 'classes': return 'Class name e.g. BCA 1st Year';
      case 'teachers': return 'Teacher name';
      case 'subjects': return 'Subject name';
      case 'rooms': return 'Room/Lab name';
      case 'slots': return 'Time e.g. 09:00 - 10:00';
      default: return 'Name';
    }
  }

  Future<void> add() async {
    if (name.text.trim().isEmpty) return;
    final data = <String, dynamic>{'name': name.text.trim()};

    if (widget.collection == 'classes') {
      data['section'] = section.text.trim().isEmpty ? 'A' : section.text.trim();
    }
    if (widget.collection == 'subjects') {
      data['lecturesPerWeek'] = int.tryParse(extra.text.trim()) ?? 3;
      data['teacherId'] = '';
    }
    if (widget.collection == 'slots') {
      data['day'] = selectedDay;
      data['time'] = name.text.trim();
    }

    await fs.addItem(widget.collection, data);
    name.clear();
    section.clear();
    extra.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add ${widget.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(controller: name, decoration: InputDecoration(labelText: hint)),
                if (widget.collection == 'classes')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(controller: section, decoration: const InputDecoration(labelText: 'Section (A/B/C)')),
                  ),
                if (widget.collection == 'subjects')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: TextField(
                      controller: extra,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Lectures per week'),
                    ),
                  ),
                if (widget.collection == 'slots')
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: DropdownButtonFormField<String>(
                      value: selectedDay,
                      decoration: const InputDecoration(labelText: 'Day'),
                      items: ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
                          .map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                      onChanged: (v) => selectedDay = v ?? 'Monday',
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await add();
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: fs.stream(widget.collection),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('No data added yet.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final data = d.data();
              return Card(
                child: ListTile(
                  title: Text(data['name'] ?? data['subjectName'] ?? ''),
                  subtitle: Text([
                    if (data['section'] != null) 'Section: ${data['section']}',
                    if (data['lecturesPerWeek'] != null) 'Lectures/week: ${data['lecturesPerWeek']}',
                    if (data['day'] != null) '${data['day']} • ${data['time']}',
                  ].join('  ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => fs.deleteItem(widget.collection, d.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
