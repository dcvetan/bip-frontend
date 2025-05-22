class Ticket {
  int? id;
  int? userId;
  int? eventId;
  String? reservationNumber;
  String? qrUrl;

  Ticket({this.id, this.userId, this.eventId, this.reservationNumber, this.qrUrl});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0; // Default to 0 if null
    eventId = json['event_id'] ?? 0; // Default to 0 if null
    userId = json['user_id'] ?? 0; // Default to 0 if null
    reservationNumber = json['reservation_number'] ?? ''; // Default to an empty string if null
    qrUrl = json['qr_url'] ?? ''; // Default to an empty string if null
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'event_id': eventId,
      'reservation_number': reservationNumber,
      'qr_url': qrUrl,
    };
  }
}
