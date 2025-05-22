import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/event.dart';
import '../model/ticket.dart';
import 'ticket_detail_screen.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  _TicketScreenState createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  List<Ticket> tickets = [];
  List<Event> events = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    final url = Uri.parse('https://bip-backend-b1ew.onrender.com/ticket?userId=7');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            tickets = data.map((json) => Ticket.fromJson(json)).toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load tickets. Please try again.';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred. Please check your connection.';
          isLoading = false;
        });
      }
    }

    final url2 = Uri.parse('https://bip-backend-b1ew.onrender.com/event');
    try {
      final response = await http.get(url2);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            events = data.map((json) => Event.fromJson(json)).toList();
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load events. Please try again.';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'An error occurred. Please check your connection.';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "My tickets",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        actions: const [
          CircleAvatar(
            backgroundColor: Colors.grey,
            foregroundImage: AssetImage('assets/selfie.jpg'),
          ),
          SizedBox(width: 12),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)))
              : ListView(
                padding: const EdgeInsets.all(16),
                children:
                    tickets.map((ticket) {
                      final event = events.firstWhere(
                        (event) => event.id == ticket.eventId,
                        orElse:
                            () => Event(
                              id: ticket.eventId,
                              title: "Unknown Event",
                              description: "No description available.",
                              location: "Unknown",
                              price: 0,
                              ticketsAvailable: 0,
                              startTime: DateTime.now(),
                              endTime: DateTime.now(),
                              imageUrl: 'assets/placeholder.png',
                            ),
                      );
                      return _TicketCard(ticket: ticket, event: event);
                    }).toList(),
              ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Ticket ticket;
  final Event event;

  const _TicketCard({required this.ticket, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TicketDetailScreen(ticket: ticket, event: event)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(event.imageUrl!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          event.title!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
