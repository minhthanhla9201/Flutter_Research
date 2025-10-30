import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import '../models/movie.dart';

class MovieBannerSlider extends StatelessWidget{

  final List<Movie> movies;

  const MovieBannerSlider({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return cs.CarouselSlider.builder(
      itemCount: movies.length,
      options: cs.CarouselOptions(
        height: 220,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        enlargeStrategy: cs.CenterPageEnlargeStrategy.scale,
        scrollPhysics: const BouncingScrollPhysics(),
        autoPlayCurve: Curves.easeInOut,
      ),
      itemBuilder: (context, index, realIndex) {
        final movie = movies[index];
        return _buildMovieItem(context, movie);
      },
    );
  }

  Widget _buildMovieItem(BuildContext context, Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: movie);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Sử dụng CachedNetworkImage hoặc AssetImage với error handling
            _buildImageWidget(movie),
            // Overlay gradient
            _buildGradientOverlay(),
            // Thông tin phim
            _buildMovieInfo(movie),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(Movie movie) {
    return movie.isLocal
        ? Image.asset(
            movie.bannerUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
          )
        : Image.network(
            movie.bannerUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
          );
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(0, 0, 0, 0.7), Colors.transparent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget _buildMovieInfo(Movie movie) {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 10,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  movie.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                const SizedBox(height: 2),
                Text(
                  movie.genre.join(", "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black54,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildRatingBadge(movie.rating),
          if (movie.isHot) _buildHotBadge(),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        rating,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHotBadge() {
    return const Padding(
      padding: EdgeInsets.only(left: 6),
      child: Icon(
        Icons.local_fire_department,
        color: Colors.orange,
        size: 20,
        shadows: [
          Shadow(
            blurRadius: 2.0,
            color: Colors.black54,
            offset: Offset(1.0, 1.0),
          ),
        ],
      ),
    );
  }
}
