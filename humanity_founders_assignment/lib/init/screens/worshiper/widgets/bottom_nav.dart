import 'package:flutter/material.dart';
import '../profile.dart';

class WorshiperBottomNav extends StatelessWidget {
  final int currentIndex;
  const WorshiperBottomNav({super.key, required this.currentIndex});

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
                isActive: currentIndex == 0,
                onTap: () {
                  if (currentIndex != 0) {
                    Navigator.pop(context);
                  }
                },
              ),
              _NavIcon(
                icon: Icons.add_circle_outline,
                isActive: false,
                onTap: () {
                  // Create post action
                },
              ),
              _NavIcon(
                icon: Icons.forum_outlined,
                isActive: false,
                onTap: () {
                  // Messages action
                },
              ),
              _NavIcon(
                icon: Icons.favorite_outline,
                isActive: false,
                onTap: () {
                  // Activity/Likes action
                },
              ),
              _NavIcon(
                icon: Icons.person_outline,
                isActive: currentIndex == 1,
                onTap: () {
                  if (currentIndex != 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WorshiperProfile(),
                      ),
                    );
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
  final bool isActive;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 28,
          color: isActive ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}
