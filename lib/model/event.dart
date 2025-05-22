class Event {
  int? id;
  String? title;
  String? description;
  String? location;
  int? price;
  int? ticketsAvailable;
  DateTime? startTime;
  DateTime? endTime;
  String? imageUrl;

  Event({
    this.id,
    this.title,
    this.description,
    this.location,
    this.price,
    this.ticketsAvailable,
    this.startTime,
    this.endTime,
    this.imageUrl,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] ?? ''; // Default to an empty string if null
    description = json['description'] ?? '';
    location = json['location'] ?? '';
    price = json['price'];
    ticketsAvailable = json['tickets_available'];
    startTime = json['start_date'] != null ? DateTime.parse(json['start_date']) : null;
    endTime = json['end_date'] != null ? DateTime.parse(json['end_date']) : null;
    imageUrl = json['image_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'price': price,
      'tickets_available': ticketsAvailable,
      'start_date': startTime?.toIso8601String(),
      'end_date': endTime?.toIso8601String(),
      'image_url': imageUrl,
    };
  }
}
