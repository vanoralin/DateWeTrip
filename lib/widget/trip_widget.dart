import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/screen/trip_info.dart';
import 'package:wetrip/data_class.dart';

class TripWidget extends StatefulWidget {
  final Trip trip;
  final Function(Trip) onUpdateTrip;

  const TripWidget({required this.trip, required this.onUpdateTrip, super.key});

  @override
  _TripWidgetState createState() => _TripWidgetState();
}

class _TripWidgetState extends State<TripWidget> {
  late Trip trip;

  @override
  void initState() {
    super.initState();
    trip = widget.trip;
  }

  @override
  Widget build(BuildContext context) {
    String listMember = trip.members.join(', ');

    return GestureDetector(
      onTap: () async {
        final updatedTrip = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripInfo(trip: trip),
          ),
        );

        if (updatedTrip != null) {
          setState(() {
            trip = updatedTrip;
          });
          widget.onUpdateTrip(updatedTrip);
        }
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(
                trip.status == "finished"
                    ? Icons.beenhere
                    : Icons.beenhere_outlined,
                size: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trip:",
                      style: GoogleFonts.prompt(fontSize: 15),
                    ),
                    Text(
                      trip.name,
                      style: GoogleFonts.prompt(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 53,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                                child: Text(
                              "Date",
                              style: GoogleFonts.prompt(fontSize: 15),
                            )),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${trip.startDate ?? 'N/A'} - ${trip.endDate ?? 'N/A'}",
                            style: GoogleFonts.prompt(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Members : ",
                      style: GoogleFonts.prompt(fontSize: 15),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 250),
                      child: Text(
                        listMember,
                        style: GoogleFonts.prompt(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 0, 57, 103)),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
