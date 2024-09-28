import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/screen/plan_trip.dart';
import 'package:wetrip/screen/select_date.dart';
import 'package:wetrip/screen/select_keyword.dart';
import 'package:wetrip/data_class.dart';

class TripInfo extends StatefulWidget {
  final Trip trip;
  const TripInfo({required this.trip, super.key});

  @override
  State<TripInfo> createState() => _TripInfoState();
}

class _TripInfoState extends State<TripInfo> {
  int status = 0;

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  void getStatus() {
    if (widget.trip.status == 'not_selected_date') {
      status = 0;
    } else if (widget.trip.status == 'not_selected_place') {
      status = 1;
    } else if (widget.trip.status == 'planning') {
      status = 2;
    } else if (widget.trip.status == 'finished') {
      status = 3;
    }
  }

  void onUpdateTrip(Trip updatedTrip) {
    setState(() {
      widget.trip.startDate = updatedTrip.startDate;
      widget.trip.endDate = updatedTrip.endDate;
      widget.trip.place = updatedTrip.place;
      widget.trip.status = updatedTrip.status;
      getStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    String listMember = widget.trip.members.join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trip Status",
          style: GoogleFonts.prompt(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: width * 0.75,
                  height: 10,
                  child: LinearProgressIndicator(
                    value: status / 3,
                    color: Colors.blue,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status > 0 ? Colors.blue : Colors.grey,
                      ),
                      child: const Icon(Icons.date_range),
                    ),
                    SizedBox(width: width * 0.1),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status > 1 ? Colors.blue : Colors.grey,
                      ),
                      child: const Icon(Icons.place),
                    ),
                    SizedBox(width: width * 0.1),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status > 2 ? Colors.blue : Colors.grey,
                      ),
                      child: const Icon(Icons.view_timeline),
                    ),
                    SizedBox(width: width * 0.1),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: status == 3 ? Colors.blue : Colors.grey,
                      ),
                      child: const Icon(Icons.check),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Select\nDate",
                    style: GoogleFonts.prompt(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: width * 0.13),
                  Text(
                    "Select\nPlace",
                    style: GoogleFonts.prompt(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: width * 0.13),
                  Text(
                    "Plan\na trip",
                    style: GoogleFonts.prompt(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: width * 0.13),
                  Text(
                    "Finish",
                    style: GoogleFonts.prompt(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trip name : ",
                          style: GoogleFonts.prompt(fontSize: 15),
                        ),
                        Text(
                          widget.trip.name,
                          style: GoogleFonts.prompt(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Members :",
                          style: GoogleFonts.prompt(fontSize: 15),
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: width * 0.8),
                          child: Text(
                            listMember,
                            style: GoogleFonts.prompt(
                                fontSize: 25, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 10),
            Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date :",
                          style: GoogleFonts.prompt(fontSize: 15),
                        ),
                        widget.trip.startDate != null
                            ? Text(
                                "${widget.trip.startDate ?? 'N/A'} - ${widget.trip.endDate ?? 'N/A'}",
                                style: GoogleFonts.prompt(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  if (status == 0) {
                                    final updatedTrip = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            SelecDate(trip: widget.trip),
                                      ),
                                    );

                                    if (updatedTrip != null) {
                                      onUpdateTrip(updatedTrip);
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shadowColor: Colors.black,
                                  elevation: 5,
                                ),
                                child: Text(
                                  "Select Date",
                                  style: GoogleFonts.prompt(fontSize: 15),
                                )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Place :",
                          style: GoogleFonts.prompt(fontSize: 15),
                        ),
                        widget.trip.place != null
                            ? Text(
                                widget.trip.place!.name,
                                style: GoogleFonts.prompt(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            : status >= 1
                                ? ElevatedButton(
                                    onPressed: () async {
                                      if (status == 1) {
                                        final updatedTrip =
                                            await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => KeywordPlace(
                                              trip: widget.trip,
                                              onUpdateTrip: onUpdateTrip,
                                            ),
                                          ),
                                        );

                                        if (updatedTrip != null) {
                                          onUpdateTrip(updatedTrip);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shadowColor: Colors.black,
                                      elevation: 5,
                                    ),
                                    child: Text(
                                      "Select Place",
                                      style: GoogleFonts.prompt(fontSize: 15),
                                    ))
                                : Text(
                                    "Select Date first",
                                    style: GoogleFonts.prompt(
                                        fontSize: 15, color: Colors.red),
                                  )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: width * 0.95,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Plan :",
                          style: GoogleFonts.prompt(fontSize: 15),
                        ),
                        if (status == 0)
                          Text(
                            "Select Date first",
                            style: GoogleFonts.prompt(
                                fontSize: 15, color: Colors.red),
                          )
                        else if (status == 1)
                          Text(
                            "Select Place first",
                            style: GoogleFonts.prompt(
                                fontSize: 15, color: Colors.red),
                          )
                        else
                          ElevatedButton(
                              onPressed: () async {
                                if (status == 2 || status == 3) {
                                  final updatedTrip = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlannerPage(
                                        trip: widget.trip,
                                      ),
                                    ),
                                  );

                                  if (updatedTrip != null) {
                                    onUpdateTrip(updatedTrip);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.black,
                                elevation: 5,
                              ),
                              child: Text(
                                "Planing",
                                style: GoogleFonts.prompt(fontSize: 15),
                              )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.trip.status == 'finished'
                  ? const SizedBox(height: 10)
                  : (status == 2
                      ? ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              widget.trip.status = 'finished';
                              getStatus();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.black,
                            elevation: 5,
                          ),
                          child: Text(
                            "Mark as finished",
                            style: GoogleFonts.prompt(fontSize: 15),
                          ),
                        )
                      : const SizedBox(height: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
