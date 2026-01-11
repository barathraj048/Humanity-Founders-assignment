class PrayerModel {
  final String id;
  final String title;
  final String description;
  final String requesterId;
  final String requesterName;
  final List<String> prayedBy;
  final int prayerCount;
  final bool isAnswered;
  final DateTime createdAt;

  PrayerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.requesterId,
    required this.requesterName,
    this.prayedBy = const [],
    this.prayerCount = 0,
    this.isAnswered = false,
    required this.createdAt,
  });

  factory PrayerModel.fromMap(Map<String, dynamic> map) {
    return PrayerModel(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      requesterId: map['requesterId'] ?? '',
      requesterName: map['requesterName'] ?? '',
      prayedBy: List<String>.from(map['prayedBy'] ?? []),
      prayerCount: map['prayerCount'] ?? 0,
      isAnswered: map['isAnswered'] ?? false,
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(
              map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'prayedBy': prayedBy,
      'prayerCount': prayerCount,
      'isAnswered': isAnswered,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
