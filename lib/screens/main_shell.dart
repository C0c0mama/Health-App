import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../services/notification_provider.dart';
import 'home/home_screen.dart';
import 'records/records_screen.dart';
import 'appointments/appointments_screen.dart';
import 'notifications/notifications_screen.dart';
import 'profile/profile_screen.dart';

// Tab index constants — use these everywhere instead of magic numbers
class TabIndex {
  static const int home = 0;
  static const int records = 1;
  static const int appointments = 2;
  static const int notifications = 3;
  static const int profile = 4;
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  // Switch to any tab from anywhere in the app
  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  // Build pages list dynamically so we can pass the callback to HomeScreen
  List<Widget> get _pages => [
    HomeScreen(onTabChange: _onTabChanged), // Home gets the callback
    const RecordsScreen(),
    const AppointmentsScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Consumer<NotificationProvider>(
        builder: (context, notifProvider, _) {
          return BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabChanged,
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.folder_outlined),
                activeIcon: Icon(Icons.folder_rounded),
                label: 'Records',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                activeIcon: Icon(Icons.calendar_month_rounded),
                label: 'Schedule',
              ),
              // Notifications tab with unread badge
              BottomNavigationBarItem(
                icon: _notifIcon(notifProvider, active: false),
                activeIcon: _notifIcon(notifProvider, active: true),
                label: 'Alerts',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }

  // Notification icon with unread badge
  Widget _notifIcon(NotificationProvider provider, {required bool active}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          active ? Icons.notifications_rounded : Icons.notifications_outlined,
        ),
        if (provider.unreadCount > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                provider.unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
