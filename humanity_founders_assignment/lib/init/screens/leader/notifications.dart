import 'package:flutter/material.dart';
import 'widgets/leader_bottom_nav.dart';

class LeaderNotifications extends StatefulWidget {
  const LeaderNotifications({super.key});

  @override
  State<LeaderNotifications> createState() => _LeaderNotificationsState();
}

class _LeaderNotificationsState extends State<LeaderNotifications> {
  String selectedTab = "All";

  final List<Map<String, dynamic>> notifications = [
    {
      "type": "prayer",
      "title": "New Prayer Request",
      "message": "John Doe submitted a prayer request for healing",
      "time": "5 min ago",
      "icon": Icons.favorite,
      "color": Colors.red,
      "unread": true,
    },
    {
      "type": "member",
      "title": "New Member Joined",
      "message": "Sarah Johnson just joined your community",
      "time": "1 hour ago",
      "icon": Icons.person_add,
      "color": Colors.blue,
      "unread": true,
    },
    {
      "type": "event",
      "title": "Event Registration",
      "message": "15 new registrations for Sunday Service",
      "time": "2 hours ago",
      "icon": Icons.event,
      "color": Colors.orange,
      "unread": false,
    },
    {
      "type": "donation",
      "title": "Donation Received",
      "message": "Anonymous donated \$100 to your community",
      "time": "3 hours ago",
      "icon": Icons.attach_money,
      "color": Colors.green,
      "unread": false,
    },
    {
      "type": "comment",
      "title": "New Comment",
      "message": "Michael Chen commented on your post",
      "time": "5 hours ago",
      "icon": Icons.comment,
      "color": Colors.purple,
      "unread": false,
    },
    {
      "type": "prayer",
      "title": "Prayer Update",
      "message": "Emily Rodriguez marked a prayer as answered",
      "time": "1 day ago",
      "icon": Icons.check_circle,
      "color": Colors.green,
      "unread": false,
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
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Mark all read",
              style: TextStyle(color: Colors.purple, fontSize: 14),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabChip("All", 23),
                  const SizedBox(width: 8),
                  _buildTabChip("Prayers", 8),
                  const SizedBox(width: 8),
                  _buildTabChip("Members", 5),
                  const SizedBox(width: 8),
                  _buildTabChip("Events", 6),
                  const SizedBox(width: 8),
                  _buildTabChip("Donations", 4),
                ],
              ),
            ),
          ),

          // Unread Badge
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.purple.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "You have 2 unread notifications",
                  style: TextStyle(color: Colors.purple.shade300, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Notifications List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return _buildNotificationCard(
                  notif["type"],
                  notif["title"],
                  notif["message"],
                  notif["time"],
                  notif["icon"],
                  notif["color"],
                  notif["unread"],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const LeaderBottomNav(currentIndex: 3),
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

  Widget _buildNotificationCard(
    String type,
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
    bool unread,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unread
            ? const Color(0xFF1A1A1A)
            : Colors.grey.shade900.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: unread
            ? Border.all(color: Colors.purple.withOpacity(0.3), width: 1)
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: unread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey.shade600,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
