import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'widgets/leader_bottom_nav.dart';

class LeaderProfile extends StatelessWidget {
  const LeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          user?.displayName ?? "Leader Profile",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Header
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: NetworkImage(
                      user?.photoURL ?? "https://i.pravatar.cc/150?img=33",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 20),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Leader Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.purple, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.verified, color: Colors.purple, size: 16),
                  SizedBox(width: 6),
                  Text(
                    "Community Leader",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              user?.displayName ?? "Leader Name",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Organization
            Text(
              "Temple Beth Shalom",
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            // Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Serving our community with faith, love, and dedication. Together we grow stronger 🙏",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat("234", "Members"),
                  _buildDivider(),
                  _buildStat("48", "Events"),
                  _buildDivider(),
                  _buildStat("3.2K", "Prayers"),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      "Edit Profile",
                      Colors.purple,
                      Colors.white,
                      Icons.edit,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildButton(
                      "Share",
                      Colors.grey.shade800,
                      Colors.white,
                      Icons.share,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Management Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildManagementCard(
                    "Community Settings",
                    "Configure your community preferences",
                    Icons.settings_outlined,
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildManagementCard(
                    "Analytics",
                    "View engagement and growth metrics",
                    Icons.analytics_outlined,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildManagementCard(
                    "Roles & Permissions",
                    "Manage member roles and access",
                    Icons.admin_panel_settings_outlined,
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildManagementCard(
                    "Scheduled Posts",
                    "View and manage scheduled content",
                    Icons.schedule_outlined,
                    Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Account Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildAccountOption(
                    "Privacy & Security",
                    Icons.lock_outlined,
                  ),
                  _buildAccountOption(
                    "Notifications",
                    Icons.notifications_outlined,
                  ),
                  _buildAccountOption(
                    "Help & Support",
                    Icons.help_outline,
                  ),
                  _buildAccountOption(
                    "About FaithConnect",
                    Icons.info_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildLogoutButton(context),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const LeaderBottomNav(currentIndex: 4),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade800,
    );
  }

  Widget _buildButton(String text, Color bg, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade600,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOption(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade400, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade600,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await authService.signOut();
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3), width: 1),
        ),
        child: const Center(
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}