import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:wetrip/data_class.dart';

class ScoreBoard extends StatefulWidget {
  final Trip trip;
  final String? keyword;

  const ScoreBoard({required this.trip, required this.keyword, super.key});

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  final Random random = Random();
  List<Map<String, dynamic>> placesWithScore = [];
  List<Place> places = [];
  final DataLoader dataLoader = DataLoader.instance;
  Place? selectedPlace;

  @override
  void initState() {
    super.initState();
    generateScores();
  }

  void generateScores() {
    places = dataLoader.getPlacesfromKeyword(widget.keyword!);
    placesWithScore = places.map((place) {
      return {
        'place': place,
        'score': random.nextInt(widget.trip.members.length + 1),
      };
    }).toList();

    // Sort
    placesWithScore.sort((a, b) => b['score'].compareTo(a['score']));
  }

  void _updateTrip(Trip trip) {
    trip.status = 'planning';
    trip.place = selectedPlace;
  }

  @override
  Widget build(BuildContext context) {
    int highestScore =
        placesWithScore.isNotEmpty ? placesWithScore.first['score'] : 0;

    return Scaffold(
      body: ListView.builder(
        itemCount: placesWithScore.length,
        itemBuilder: (context, index) {
          final place = placesWithScore[index]['place'] as Place;
          final score = placesWithScore[index]['score'] as int;

          return Card(
            color: Colors.lightBlue[100],
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text(place.name),
                    subtitle: Text(place.location),
                    trailing: Text(
                      'Score: $score',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (score == highestScore)
                    ElevatedButton(
                      onPressed: () {
                        selectedPlace = place;
                        _updateTrip(widget.trip);
                        Navigator.pop(context, widget.trip);
                        Navigator.pop(context, widget.trip);
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text("Select this place for our trip",
                          style: GoogleFonts.prompt(fontSize: 15)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
