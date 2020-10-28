import 'package:flutter/material.dart';
import '../bloc/get_casts_bloc.dart';
import '../models/cast.dart';
import '../models/cast_response.dart';

import 'Loading.dart';

class Casts extends StatefulWidget {
  final int id;
  Casts({Key key, @required this.id}) : super(key: key);
  @override
  _CastsState createState() => _CastsState();
}

class _CastsState extends State<Casts> {
  @override
  void initState() {
    super.initState();
    castsBloc.getCasts(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
    castsBloc.drainStream();
  }

  Widget _buildCastWidget(CastResponse data) {
    List<Cast> casts = data.casts;

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.only(left: 10),
      child: ListView.builder(
        itemCount: casts.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.only(top: 10, right: 8),
            width: 100,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (casts[index].img == null)
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).accentColor,
                          ),
                          child: Icon(Icons.verified_user, color: Colors.white),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w300/' +
                                      casts[index].img),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: Text(
                      casts[index].name,
                      maxLines: 2,
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    casts[index].character,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 7.0,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            'CASTS',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        SizedBox(height: 5),
        StreamBuilder<CastResponse>(
          stream: castsBloc.subject.stream,
          builder: (context, AsyncSnapshot<CastResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null && snapshot.data.error.length > 0)
                return ErrorWidget(snapshot.data.error);
              return _buildCastWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return ErrorWidget(snapshot.error);
            } else
              return Loading();
          },
        )
      ],
    );
  }
}
