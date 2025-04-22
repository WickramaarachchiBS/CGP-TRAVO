class Bookmarks {
  final String name;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String desc;
  final String userId;

  Bookmarks({
    required this.name,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.desc,
    required this.userId,
  });

  factory Bookmarks.fromFirestore(Map<String, dynamic> data) {
    return Bookmarks(
      name: data['name'] ?? '',
      imagePath: data['imagePath'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      desc: data['desc'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'desc': desc,
      'userId': userId,
    };
  }
}
