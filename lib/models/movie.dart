class Movie {
  final int id;
  final double popularity;
  final String title;
  final String backPoster;
  final String poster;
  final String overView;
  final double rating;
  Movie(
    this.id,
    this.popularity,
    this.title,
    this.backPoster,
    this.poster,
    this.overView,
    this.rating,
  );
  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        popularity = json['popularity'].toDouble(),
        title = json['title'],
        backPoster = json['backdrop_path'],
        poster = json['poster_path'],
        overView = json['overview'],
        rating = json['vote_average'].toDouble();
}
