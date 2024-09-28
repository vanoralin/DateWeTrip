import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wetrip/screen/create_trip.dart';
import 'package:wetrip/screen/home.dart';
import 'package:wetrip/screen/myGroup.dart';
import 'package:wetrip/screen/myTrip.dart';
import 'package:wetrip/screen/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    MyGroup(),
    const MyTrip(),
    const Profile(),
    CreateTrip(onFinish: () {})
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const MyHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      // + CreateTrip Page -> hide button id in the create Page
      floatingActionButton: currentTab != 4
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  currentScreen = CreateTrip(onFinish: () {
                    setState(() {
                      currentScreen = MyTrip(); // Go to MyTrip page
                      currentTab = 1;
                    });
                  });
                  currentTab = 4;
                });
              },
              child: const Icon(Icons.add),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom navi bar
      bottomNavigationBar: currentTab != 4
          ? BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 10,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Home Page
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = const MyHome();
                              currentTab = 0;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.home,
                                color:
                                    currentTab == 0 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Home',
                                style: GoogleFonts.prompt(
                                    color: currentTab == 0
                                        ? Colors.blue
                                        : Colors.grey),
                              )
                            ],
                          ),
                        ),
                        // MyTrip Page
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = const MyTrip();
                              currentTab = 1;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo_album,
                                color:
                                    currentTab == 1 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Trip',
                                style: GoogleFonts.prompt(
                                    color: currentTab == 1
                                        ? Colors.blue
                                        : Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    //MyGroup Page
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = MyGroup();
                              currentTab = 2;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.group,
                                color:
                                    currentTab == 2 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Group',
                                style: GoogleFonts.prompt(
                                    color: currentTab == 2
                                        ? Colors.blue
                                        : Colors.grey),
                              )
                            ],
                          ),
                        ),
                        //Profile Page
                        MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = const Profile();
                              currentTab = 3;
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.perm_identity,
                                color:
                                    currentTab == 3 ? Colors.blue : Colors.grey,
                              ),
                              Text(
                                'Profile',
                                style: GoogleFonts.prompt(
                                    color: currentTab == 3
                                        ? Colors.blue
                                        : Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
