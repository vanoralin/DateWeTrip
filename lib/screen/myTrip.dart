import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/widget/trip_widget.dart';
import 'package:wetrip/data_class.dart';

class MyTrip extends StatefulWidget {
  const MyTrip({super.key});

  @override
  State<MyTrip> createState() => _MyTripState();
}

class _MyTripState extends State<MyTrip> {
  final dataLoader = DataLoader.instance;
  String name = '';
  List<Trip> userTrips = [];

  @override
  void initState() {
    super.initState();
    loadTripsData();
  }

  Future<void> loadTripsData() async {
    name = dataLoader.selectedUser!.name;
    userTrips = dataLoader.getTripsForUser(name);
    setState(() {});
  }

  void updateTrip(Trip updatedTrip) {
    setState(() {
      int index = userTrips.indexWhere((trip) => trip.id == updatedTrip.id);
      if (index != -1) {
        userTrips[index] = updatedTrip;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "My Trip",
        style: GoogleFonts.prompt(fontSize: 23, fontWeight: FontWeight.bold),
      )),
      body: userTrips.isEmpty
          ? Center(child: Text("No trips found for $name."))
          : Center(
              child: SizedBox(
                width: width * 0.95,
                height: height * 0.8,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return TripWidget(
                      trip: userTrips[index],
                      onUpdateTrip: updateTrip,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  itemCount: userTrips.length,
                ),
              ),
            ),
    );
  }
}
