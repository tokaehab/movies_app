import 'package:flutter/material.dart';
import '../bloc/get_person_bloc.dart';
import '../models/person.dart';
import '../models/person_response.dart';
import 'Loading.dart';

class PersonsList extends StatefulWidget {
  @override
  _PersonsListState createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  Widget _buildPersonsWidget(PersonResponse data) {
    List<Person> persons = data.persons;

    if (persons.length == 0) {
      return Container(
        child: Text('No Persons'),
      );
    } else {
      return Container(
        height: (MediaQuery.of(context).orientation == Orientation.landscape)
            ? MediaQuery.of(context).size.height * 0.45
            : MediaQuery.of(context).size.height * 0.3,
        padding: EdgeInsets.only(left: 10),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: persons.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                padding: EdgeInsets.only(top: 8, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    persons[index].profileImg == null
                        ? Container(
                            width: 70,
                            height: (MediaQuery.of(context).orientation ==
                                    Orientation.landscape)
                                ? MediaQuery.of(context).size.height * 0.2
                                : MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).accentColor,
                            ),
                            child:
                                Icon(Icons.verified_user, color: Colors.white),
                          )
                        : Container(
                            width: 70,
                            height: (MediaQuery.of(context).orientation ==
                                    Orientation.landscape)
                                ? MediaQuery.of(context).size.height * 0.2
                                : MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w200' +
                                        persons[index].profileImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 3),
                      child: FittedBox(
                        child: Text(
                          persons[index].name,
                          style: TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Trending for ${persons[index].known}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    )
                  ],
                ),
              );
            }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    personBloc.getPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
          child: Text(
            'TRENDING PERSONS THIS WEEK',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ),
        StreamBuilder<PersonResponse>(
          stream: personBloc.subject.stream,
          builder: (context, AsyncSnapshot<PersonResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null &&
                  snapshot.data.error.length > 0) {
                return ErrorWidget(snapshot.data.error);
              }
              return _buildPersonsWidget(snapshot.data);
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
