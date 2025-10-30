import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/api.dart';
import '../models/movie.dart';

class AuthResponse {
  final bool success;
  final String? token;
  final Map<String, dynamic>? user;
  final String? error;

  AuthResponse({this.success = false, this.token, this.user, this.error});
}

class ApiService {
  // Get movies data
  Future<List<Movie>> fetchMovies() async {
    try{
      // Default timeout 10s
      final response = await http.get(Uri.parse(ApiConfig.movies)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((item) => Movie.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load movies ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Lỗi API: $e");
      throw Exception('Không thể kết nối đến máy chủ');
    }
  }

  Future<AuthResponse> login(String userName, String password) async {
    try{
      final response = await http.post(
        Uri.parse(ApiConfig.auth),
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
        body: jsonEncode({
          'username': userName,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        debugPrint(data['token']);
        return AuthResponse(
          success: true,
          token: data['token'],
          user: data['user'],
        );
      } else {
        return AuthResponse(error: data['error'] ?? 'Đăng nhập thất bại');
      }
    } on TimeoutException {
      return AuthResponse(error: 'Hết thời gian kết nối. Vui lòng thử lại.');
    } on SocketException {
      return AuthResponse(error: 'Không có kết nối mạng.');
    } on FormatException {
      return AuthResponse(error: 'Dữ liệu từ server không hợp lệ.');
    } catch (e) {
      debugPrint("❌ Lỗi API: $e");
      return AuthResponse(error: 'Đã xảy ra lỗi. Vui lòng thử lại.');
    }
  }
}