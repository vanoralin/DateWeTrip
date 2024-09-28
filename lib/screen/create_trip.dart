import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/data_class.dart';

class CreateTrip extends StatefulWidget {
  final VoidCallback onFinish;
  const CreateTrip({super.key, required this.onFinish});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final DataLoader dataLoader = DataLoader.instance;
  List<Group> groups = [];
  final TextEditingController taskController = TextEditingController();
  List<User> members = [];
  List<User> allUser = [];
  Group noneGroup = Group(name: 'temp', members: []);
  Group? selectGroup;

  @override
  void initState() {
    super.initState();
    getAllUser();
    groups = dataLoader.getGroupsFromUser(dataLoader.selectedUser!);
    selectGroup = noneGroup;
  }

  void getAllUser() {
    allUser = dataLoader.users
        .where((user) => user != dataLoader.selectedUser)
        .toList();
  }

  void addMemberInGroup(Group selectedGroup) {
    members.clear();
    for (var memb in selectedGroup.members) {
      members.add(memb);
    }
  }

  void createTrip() {
    if (taskController.text.isNotEmpty) {
      if (!members.contains(dataLoader.selectedUser)) {
        members.add(dataLoader.selectedUser!);
      }
      List<String> membersName = members.map((member) => member.name).toList();
      dataLoader.addTrip(taskController.text, membersName);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("Create new trip")),
      body: Container(
        height: height,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: taskController,
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "Enter trip name",
                  border: const OutlineInputBorder(),
                  labelStyle: GoogleFonts.prompt(fontSize: 20),
                ),
              ),
              Text(
                "Your Groups:",
                style: GoogleFonts.prompt(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Column(
                children: groups.map((group) {
                  return CheckboxListTile(
                    title: Text(group.name),
                    subtitle: Text(
                        group.members.map((member) => member.name).join(', ')),
                    value: group == selectGroup,
                    onChanged: (bool? value) {
                      setState(() {
                        if (selectGroup == group) {
                          selectGroup = noneGroup;
                        } else {
                          selectGroup = group;
                          addMemberInGroup(group);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              Text(
                "Users",
                style: GoogleFonts.prompt(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Column(
                children: allUser.map((user) {
                  return CheckboxListTile(
                    title: Text(user.name),
                    value: members.contains(user),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          members.add(user);
                        } else {
                          members.remove(user);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  createTrip();
                  if (taskController.text.isNotEmpty) {
                    widget.onFinish();
                  }
                },
                child: Text("Create Trip",
                    style: GoogleFonts.prompt(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
