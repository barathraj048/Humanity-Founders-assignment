class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final String organizerId;
  final String? imageUrl;
  final List<String> attendees;
  final int attendeeCount;
  final int maxAttendees;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.organizerId,
    this.imageUrl,
    this.attendees = const [],
    this.attendeeCount = 0,
    this.maxAttendees = 0,
    required this.createdAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['_id'] ?? map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] is DateTime
          ? map['date']
          : DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      location: map['location'] ?? '',
      organizerId: map['organizerId'] ?? '',
      imageUrl: map['imageUrl'],
      attendees: List<String>.from(map['attendees'] ?? []),
      attendeeCount: map['attendeeCount'] ?? 0,
      maxAttendees: map['maxAttendees'] ?? 0,
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
      'date': date.toIso8601String(),
      'location': location,
      'organizerId': organizerId,
      'imageUrl': imageUrl,
      'attendees': attendees,
      'attendeeCount': attendeeCount,
      'maxAttendees': maxAttendees,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
