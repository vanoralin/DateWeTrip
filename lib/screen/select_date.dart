import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/data_class.dart';

class SelecDate extends StatefulWidget {
  final Trip trip;
  const SelecDate({required this.trip, super.key});

  @override
  State<SelecDate> createState() => _SelecDateState();
}

class _SelecDateState extends State<SelecDate> {
  DateTime? start_date;
  DateTime? end_date;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  Future<void> selectDate(BuildContext context, String type) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (type == 'start') {
          start_date = picked;
        } else {
          end_date = picked;
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year.toString().padLeft(4, '0')}-${(date.month).toString().padLeft(2, '0')}-${(date.day).toString().padLeft(2, '0')}";
  }

  void updateDateTrip() {
    widget.trip.startDate = formatDate(start_date);
    widget.trip.endDate = formatDate(end_date);
    widget.trip.status = "not_selected_place";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Trip Date",
          style: GoogleFonts.prompt(fontSize: 23, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            start_date != null
                ? "Start date: ${formatDate(start_date)}"
                : "Start date: Not selected",
            style:
                GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          OutlinedButton(
            onPressed: () => selectDate(context, 'start'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            child: Text(
              "Select start date",
              style: GoogleFonts.prompt(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            end_date != null
                ? "End date: ${formatDate(end_date)}"
                : "End date: Not selected",
            style:
                GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          OutlinedButton(
            onPressed: () => selectDate(context, 'end'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
            child: Text(
              "Select end date",
              style: GoogleFonts.prompt(fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          ElevatedButton(
            onPressed: () {
              if (start_date != null && end_date != null) {
                if (end_date!.isBefore(start_date!)) {
                  setState(() {
                    errorMessage = "End date cannot be before start date";
                  });
                } else {
                  errorMessage = '';
                  updateDateTrip();
                  Navigator.pop(context, widget.trip);
                }
              } else {
                setState(() {
                  errorMessage = "Please select both start and end dates";
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shadowColor: Colors.black,
              elevation: 5,
            ),
            child: Text("Finish", style: GoogleFonts.prompt(fontSize: 15)),
          ),
          if (errorMessage.isNotEmpty)
            Text(
              errorMessage,
              style: GoogleFonts.prompt(fontSize: 13, color: Colors.red),
            )
        ]),
      ),
    );
  }
}
