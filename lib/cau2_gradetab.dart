import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Cau2_GradeTab extends StatefulWidget {
  const Cau2_GradeTab({super.key});

  @override
  _Cau2_GradeTabState createState() => _Cau2_GradeTabState();
}

class _Cau2_GradeTabState extends State<Cau2_GradeTab> {
  final _supabase = Supabase.instance.client;

  // Vietnamese Grading Logic [cite: 104]
  String getGradeLabel(double score) {
    if (score >= 9.5) return 'Xuất sắc';
    if (score >= 8.0) return 'Giỏi';
    if (score >= 6.5) return 'Khá';
    return 'Trung bình';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bảng Điểm")),
      body: FutureBuilder(
        // Replace 'KetQua' with your actual table name
        future: _supabase.from('KetQua').select('*, MonHoc(ten_mon)'),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final data = snapshot.data as List<dynamic>;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final double score = (item['diem'] as num)
                  .toDouble(); // Robust handling [cite: 110]

              return ListTile(
                title: Text(item['MonHoc']['ten_mon']),
                subtitle: Text("Điểm: $score - ${getGradeLabel(score)}"),
              );
            },
          );
        },
      ),
    );
  }
}
