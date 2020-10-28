import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../screens/movie_detail_screen.dart';
import '../bloc/get_movies_byGenre_bloc.dart';
import '../models/movie.dart';
import '../models/movie_response.dart';
import 'Loading.dart';

class GenreMovie extends StatefulWidget {
  final int genreId;
  GenreMovie({Key key, @required this.genreId}) : super(key: key);
  @override
  _GenreMovieState createState() => _GenreMovieState();
}

class _GenreMovieState extends State<GenreMovie> {
  @override
  void initState() {
    super.initState();
    moviesByGenreBloc.getMoviesByGenre(widget.genreId);
  }

  Widget _buildMoviesByGenreWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        child: Text('No Movies'),
      );
    } else {
      return Container(
        height: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.9
            : MediaQuery.of(context).size.height * 0.55,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10)
                    .add(EdgeInsets.only(right: 10)),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(
                            movie: movies[index],
                          ),
                        ));
                  },
                  child: Column(
                    children: [
                      movies[index].poster == null
                          ? Container(
                              width: 120,
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.landscape)
                                  ? MediaQuery.of(context).size.height * 0.45
                                  : MediaQuery.of(context).size.height * 0.29,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle,
                              ),
                              child:
                                  Icon(Icons.local_movies, color: Colors.white))
                          : Container(
                              width: 120,
                              height: (MediaQuery.of(context).orientation ==
                                      Orientation.landscape)
                                  ? MediaQuery.of(context).size.height * 0.45
                                  : MediaQuery.of(context).size.height * 0.29,
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p//w200/' +
                                          movies[index].poster),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 5),
                        width: 100,
                        child: Text(
                          movies[index].title,
                          maxLines: 2,
                          style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            movies[index].rating.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          RatingBar(
                            itemSize: 8.0,
                            initialRating: movies[index].rating / 2,
                            minRating: 1.0,
                            allowHalfRating: true,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, _) {
                              return Icon(
                                Icons.star,
                                color: Theme.of(context).accentColor,
                              );
                            },
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesByGenreBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return ErrorWidget(snapshot.data.error);
          }
          return _buildMoviesByGenreWidget(snapshot.data);
        } else if (snapshot.hasError)
          return ErrorWidget(snapshot.error);
        else
          return Loading();
      },
    );
  }
}
