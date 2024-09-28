import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/data_class.dart';

class PlannerPage extends StatefulWidget {
  final Trip trip;
  const PlannerPage({required this.trip, super.key});

  @override
  _PlannerPageState createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final DataLoader dataLoader = DataLoader.instance;
  DateTime selectedDate = DateTime.now();
  final TextEditingController taskController = TextEditingController();
  List<Plan> plans = [];
  DateTime? startDate;
  DateTime? endDate;

  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.parse(widget.trip.startDate!);
    endDate = DateTime.parse(widget.trip.endDate!);

    selectedDate = startDate!;

    plans = dataLoader.tripPlans.firstWhere(
      //get that Trip's Plan
      (entry) => entry.containsKey(widget.trip),
      orElse: () => {widget.trip: []},
    )[widget.trip]!;
  }

  //Calendar
  Future<void> pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: startDate ?? DateTime.now(),
      lastDate: endDate ?? DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  //Time
  Future<void> pickStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> pickEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  //Format time -> Sting
  String formatTimeToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0'); //hours two digits
    final minute = time.minute.toString().padLeft(2, '0'); //minutes two digits
    return '$hour:$minute';
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.year.toString().padLeft(4, '0')}-${(date.month).toString().padLeft(2, '0')}-${(date.day).toString().padLeft(2, '0')}";
  }

  //for add task
  void addTask() {
    if (taskController.text.isNotEmpty &&
        selectedStartTime != null &&
        selectedEndTime != null) {
      setState(() {
        Plan newPlan = Plan(
          date: selectedDate,
          startTime: formatTimeToString(selectedStartTime!),
          endTime: formatTimeToString(selectedEndTime!),
          task: taskController.text,
          type: "act",
        );

        dataLoader.addPlan(widget.trip, newPlan);

        //update Plan
        plans = dataLoader.tripPlans.firstWhere(
          (entry) => entry.containsKey(widget.trip),
          orElse: () => {widget.trip: []},
        )[widget.trip]!;

        taskController.clear();
        selectedStartTime = null;
        selectedEndTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planner", style: GoogleFonts.prompt()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //pick date
            GestureDetector(
              onTap: pickDate,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: GoogleFonts.prompt(fontSize: 20),
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            //pick start time
            GestureDetector(
              onTap: pickStartTime,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedStartTime != null
                          ? formatTimeToString(selectedStartTime!)
                          : "Select Start Time",
                      style: GoogleFonts.prompt(fontSize: 20),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            //pick end time
            GestureDetector(
              onTap: pickEndTime,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedEndTime != null
                          ? formatTimeToString(selectedEndTime!)
                          : "Select End Time",
                      style: GoogleFonts.prompt(fontSize: 20),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            //add Task
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelStyle: GoogleFonts.prompt(fontSize: 15),
                labelText: "Add a new task",
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shadowColor: Colors.black,
                elevation: 5,
              ),
              child: const Text("Add Task"),
            ),
            const SizedBox(height: 20),
            Text(
              "Tasks in ${formatDate(selectedDate)}",
              style:
                  GoogleFonts.prompt(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount:
                    plans.where((plan) => plan.date == selectedDate).length,
                itemBuilder: (context, index) {
                  final filteredTasks =
                      plans.where((plan) => plan.date == selectedDate).toList();
                  return ListTile(
                    title: Text(filteredTasks[index].task),
                    subtitle: Text(
                      "From: ${filteredTasks[index].startTime} "
                      "To: ${filteredTasks[index].endTime}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
