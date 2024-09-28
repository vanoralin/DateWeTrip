import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/data_class.dart';

class MyGroup extends StatelessWidget {
  MyGroup({super.key});

  DataLoader dataloader = DataLoader.instance;
  List<Group> groups =
      DataLoader.instance.getGroupsFromUser(DataLoader.instance.selectedUser!);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Group",
          style: GoogleFonts.prompt(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "แอพ ver เบบี๋ นี้ยังไม่สามารถ create Group เพิ่ม หรือ edit เองได้",
              style: GoogleFonts.prompt(fontSize: 13, color: Colors.red),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                List<User> member = group.members;
                String memberNames =
                    member.map((member) => member.name).join(', ');

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: width * 0.95,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Group name: ${group.name}",
                          style: GoogleFonts.prompt(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Members: $memberNames",
                          style: GoogleFonts.prompt(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
