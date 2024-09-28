import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/screen/tinder_place.dart';
import 'package:wetrip/data_class.dart';

class KeywordPlace extends StatefulWidget {
  final Trip trip;
  final Function(Trip) onUpdateTrip;
  const KeywordPlace(
      {required this.trip, required this.onUpdateTrip, super.key});

  @override
  State<KeywordPlace> createState() => _KeywordPlaceState();
}

class _KeywordPlaceState extends State<KeywordPlace> {
  final dataLoader = DataLoader.instance;
  List<String> allTags = [];
  String? selectedKeyword;

  @override
  void initState() {
    super.initState();
    loadTagsData();
  }

  Future<void> loadTagsData() async {
    allTags = dataLoader.collectAllTags();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Select Place",
        style: GoogleFonts.prompt(fontSize: 23, fontWeight: FontWeight.bold),
      )),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              "Which Type of Place\nyou want to go ?",
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(fontSize: 25),
            ),
            const SizedBox(height: 50),

            //Select Keyword
            const Icon(
              Icons.edit_location_alt_rounded,
              size: 80,
            ),
            DropdownButton<String>(
              dropdownColor: Colors.lightBlue[100],
              value: selectedKeyword,
              hint: Text(
                "Keywords",
                style: GoogleFonts.prompt(fontSize: 30),
              ),
              items: allTags.map((tag) {
                return DropdownMenuItem<String>(
                  value: tag,
                  child: Text(
                    tag,
                    style:
                        GoogleFonts.prompt(color: Colors.black, fontSize: 30),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedKeyword = newValue;
                });
              },
            ),
            const SizedBox(height: 80),

            //Next button
            ElevatedButton(
              onPressed: () async {
                if (selectedKeyword != null) {
                  final updatedTrip = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TinderPlacePage(
                        trip: widget.trip,
                        keyword: selectedKeyword,
                        onUpdateTrip: (Trip updatedTrip) {
                          setState(() {
                            widget.onUpdateTrip(updatedTrip);
                          });
                        },
                      ),
                    ),
                  );

                  if (updatedTrip != null) {
                    setState(() {
                      widget.onUpdateTrip(updatedTrip);
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
              ),
              child: const Text("Next"),
            ),
            const SizedBox(height: 10),
            Text(
              "***เนื่องจากแอพนี้ยังเป็นเบบี๋ \n เมื่อเลือก Keyword แล้วจะย้อนกลับไม่ได้นะคับ \n โปรดเลือกด้วยความระมัดระวัง",
              style: GoogleFonts.prompt(fontSize: 15, color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
