import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cau2_HomeTab extends StatefulWidget {
  const Cau2_HomeTab({super.key});

  @override
  State<Cau2_HomeTab> createState() => _Cau2_HomeTabState();
}

class _Cau2_HomeTabState extends State<Cau2_HomeTab> {
  final _supabase = Supabase.instance.client;

  // This would ideally be passed from your Login process or retrieved from a global state
  // For now, replace 'SV001' with your test ID or a value stored during login
  final String _currentStudentId = 'SV001';

  Future<Map<String, dynamic>> _fetchStudentData() async {
    return await _supabase
        .from('SinhVien')
        .select()
        .eq('MaSV', _currentStudentId)
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
                  "Họ tên: ${student['HoTen']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Lớp: ${student['Lop']}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  "Chuyên ngành: ${student['ChuyenNganh']}",
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
