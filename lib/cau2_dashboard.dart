import 'package:flutter/material.dart';
import 'cau2_hometab.dart';
import 'cau2_subjecttab.dart';
import 'cau2_gradetab.dart';

class Cau2Dashboard extends StatefulWidget {
  const Cau2Dashboard({super.key});

  @override
  State<Cau2Dashboard> createState() => _Cau2DashboardState();
}

class _Cau2DashboardState extends State<Cau2Dashboard> {
  int _selectedIndex = 0;

    final List<Widget> _pages = [
      const Cau2HomeTab(),
      const Cau2SubjectTab(),
      const Cau2GradeTab(),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chu'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mon hoc'),
          BottomNavigationBarItem(icon: Icon(Icons.grade), label: 'Diem so'),
        ],
      ),
    );
  }
}
