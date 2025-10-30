import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieListTab extends StatelessWidget {

  final List<Movie> movies;
  final String category;

  const MovieListTab({super.key, required this.movies, required this.category});

  @override
  Widget build(BuildContext context) {
    final filtered = movies.where((m) => m.category == category).toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index){
        final movie = movies[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.posterUrl,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(movie.title),
          subtitle: Text(
              "${movie.genre.join(', ')} • ${movie.rating} • ${movie.duration} phút"),
          trailing: const Icon(Icons.chevron_right),
          onTap: (){
            Navigator.pushNamed(context, '/detail', arguments: movie);
          },
        );
      }
    );
  }
}
