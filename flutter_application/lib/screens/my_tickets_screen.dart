import 'package:flutter/material.dart';
import 'package:flutter_application/config/app_routes.dart';
import 'package:flutter_application/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/api_movie_service.dart';
import '../models/ticket.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();

    final auth = context.read<AuthProvider>();
    final token = auth.token;

    _ticketsFuture = token != null
        ? ApiMovieService().getMyTickets(token)
        : Future.value([]);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    // Check login
    if (!auth.isLoggedIn) {
      final navigator = Navigator.of(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigator.pushReplacementNamed(AppRoutes.login);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Vé của tôi')),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Nếu lỗi 401 → token hết hạn → logout
            if (snapshot.error.toString().contains('401')) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                auth.logout();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              });
            }
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final tickets = snapshot.data ?? [];
          if (tickets.isEmpty) {
            return const Center(child: Text('Chưa có vé nào'));
          }

          return ListView.separated(
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => TicketCard(ticket: tickets[i]),
          );
        },
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    const styleTitle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticket.movieTitle, style: styleTitle),
            const SizedBox(height: 4),
            Text('Suất: ${ticket.showtime} - Ghế: ${ticket.seats.join(', ')}'),
            Text('Rạp: ${ticket.theater}'),
            Text('Tổng: ${ticket.price}đ'),
            Text('Ngày đặt: ${ticket.bookingDate.toString().substring(0, 16)}'),
            const SizedBox(height: 8),
            Center(
              child: Column(
                children: [
                  QrImageView(data: ticket.qrCodeData, size: 120),
                  const SizedBox(height: 4),
                  Text(
                    'Mã: ${ticket.id.substring(0, 8)}...',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}