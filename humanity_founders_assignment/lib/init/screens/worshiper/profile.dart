import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'widgets/bottom_nav.dart';

class WorshiperProfile extends StatelessWidget {
  const WorshiperProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          user?.displayName ?? "User Profile",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Profile Picture
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      user?.photoURL ?? "https://i.pravatar.cc/150?img=12",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              user?.displayName ?? "Worshiper Name",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            // Username/Email
            Text(
              "@${user?.email?.split('@')[0] ?? 'worshiper'}",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),

            const SizedBox(height: 20),

            // Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Faith is the strength by which a shattered world shall emerge into light 🙏",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat("127", "Posts"),
                  _buildDivider(),
                  _buildStat("2.4K", "Followers"),
                  _buildDivider(),
                  _buildStat("342", "Following"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildButton(
                      "Edit Profile",
                      Colors.grey.shade800,
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _buildButton(
                      "Share Profile",
                      Colors.grey.shade800,
                      Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildIconButton(
                    Icons.person_add_outlined,
                    Colors.grey.shade800,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tab Bar
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade800, width: 0.5),
                ),
              ),
              child: Row(
                children: [
                  _buildTab(Icons.grid_on, true),
                  _buildTab(Icons.video_collection_outlined, false),
                  _buildTab(Icons.bookmark_border, false),
                  _buildTab(Icons.person_pin_outlined, false),
                ],
              ),
            ),

            const SizedBox(height: 1),

            // Posts Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(1),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.shade900,
                  child: Image.network(
                    "https://picsum.photos/300/300?random=$index",
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const WorshiperBottomNav(currentIndex: 1),
    );
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade800);
  }

  Widget _buildButton(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, Color bg) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTab(IconData icon, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.white : Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey.shade600,
          size: 24,
        ),
      ),
    );
  }
}
