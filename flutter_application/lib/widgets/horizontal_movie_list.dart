import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'package:flutter/gestures.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<Movie> movies;
  final String emptyMessage;

  const HorizontalMovieList({
    super.key,
    required this.movies,
    this.emptyMessage = 'Không có phim',
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(emptyMessage, textAlign: TextAlign.center),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse, // 👈 Cho phép cuộn bằng chuột
        },
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        physics: const AlwaysScrollableScrollPhysics(), // Cho phép cuộn mượt
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _MovieCard(movie: movies[index]);
        },
      ),
    );

    // return ListView.builder(
    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //   scrollDirection: Axis.horizontal,
    //   physics: const BouncingScrollPhysics(), // Cho phép cuộn mượt
    //   itemCount: movies.length,
    //   itemBuilder: (context, index) {
    //     return _MovieCard(movie: movies[index]);
    //   },
    // );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;
  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterUrl,
              height: 200,
              width: 140,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Icon(Icons.movie, size: 40),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(
            movie.genre.join(', '),
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ),
    );
  }
}