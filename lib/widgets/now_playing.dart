import 'package:flutter/material.dart';
import 'package:movies_app/bloc/get_now_playing_bloc.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/models/movie_response.dart';
import 'package:movies_app/widgets/Loading.dart';
import 'package:page_indicator/page_indicator.dart';

class NowPlaying extends StatefulWidget {
  @override
  _NowPlayingState createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  @override
  void initState() {
    super.initState();
    nowPlayingBloc.getMovies();
  }

  Widget _buildNowPlayingWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Text('No Movies'),
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: PageIndicatorContainer(
          length: movies.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5),
          shape: IndicatorShape.circle(size: 5.0),
          indicatorColor: Theme.of(context).textTheme.headline6.color,
          indicatorSelectorColor: Theme.of(context).accentColor,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/original/' +
                                movies[index].backPoster),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(1.0),
                        Theme.of(context).primaryColor.withOpacity(0.0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.0, 0.9],
                    )),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 50,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Positioned(
                      bottom: 50,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          movies[index].title,
                          style: TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ))
                ],
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: nowPlayingBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return ErrorWidget(snapshot.data.error);
          }
          return _buildNowPlayingWidget(snapshot.data);
        } else if (snapshot.hasError)
          return ErrorWidget(snapshot.error);
        else
          return Loading();
      },
    );
  }
}
