import 'dart:async';
import 'dart:convert';
import 'package:flutter_application/models/ticket.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/api.dart';
import '../models/movie.dart';

class ApiMovieService {
  // Get movies data
  Future<List<Movie>> fetchMovies() async {
    try{
      // Default timeout 10s
      final response = await http.get(Uri.parse(ApiConfig.movies)).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load movies ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Lỗi API: $e");
      throw Exception('Lấy dữ liệu từ máy chủ thất bại');
    }
  }

  Future<List<Ticket>> getMyTickets(String token) async {
    try{
      final response = await http.get(
        Uri.parse(ApiConfig.myTickets),
        headers: {'Authorization': 'Bearer $token'},
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List).map((e) => Ticket.fromJson(e)).toList();
      } throw Exception('Failed to load tickets ${response.statusCode}');
    } catch (e) {
      debugPrint("❌ Lỗi API: $e");
      throw Exception('Lấy dữ liệu từ máy chủ thất bại');
    }
  }

  Future<Ticket> bookTicket({
    required String token,
    required Ticket ticket
  }) async {
    final response = await http.post(
      Uri.parse(ApiConfig.bookTicket),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'movieId': ticket.movieId,
        'movieTitle': ticket.movieTitle,
        'showtime': ticket.showtime,
        'seats': ticket.seats,
        'theater': ticket.theater,
        'price': ticket.price,
      }),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      return Ticket.fromJson(jsonDecode(response.body)['ticket']);
    }
    throw Exception('Đặt vé thất bại');
  }
}