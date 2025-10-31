class Ticket {
  final String id;
  final int movieId;
  final String movieTitle;
  final String showtime;
  final List<String> seats;
  final DateTime bookingDate;
  final String qrCodeData;
  final String theater;
  final int price;

  Ticket({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.showtime,
    required this.seats,
    required this.bookingDate,
    required this.qrCodeData,
    required this.theater,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'movieId': movieId,
    'movieTitle': movieTitle,
    'showtime': showtime,
    'seats': seats,
    'bookingDate': bookingDate.toIso8601String(),
    'qrCodeData': qrCodeData,
    'theater': theater,
    'price': price,
  };

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json['id'],
    movieId: json['movieId'],
    movieTitle: json['movieTitle'],
    showtime: json['showtime'],
    seats: List<String>.from(json['seats']),
    bookingDate: DateTime.parse(json['bookingDate']),
    qrCodeData: json['qrCodeData'],
    theater: json['theater'],
    price: json['price'],
  );
}
