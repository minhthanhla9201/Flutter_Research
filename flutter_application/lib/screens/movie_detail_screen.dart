import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Căn giữa tiêu đề
        elevation: 0, // Loại bỏ bóng của AppBar
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // Cải thiện cảm giác cuộn
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh banner
            _buildBanner(context, movie),
            // Nội dung chi tiết
            _buildMovieDetails(context, movie),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context, Movie movie) {
    return Hero(
      tag: "movie_${movie.id}",
      child: Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _getImageProvider(movie),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) => const Icon(Icons.broken_image),
          ),
        ),
        child: _buildGradientOverlay(),
      ),
    );
  }

  ImageProvider _getImageProvider(Movie movie) {
    final isLocal = movie.bannerUrl.startsWith('assets/');
    return isLocal ? AssetImage(movie.bannerUrl) : NetworkImage(movie.bannerUrl);
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(0, 0, 0, 0.6), // Thay Colors.black.withOpacity(0.6)
            Colors.transparent,
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 2.0,
                  color: Colors.black54,
                  offset: Offset(1.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Thông tin cơ bản
          _buildMovieInfo(movie),
          const SizedBox(height: 10),
          // Ngày phát hành
          _buildReleaseDate(movie),
          const SizedBox(height: 16),
          // Mô tả phim
          _buildSynopsis(movie),
          const SizedBox(height: 20),
          // Danh sách rạp & suất chiếu
          _buildTheaterList(movie),
        ],
      ),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return Row(
      children: [
        Expanded(
          child: Text(
            movie.genre.join(", "),
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          "${movie.duration} phút",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            movie.rating,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReleaseDate(Movie movie) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Text(
          "Khởi chiếu: ${movie.releaseDate}",
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildSynopsis(Movie movie) {
    return Text(
      movie.synopsis,
      style: const TextStyle(
        fontSize: 15,
        height: 1.4,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTheaterList(Movie movie) {
    if (movie.theaters.isEmpty) {
      return const Center(
        child: Text(
          "Hiện chưa có lịch chiếu",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Rạp đang chiếu:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...movie.theaters.map((theater) => _buildTheaterCard(theater)),
      ],
    );
  }

  Widget _buildTheaterCard(Theater theater) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              theater.theaterName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: theater.showtimes.map((show) {
                return Chip(
                  label: Text(
                    "${show.time} (${show.format})",
                    style: const TextStyle(fontSize: 13),
                  ),
                  backgroundColor: Colors.grey[200],
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
