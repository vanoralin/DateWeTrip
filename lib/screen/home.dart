import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/data_class.dart';
import 'dart:math';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final dataLoader = DataLoader.instance;
  List<Place> places = [];
  final Random random = Random();
  Place? randPlace;

  @override
  void initState() {
    super.initState();
    places = dataLoader.places;
    randomPlace();
  }

  void randomPlace() {
    int index = random.nextInt(places.length); //rand 0<=rand<length
    setState(() {
      randPlace = places[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        "My Home",
        style: GoogleFonts.prompt(fontSize: 23, fontWeight: FontWeight.bold),
      )),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromRGBO(179, 229, 252, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        //Welcome box
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello ${dataLoader.selectedUser!.name}",
                        style: GoogleFonts.prompt(fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Adventure Awaits—Start Planning Today!",
                        style: GoogleFonts.prompt(fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Image.asset(
                    dataLoader.selectedUser!.picture,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 50),

          //Random Place
          Text(
            "Don't know where to go?",
            style: GoogleFonts.prompt(fontSize: 20),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              randomPlace();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shadowColor: Colors.black,
              elevation: 5,
            ),
            child: Text(
              "Random Place",
              style: GoogleFonts.prompt(fontSize: 15),
            ),
          ),
          const SizedBox(height: 70),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("${randPlace!.name}, ${randPlace!.location}",
                    style: GoogleFonts.prompt(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    height: 25,
                    width: 85,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text(
                      randPlace!.tag,
                      style:
                          GoogleFonts.prompt(fontSize: 15, color: Colors.white),
                    ))),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(randPlace!.description,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    softWrap: true),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
