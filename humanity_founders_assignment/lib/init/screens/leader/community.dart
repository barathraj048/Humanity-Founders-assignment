import 'package:flutter/material.dart';
import 'widgets/leader_bottom_nav.dart';

class LeaderCommunity extends StatefulWidget {
  const LeaderCommunity({super.key});

  @override
  State<LeaderCommunity> createState() => _LeaderCommunityState();
}

class _LeaderCommunityState extends State<LeaderCommunity> {
  String selectedTab = "All";

  final List<Map<String, dynamic>> members = [
    {
      "name": "Sarah Johnson",
      "role": "Active Member",
      "avatar": "https://i.pravatar.cc/150?img=1",
      "joined": "2 months ago",
      "status": "online",
    },
    {
      "name": "Michael Chen",
      "role": "Volunteer",
      "avatar": "https://i.pravatar.cc/150?img=13",
      "joined": "5 months ago",
      "status": "offline",
    },
    {
      "name": "Emily Rodriguez",
      "role": "Active Member",
      "avatar": "https://i.pravatar.cc/150?img=5",
      "joined": "1 month ago",
      "status": "online",
    },
    {
      "name": "David Thompson",
      "role": "New Member",
      "avatar": "https://i.pravatar.cc/150?img=12",
      "joined": "1 week ago",
      "status": "offline",
    },
    {
      "name": "Jessica Martinez",
      "role": "Volunteer",
      "avatar": "https://i.pravatar.cc/150?img=9",
      "joined": "3 months ago",
      "status": "online",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Community",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildTabChip("All", 234),
                const SizedBox(width: 8),
                _buildTabChip("Active", 156),
                const SizedBox(width: 8),
                _buildTabChip("New", 12),
                const SizedBox(width: 8),
                _buildTabChip("Volunteers", 45),
              ],
            ),
          ),

          // Stats Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _buildMiniStat("234", "Total Members", Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat("89", "Online Now", Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMiniStat("12", "This Week", Colors.purple),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Members List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return _buildMemberCard(
                  member["name"],
                  member["role"],
                  member["avatar"],
                  member["joined"],
                  member["status"] == "online",
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.person_add),
        label: const Text("Add Member"),
      ),
      bottomNavigationBar: const LeaderBottomNav(currentIndex: 1),
    );
  }

  Widget _buildTabChip(String label, int count) {
    final isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(
    String name,
    String role,
    String avatar,
    String joined,
    bool isOnline,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(avatar)),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  "Joined $joined",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
