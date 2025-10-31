class Showtime {
  final String time;
  final String format;
  final int price;

  Showtime({required this.time, required this.format, required this.price});

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      time: json['time'],
      format: json['format'],
      price: json['price'],
    );
  }
}

class Theater {
  final String theaterId;
  final String theaterName;
  final List<Showtime> showtimes;

  Theater({
    required this.theaterId,
    required this.theaterName,
    required this.showtimes,
  });

  factory Theater.fromJson(Map<String, dynamic> json) {
    return Theater(
      theaterId: json['theaterId'],
      theaterName: json['theaterName'],
      showtimes: (json['showtimes'] as List)
          .map((e) => Showtime.fromJson(e))
          .toList(),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String slug;
  final int duration;
  final List<String> genre;
  final String rating;
  final String posterUrl;
  final String bannerUrl;
  final String synopsis;
  final String category;
  final bool isHot;
  final String releaseDate;
  final List<Theater> theaters;
  final bool isLocal;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.slug,
    required this.duration,
    required this.genre,
    required this.rating,
    required this.posterUrl,
    required this.bannerUrl,
    required this.synopsis,
    required this.category,
    required this.isHot,
    required this.releaseDate,
    required this.theaters,
    this.isLocal = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      originalTitle: json['originalTitle'],
      slug: json['slug'],
      duration: json['duration'],
      genre: List<String>.from(json['genre']),
      rating: json['rating'],
      posterUrl: json['posterUrl'],
      bannerUrl: json['bannerUrl'],
      synopsis: json['synopsis'],
      category: json['category'],
      isHot: json['isHot'],
      releaseDate: json['releaseDate'],
      theaters: (json['theaters'] as List)
          .map((e) => Theater.fromJson(e))
          .toList(),
    );
  }
}
