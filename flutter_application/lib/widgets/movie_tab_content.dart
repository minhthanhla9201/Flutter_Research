import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'horizontal_movie_list.dart';

class MovieTabContent extends StatelessWidget {
  final List<Movie> nowPlaying;
  final List<Movie> comingSoon;
  final List<Movie> special;
  final TabController tabController;

  const MovieTabContent({
    super.key,
    required this.nowPlaying,
    required this.comingSoon,
    required this.special,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HorizontalMovieList(movies: nowPlaying),
        HorizontalMovieList(movies: comingSoon),
        HorizontalMovieList(movies: special),
      ],
    );
  }
}