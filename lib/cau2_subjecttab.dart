import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cau2_SubjectTab extends StatefulWidget {
  const Cau2_SubjectTab({super.key});

  @override
  State<Cau2_SubjectTab> createState() => _Cau2_SubjectTabState();
}

class _Cau2_SubjectTabState extends State<Cau2_SubjectTab> {
  final _supabase = Supabase.instance.client;

  // Method to Add a subject
  Future<void> _addSubject(
    String code,
    String name,
    int credits,
    String room,
  ) async {
    await _supabase.from('MonHoc').insert({
      'MaMonHoc': code,
      'TenMonHoc': name,
      'SoTinChi': credits,
      'PhongHoc': room,
    });
    setState(() {}); // Refresh list
  }

  // Method to Delete a subject
  Future<void> _deleteSubject(String code) async {
    await _supabase.from('MonHoc').delete().eq('MaMonHoc', code);
    setState(() {}); // Refresh list
  }

  // Dialog to get new subject info
  void _showAddDialog() {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thêm môn học"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeCtrl,
              decoration: const InputDecoration(labelText: "Mã môn"),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Tên môn"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              _addSubject(
                codeCtrl.text,
                nameCtrl.text,
                3,
                "Phòng A1",
              ); // Default values for example
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý môn học")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _supabase.from('MonHoc').select(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final subjects = snapshot.data!;
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {
              final sub = subjects[index];
              return ListTile(
                title: Text(sub['TenMonHoc']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSubject(sub['MaMonHoc']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
