import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/screen/scoreboard.dart';
import 'package:wetrip/data_class.dart';

class TinderPlacePage extends StatefulWidget {
  final String? keyword;
  final Trip trip;
  final Function(Trip) onUpdateTrip;
  const TinderPlacePage({
    required this.trip,
    required this.keyword,
    required this.onUpdateTrip,
    super.key,
  });

  @override
  _TinderPlacePageState createState() => _TinderPlacePageState();
}

class _TinderPlacePageState extends State<TinderPlacePage> {
  final DataLoader dataLoader = DataLoader.instance;
  List<Place> places = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    places = dataLoader.getPlacesfromKeyword(widget.keyword!);
    setState(() {});
  }

  void nextPlace() {
    setState(() {
      currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Finish Voting Page
    if (currentIndex >= places.length) {
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
        body: Center(
          child: Container(
            width: width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.indigo,
                  Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/tinder_page.jpg',
                  width: 275,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  "Hoo Rey!",
                  style: GoogleFonts.prompt(
                      fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "You have finished voting for your places\nWait for other members to vote theirs.",
                  style: GoogleFonts.prompt(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  "*สมมติว่า member ทุกคนได้ทำการโหวตเรียบร้อยแล้ว*",
                  style: GoogleFonts.prompt(fontSize: 15, color: Colors.white),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final updatedTrip = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScoreBoard(
                          trip: widget.trip,
                          keyword: widget.keyword,
                        ),
                      ),
                    );
                    if (updatedTrip != null) {
                      widget.onUpdateTrip(updatedTrip);
                      Navigator.pop(context, updatedTrip);
                    }
                  },
                  child: Text(
                    "See the results!",
                    style:
                        GoogleFonts.prompt(fontSize: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    //Voting Page
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 255, 255),
            Color.fromRGBO(179, 229, 252, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              decoration: BoxDecoration(color: Colors.lightBlue[100]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selected keyword : ",
                    style: GoogleFonts.prompt(fontSize: 20),
                  ),
                  Text(
                    widget.keyword!,
                    style: GoogleFonts.prompt(
                        fontSize: 25,
                        color: const Color.fromARGB(255, 0, 57, 103),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "** หน้านี้สำหรับให้ User เลือกโหวตสถานที่ที่ชอบ \nแต่ละคนจะมีหน้านี้ของตัวเองและต้องทำการโหวตให้ครบ **",
                style: GoogleFonts.prompt(fontSize: 13, color: Colors.red),
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 150),

            //Show Place for voting
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${places[currentIndex].name}, ${places[currentIndex].location}",
                style: GoogleFonts.prompt(
                    fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 150,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.place),
                  Text(
                    "Open map",
                    style: GoogleFonts.prompt(fontSize: 15),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                places[currentIndex].description,
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
            const SizedBox(height: 100),

            //Voting button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: nextPlace,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: Row(children: [
                    const Icon(Icons.thumb_down_alt),
                    const SizedBox(width: 10),
                    Text(
                      "NOOO",
                      style: GoogleFonts.prompt(fontSize: 15),
                    )
                  ]),
                ),
                ElevatedButton(
                  onPressed: nextPlace,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  child: Row(children: [
                    const Icon(Icons.thumb_up_alt),
                    const SizedBox(width: 10),
                    Text(
                      "LIKE THIS!",
                      style: GoogleFonts.prompt(fontSize: 15),
                    )
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
