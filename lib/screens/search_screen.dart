import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../bloc/get_search_movies_bloc.dart';
import '../models/movie.dart';
import '../models/movie_response.dart';
import '../widgets/Loading.dart';
import 'movie_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool swapped = false;
  String movieName = '';

  Widget searchBar() {
    return AnimatedAlign(
      duration: Duration(
        milliseconds: 400,
      ),
      alignment: swapped ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for Movies',
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            if (value.isEmpty && swapped) {
              setState(() {
                swapped = false;
              });
            } else if (value.isNotEmpty && !swapped) {
              setState(() {
                swapped = true;
              });
            }
            movieName = value;
          },
        ),
      ),
    );
  }

  Widget searchIconButton() {
    return AnimatedAlign(
      duration: Duration(milliseconds: 400),
      alignment: swapped ? Alignment.centerRight : Alignment.centerLeft,
      child: IconButton(
          icon: Icon(Icons.search),
          color: Colors.white,
          onPressed: () {
            try {
              FocusScope.of(context).unfocus();
            } catch (error) {
              print(error);
            }
            if (movieName != '')
              setState(() {
                searchMoviesBloc.getMovies(movieName);
              });
          }),
    );
  }

  Widget _buildSearchMoviesWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Center(
        child: Text(
          'No Movies',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
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
                  child: Row(
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
                              child: Icon(
                                Icons.local_movies,
                                color: Colors.white,
                                size: 80,
                              ))
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
                        height: (MediaQuery.of(context).orientation ==
                                Orientation.landscape)
                            ? MediaQuery.of(context).size.height * 0.4
                            : MediaQuery.of(context).size.height * 0.25,
                        width: 230,
                        margin: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          left: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                movies[index].title,
                                maxLines: 2,
                                style: TextStyle(
                                  height: 1.4,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                movies[index].overView,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      movies[index].rating.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  RatingBar(
                                    itemSize: 14,
                                    initialRating: movies[index].rating / 2,
                                    minRating: 1.0,
                                    allowHalfRating: true,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 2),
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
                            ),
                          ],
                        ),
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
  void dispose() {
    searchMoviesBloc.drainStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.2),
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: <Widget>[
              searchBar(),
              searchIconButton(),
            ],
          ),
        ),
      ),
      body: StreamBuilder<MovieResponse>(
        stream: searchMoviesBloc.subject.stream,
        builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return ErrorWidget(snapshot.data.error);
            }
            return _buildSearchMoviesWidget(snapshot.data);
          } else if (snapshot.hasError)
            return ErrorWidget(snapshot.error);
          else if (movieName == '') {
            return Center(
              child: Text(
                "Let's Search",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            );
          } else
            return Loading();
        },
      ),
    );
  }
}
