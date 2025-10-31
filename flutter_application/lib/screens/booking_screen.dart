import 'package:flutter/material.dart';
import 'package:flutter_application/config/app_routes.dart';
import 'package:flutter_application/models/ticket.dart';
import 'package:flutter_application/services/api_movie_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

import '../providers/auth_provider.dart';
import '../models/movie.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> seats = List.generate(
    40,
    (i) => '${String.fromCharCode(65 + (i ~/ 8))}${i % 8 + 1}',
  );

  Movie? _movie;
  Theater? selectedTheater;
  Showtime? selectedShowtime;
  final Set<String> selectedSeats = {};

  // Getter
  Movie get movie => _movie!;

  int get totalPrice {
    final price = selectedShowtime?.price ?? 0;
    return price * selectedSeats.length;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_movie == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Movie) {
        _movie = args;
        _initializeDefaultSelections();
      } else {
        // Nếu không có dữ liệu, chuyển về trang trước
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.pop(context);
        });
      }
    }
  }

  void _initializeDefaultSelections() {
    if (movie.theaters.isNotEmpty) {
      selectedTheater = movie.theaters[0];
      if (selectedTheater!.showtimes.isNotEmpty) {
        selectedShowtime = selectedTheater!.showtimes.first;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    // Check login
    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
      return const SizedBox.shrink();
    }

    if (_movie == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (movie.theaters.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đặt vé')),
        body: const Center(child: Text('Phim chưa có suất chiếu')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Đặt vé - ${movie.title}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownTheater(),
            const SizedBox(height: 16),
            if (selectedTheater?.showtimes.isNotEmpty == true)
              _buildShowtimes(),
            const SizedBox(height: 16),
            _buildSeatSelector(),
            _buildTotalSection(),
          ],
        ),
      ),
    );
  }

  /// Dropdown chọn rạp
  Widget _buildDropdownTheater() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Chọn rạp:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      DropdownButton<Theater>(
        isExpanded: true,
        value: selectedTheater,
        items: movie.theaters
            .map((t) => DropdownMenuItem(value: t, child: Text(t.theaterName)))
            .toList(),
        onChanged: (t) => setState(() {
          selectedTheater = t;
          selectedShowtime = t?.showtimes.isNotEmpty == true
              ? t!.showtimes.first
              : null;
          selectedSeats.clear();
        }),
      ),
    ],
  );

  /// Danh sách suất chiếu
  Widget _buildShowtimes() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Chọn suất chiếu:',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: selectedTheater!.showtimes
            .map(
              (s) => ChoiceChip(
                label: Text('${s.time} (${s.format}) - ${s.price}đ'),
                selected: selectedShowtime == s,
                onSelected: (_) => setState(() {
                  selectedShowtime = s;
                  selectedSeats.clear();
                }),
              ),
            )
            .toList(),
      ),
    ],
  );

  /// Lưới chọn ghế
  Widget _buildSeatSelector() => Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn ghế:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              childAspectRatio: 1.5,
            ),
            itemCount: seats.length,
            itemBuilder: (context, i) {
              final seat = seats[i];
              final isSelected = selectedSeats.contains(seat);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedSeats.remove(seat);
                    } else {
                      selectedSeats.add(seat);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.orange : Colors.grey[300],
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(0x66FFA500),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      seat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );

  /// Hiển thị tổng tiền và nút đặt vé
  Widget _buildTotalSection() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tổng tiền: $totalPriceđ',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: selectedSeats.isEmpty || selectedShowtime == null
              ? null
              : _confirmBooking,
          child: Text('Đặt vé (${selectedSeats.length} ghế)'),
        ),
      ],
    ),
  );

  void _confirmBooking() async {
    final auth = context.read<AuthProvider>();

    // Check login
    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
      return;
    }

    final ticket = Ticket(
      id: const Uuid().v4(),
      movieId: movie.id,
      movieTitle: movie.title,
      showtime: '${selectedShowtime!.time} (${selectedShowtime!.format})',
      seats: selectedSeats.toList(),
      bookingDate: DateTime.now(),
      qrCodeData: 'TICKET:${const Uuid().v4()}',
      theater: selectedTheater!.theaterName,
      price: totalPrice,
    );

    try {
      await ApiMovieService().bookTicket(token: auth.token!, ticket: ticket);
    } catch (e, st) {
      debugPrint('ERROR in _confirmBooking: $e');
      debugPrint('STACKTRACE:\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đặt vé thất bại: $e')),
      );
      return;
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đặt vé thành công!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: Center(
                child: QrImageView(
                  data: ticket.qrCodeData,
                  version: QrVersions.auto,
                  size: 150,
                ),
            ),
          ),
          const SizedBox(height: 12),
            Text('Mã vé: ${ticket.id.substring(0, 8)}...'),
            Text('Tổng: ${ticket.price}đ'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, AppRoutes.myTickets);
            },
            child: const Text('Xem vé'),
          ),
        ],
      ),
    );
  }
}
