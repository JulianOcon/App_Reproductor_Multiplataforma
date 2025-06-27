import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'video_list_screen.dart';
import 'mp3_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  final _pages = const [
    VideoListScreen(),
    Mp3ListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_current],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _current,
        onTap: (i) => setState(() => _current = i),
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video_outlined),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note_outlined),
            label: 'MP3',
          ),
        ],
      ),
    );
  }
}
