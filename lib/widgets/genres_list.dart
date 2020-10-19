import 'package:flutter/material.dart';
import 'package:movies_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:movies_app/models/genre.dart';
import 'genre_movies.dart';

class GenresList extends StatefulWidget {
  final List<Genre> genres;
  GenresList({Key key, @required this.genres}) : super(key: key);
  @override
  _GenresListState createState() => _GenresListState();
}

class _GenresListState extends State<GenresList>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.genres.length, vsync: this);
    if (_tabController.indexIsChanging) {
      moviesByGenreBloc.drainStream();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).orientation == Orientation.landscape)
          ? MediaQuery.of(context).size.height * 0.9
          : MediaQuery.of(context).size.height * 0.55,
      child: DefaultTabController(
        length: widget.genres.length,
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).accentColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                unselectedLabelColor:
                    Theme.of(context).textTheme.headline6.color,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: widget.genres.map((Genre genre) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      genre.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            preferredSize: Size.fromHeight(50),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: widget.genres.map((Genre genre) {
              return GenreMovie(
                genreId: genre.id,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
