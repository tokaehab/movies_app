import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../bloc/get_similar_movies_bloc.dart';
import '../models/movie.dart';
import '../models/movie_response.dart';
import '../screens/movie_detail_screen.dart';

import 'Loading.dart';

class SimilarMovies extends StatefulWidget {
  final int id;
  SimilarMovies({Key key, @required this.id}) : super(key: key);
  @override
  _SimilarMoviesState createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  @override
  void initState() {
    super.initState();
    similarMoviesBloc.getSimilarMovies(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    similarMoviesBloc.drainStream();
  }

  Widget _buildTopMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        margin: const EdgeInsets.only(left: 15, bottom: 10),
        child: Text(
          'No Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Container(
        height: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.7
            : MediaQuery.of(context).size.height * 0.45,
        padding: EdgeInsets.only(
          left: 10,
        ),
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
                                  ? MediaQuery.of(context).size.height * 0.4
                                  : MediaQuery.of(context).size.height * 0.25,
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
                                  ? MediaQuery.of(context).size.height * 0.4
                                  : MediaQuery.of(context).size.height * 0.25,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 10,
            bottom: 10,
            top: 14,
          ),
          child: Text(
            'SIMILAR MOVIES',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ),
        StreamBuilder<MovieResponse>(
          stream: similarMoviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorWidget(snapshot.data.error);
              }
              return _buildTopMoviesWidget(snapshot.data);
            } else if (snapshot.hasError)
              return ErrorWidget(snapshot.error);
            else
              return Loading();
          },
        ),
      ],
    );
  }
}
