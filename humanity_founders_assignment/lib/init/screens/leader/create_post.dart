import 'package:flutter/material.dart';

class LeaderCreatePost extends StatefulWidget {
  const LeaderCreatePost({super.key});

  @override
  State<LeaderCreatePost> createState() => _LeaderCreatePostState();
}

class _LeaderCreatePostState extends State<LeaderCreatePost> {
  String selectedType = "Post";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Create",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Publish",
              style: TextStyle(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type Selector
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  _buildTypeChip("Post", Icons.article_outlined),
                  const SizedBox(width: 8),
                  _buildTypeChip("Event", Icons.event_outlined),
                  const SizedBox(width: 8),
                  _buildTypeChip("Prayer", Icons.favorite_outline),
                  const SizedBox(width: 8),
                  _buildTypeChip("Announcement", Icons.campaign_outlined),
                ],
              ),
            ),

            // Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Add a title...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content Field
                  TextField(
                    controller: _contentController,
                    style: TextStyle(color: Colors.grey.shade300, fontSize: 16),
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Share your message with the community...",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Add Media
                  _buildMediaSection(),

                  const SizedBox(height: 24),

                  // Additional Options (if Event)
                  if (selectedType == "Event") _buildEventOptions(),

                  // Additional Options (if Announcement)
                  if (selectedType == "Announcement")
                    _buildAnnouncementOptions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, IconData icon) {
    final isSelected = selectedType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade500,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Media",
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildMediaButton(Icons.image_outlined, "Photo"),
            const SizedBox(width: 12),
            _buildMediaButton(Icons.videocam_outlined, "Video"),
            const SizedBox(width: 12),
            _buildMediaButton(Icons.gif_box_outlined, "GIF"),
          ],
        ),
      ],
    );
  }

  Widget _buildMediaButton(IconData icon, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade800, width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.grey.shade400, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xFF2A2A2A), height: 32),
        Text(
          "Event Details",
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildOptionTile(Icons.calendar_today, "Date & Time", "Select date"),
        const SizedBox(height: 12),
        _buildOptionTile(Icons.location_on, "Location", "Add location"),
        const SizedBox(height: 12),
        _buildOptionTile(Icons.people, "Max Attendees", "Set limit"),
        const SizedBox(height: 12),
        _buildOptionTile(Icons.attach_money, "Entry Fee", "Optional"),
      ],
    );
  }

  Widget _buildAnnouncementOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Color(0xFF2A2A2A), height: 32),
        Text(
          "Notification Settings",
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildSwitchTile("Send Push Notification", true),
        const SizedBox(height: 12),
        _buildSwitchTile("Pin to Top", false),
        const SizedBox(height: 12),
        _buildOptionTile(Icons.schedule, "Schedule", "Post immediately"),
      ],
    );
  }

  Widget _buildOptionTile(IconData icon, String title, String subtitle) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.purple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(value: value, onChanged: (val) {}, activeColor: Colors.purple),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
