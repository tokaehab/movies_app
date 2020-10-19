import 'package:flutter/material.dart';
import 'package:movies_app/widgets/genres.dart';
import 'package:movies_app/widgets/now_playing.dart';
import 'package:movies_app/widgets/persons_list.dart';
import 'package:movies_app/widgets/top_movies.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
          color: Colors.white,
        ),
        title: Text(
          'Movie App',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search_outlined),
            onPressed: () {},
            color: Colors.white,
          ),
        ],
      ),
      body: ListView(
        children: [
          NowPlaying(),
          GenresScreen(),
          PersonsList(),
          TopMovies(),
        ],
      ),
    );
  }
}