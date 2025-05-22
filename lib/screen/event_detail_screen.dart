import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/event.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({required this.event, Key? key}) : super(key: key);

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetailScreen> {
  int _participantsController = 1;
  bool _isLoading = false;

  Future<void> _reserveTicket() async {
    if (widget.event.ticketsAvailable == 0) {
      return; // Do nothing if no tickets are available
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    final url = Uri.parse('https://bip-backend-b1ew.onrender.com/ticket');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'event_id': widget.event.id, 'user_id': 7}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reservation successful! Check your email or tickets page.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to reserve ticket. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please check your connection.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E0E0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
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
        child: Card(
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  widget.event.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.event.title!,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.favorite_border, color: Colors.green),
                            SizedBox(width: 8),
                            Icon(Icons.share, color: Colors.grey),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Description
                    Text(widget.event.description!, style: TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price Box
                    Container(
                      width: 130,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text('Price', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.all(13),
                            child: Text(
                              '${widget.event.price!} €',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Participants Box
                    Container(
                      width: 130,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Participants',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          DropdownButton<int>(
                            value: _participantsController,
                            onChanged: (int? newValue) {
                              setState(() {
                                _participantsController = newValue!;
                              });
                            },
                            items: List.generate(
                              10,
                              (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Reserved Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color:
                      widget.event.ticketsAvailable == 0 || _isLoading
                          ? Colors.grey
                          : Color(0xFF4BE78D),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: InkWell(
                  onTap: widget.event.ticketsAvailable == 0 || _isLoading ? null : _reserveTicket,
                  child: Center(
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                            : Text(
                              widget.event.ticketsAvailable == 0 ? 'RESERVED' : 'RESERVE',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
