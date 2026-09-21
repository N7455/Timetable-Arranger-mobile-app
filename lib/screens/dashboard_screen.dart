import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'manage_screen.dart';
import 'timetable_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const Color backgroundColor = Color(0xFF080808);
  static const Color cardColor = Color(0xFF151515);
  static const Color redColor = Color(0xFFE50914);
  static const Color borderColor = Color(0xFF292929);
  static const Color secondaryText = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Classes & Sections', Icons.school_rounded, 'classes'),
      ('Teachers', Icons.person_rounded, 'teachers'),
      ('Subjects', Icons.menu_book_rounded, 'subjects'),
      ('Rooms / Labs', Icons.meeting_room_rounded, 'rooms'),
      ('Time Slots', Icons.schedule_rounded, 'slots'),
    ];

    return Scaffold(
      backgroundColor: backgroundColor,

// ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome 👋',
              style: TextStyle(
                color: secondaryText,
                fontSize: 13,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Timetable Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor),
            ),
            child: IconButton(
              tooltip: 'Logout',
              onPressed: () async {
                await AuthService().signOut();

                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (_) => false,
                  );
                }
              },
              icon: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
          ),
        ],
      ),

// ---------------- BODY ----------------
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
// ---------------- GENERATE TIMETABLE HERO ----------------
            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimetableScreen(),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE50914),
                      Color(0xFF9B0008),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: redColor.withOpacity(0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Generate Timetable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Automatically arrange lectures',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

// ---------------- SETUP TITLE ----------------
            const Text(
              'Setup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Manage your timetable data',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 15),

// ---------------- SETUP CARDS ----------------
            ...items.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _setupCard(
                  context: context,
                  title: e.$1,
                  icon: e.$2,
                  collection: e.$3,
                ),
              ),
            ),

            const SizedBox(height: 15),

// ---------------- QUICK ACTION ----------------
            const Text(
              'Quick Action',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimetableScreen(),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: redColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.calendar_month_rounded,
                        color: redColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'View Timetable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Check your generated schedule',
                            style: TextStyle(
                              color: secondaryText,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

// ---------------- FOOTER ----------------
            const Center(
              child: Text(
                'Smart Schedule • Better Learning',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ============================================================
// SETUP CARD
// ============================================================

  static Widget _setupCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String collection,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ManageScreen(
            title: title,
            collection: collection,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Row(
          children: [
// ICON
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: redColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: redColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 15),

// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Add and manage data',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

// ARROW
            Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
