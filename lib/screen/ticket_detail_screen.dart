import 'package:bip_frontend/model/event.dart';
import 'package:bip_frontend/model/ticket.dart';
import 'package:flutter/material.dart';

class TicketDetailScreen extends StatelessWidget {
  TicketDetailScreen({super.key, required this.ticket, required this.event});

  final Ticket ticket;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black, // Set the color of the back icon
        ),
        title: Text(
          "My ticket",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            foregroundImage: AssetImage('assets/selfie.jpg'),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TicketCard(event: event),
              const SizedBox(height: 20),
              QRCard(ticket: ticket),
              const SizedBox(height: 20),
              DownloadButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Event event;

  const TicketCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the card expand to fill the width
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title ?? 'Event Title',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 12),
              InfoRow(
                title: 'Name',
                content: 'Johnny Halliday',
              ), // Replace with user name if available
              InfoRow(
                title: 'Date',
                content:
                    event.startTime != null
                        ? '${event.startTime!.month.toString().padLeft(2, '0')}, ${event.startTime!.day} ${event.startTime!.year}'
                        : 'N/A',
              ),
              InfoRow(
                title: 'Schedule',
                content:
                    event.startTime != null && event.endTime != null
                        ? '${event.startTime!.hour}:${event.startTime!.minute.toString().padLeft(2, '0')} – ${event.endTime!.hour}:${event.endTime!.minute.toString().padLeft(2, '0')}'
                        : 'N/A',
              ),
              InfoRow(title: 'Location', content: event.location ?? 'N/A'),
            ],
          ),
        ),
      ),
    );
  }
}

class QRCard extends StatelessWidget {
  final Ticket ticket;

  const QRCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reservation number\n${ticket.reservationNumber ?? 'N/A'}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ticket.qrUrl != null && ticket.qrUrl!.isNotEmpty
                ? Image.network(ticket.qrUrl!, width: 120.0, height: 120.0, fit: BoxFit.cover)
                : const Text('QR Code not available'),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String content;

  const InfoRow({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          children: [
            TextSpan(text: '$title\n', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: content),
          ],
        ),
      ),
    );
  }
}

class DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.greenAccent.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        // Add download functionality here
      },
      child: const Text('DOWNLOAD', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
