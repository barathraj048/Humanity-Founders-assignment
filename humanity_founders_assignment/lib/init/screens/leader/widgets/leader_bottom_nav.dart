import 'package:flutter/material.dart';

class LeaderBottomNav extends StatelessWidget {
  final int currentIndex;
  const LeaderBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(color: Colors.grey.shade800, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavIcon(
                icon: Icons.home_rounded,
                label: "Home",
                isActive: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) {
                    Navigator.pushReplacementNamed(context, '/leader/home');
                  }
                },
              ),
              _NavIcon(
                icon: Icons.group_rounded,
                label: "Community",
                isActive: currentIndex == 1,
                onTap: () {
                  if (currentIndex != 1) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/leader/community',
                    );
                  }
                },
              ),
              _NavIcon(
                icon: Icons.add_circle,
                label: "Create",
                isActive: currentIndex == 2,
                isPrimary: true,
                onTap: () {
                  if (currentIndex != 2) {
                    Navigator.pushNamed(context, '/leader/create');
                  }
                },
              ),
              _NavIcon(
                icon: Icons.notifications_rounded,
                label: "Alerts",
                isActive: currentIndex == 3,
                onTap: () {
                  if (currentIndex != 3) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/leader/notifications',
                    );
                  }
                },
              ),
              _NavIcon(
                icon: Icons.person_rounded,
                label: "Profile",
                isActive: currentIndex == 4,
                onTap: () {
                  if (currentIndex != 4) {
                    Navigator.pushReplacementNamed(context, '/leader/profile');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isPrimary;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.isActive,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isPrimary ? 32 : 26,
              color: isPrimary
                  ? Colors.purple
                  : isActive
                  ? Colors.white
                  : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isPrimary
                    ? Colors.purple
                    : isActive
                    ? Colors.white
                    : Colors.grey.shade600,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
