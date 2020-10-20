import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies_app/bloc/get_movie_videos_bloc.dart';
import 'package:movies_app/models/video.dart';
import 'package:movies_app/models/video_response.dart';
import 'package:movies_app/screens/video_player_screen.dart';
import 'package:movies_app/widgets/Loading.dart';
import 'package:movies_app/widgets/casts.dart';
import 'package:movies_app/widgets/movie_info.dart';
import 'package:movies_app/widgets/similar_movies.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen({Key key, this.movie}) : super(key: key);
  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    movieVideosBloc.getMovieVideos(widget.movie.id);
  }

  @override
  void dispose() {
    super.dispose();
    movieVideosBloc.drainStream();
  }

  Widget _buildVideoWidget(VideoResponse data) {
    List<Video> videos = data.videos;
    return FloatingActionButton(
      backgroundColor: Theme.of(context).accentColor,
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              controller: YoutubePlayerController(
                initialVideoId: videos[0].key,
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  forceHD: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Builder(builder: (context) {
        return SliverFab(
            floatingPosition: FloatingPosition(right: 20.0),
            floatingWidget: StreamBuilder<VideoResponse>(
              stream: movieVideosBloc.subject.stream,
              builder: (context, AsyncSnapshot<VideoResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.error != null &&
                      snapshot.data.error.length > 0)
                    return ErrorWidget(snapshot.data.error);
                  return _buildVideoWidget(snapshot.data);
                } else if (snapshot.hasError) {
                  return ErrorWidget(snapshot.error);
                } else
                  return Loading();
              },
            ),
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Theme.of(context).primaryColor,
                expandedHeight: MediaQuery.of(context).size.height * 0.3,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    (widget.movie.title.length > 30)
                        ? widget.movie.title.substring(0, 25) + '...'
                        : widget.movie.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://images.tmdb.org/t/p/original/' +
                                  widget.movie.backPoster,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.0),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(0.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.movie.rating.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          RatingBar(
                            itemSize: 10.0,
                            initialRating: widget.movie.rating / 2,
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10),
                      child: Text(
                        'OverView',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        widget.movie.overView,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    MovieInfo(id: widget.movie.id),
                    Casts(id: widget.movie.id),
                    SimilarMovies(id: widget.movie.id),
                  ]),
                ),
              ),
            ]);
      }),
    );
  }
}
