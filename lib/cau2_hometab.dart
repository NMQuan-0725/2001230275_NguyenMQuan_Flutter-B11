import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cau2HomeTab extends StatefulWidget {
  const Cau2HomeTab({super.key});

  @override
  State<Cau2HomeTab> createState() => _Cau2HomeTabState();
}

class _Cau2HomeTabState extends State<Cau2HomeTab> {
  final _supabase = Supabase.instance.client;
  final String _currentStudentId = 'SV001';

  Future<Map<String, dynamic>> _fetchStudentData() async {
    return await _supabase
        .from('sinhvien')
        .select()
        .eq('masv', _currentStudentId)
        .single();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin sinh viên")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchStudentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("Không tìm thấy dữ liệu sinh viên"),
            );
          }

          final student = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Họ tên: ${student['hoten']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Lớp: ${student['lop']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Chuyên ngành: ${student['chuyennganh']}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
