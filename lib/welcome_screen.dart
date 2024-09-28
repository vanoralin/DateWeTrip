import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/data_class.dart';
import 'package:wetrip/home_screen.dart';

class WelcomeP extends StatefulWidget {
  const WelcomeP({super.key});

  @override
  _WelcomePState createState() => _WelcomePState();
}

class _WelcomePState extends State<WelcomeP> {
  User? selectedUser;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final dataLoader = DataLoader.instance;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 200),
            Image.asset(
              'assets/images/logo.jpg',
              width: 275,
            ),
            const SizedBox(height: 20),
            Text(
              "Plan your trip",
              style:
                  GoogleFonts.prompt(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            //select user
            DropdownButton<User?>(
              dropdownColor: Colors.lightBlue[100],
              value: selectedUser,
              hint: Text(
                "Select User",
                style: GoogleFonts.prompt(
                  fontSize: 30,
                ),
              ),
              items: dataLoader.users.map((User user) {
                return DropdownMenuItem<User?>(
                  value: user,
                  child: Text(
                    user.name,
                    style:
                        GoogleFonts.prompt(color: Colors.black, fontSize: 30),
                  ),
                );
              }).toList(),
              onChanged: (User? newValue) {
                setState(() {
                  selectedUser = newValue;
                  dataLoader.selectUser(newValue!);
                });
              },
            ),
            const SizedBox(height: 20),

            //start button
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF50ABE7),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      if (selectedUser != null) {
                        errorMessage = '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      } else {
                        setState(() {
                          errorMessage = "Please select a User :3";
                        });
                      }
                    },
                    child: Text(
                      "Start",
                      style: GoogleFonts.prompt(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
            if (errorMessage.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    errorMessage,
                    style: GoogleFonts.prompt(color: Colors.red, fontSize: 18),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
