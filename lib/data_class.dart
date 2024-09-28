import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Place {
  final String id;
  final String name;
  final String tag;
  final String location;
  final String description;

  Place({
    required this.id,
    required this.name,
    required this.tag,
    required this.location,
    required this.description,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      name: json['name'],
      tag: json['tag'],
      location: json['location'],
      description: json['description'],
    );
  }
}

class User {
  final String name;
  final String picture;
  final List<String> trips;
  final List<String> groups;
  final List<String> favourites;

  User({
    required this.name,
    required this.picture,
    required this.trips,
    required this.groups,
    required this.favourites,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      picture: json['picture'],
      trips: List<String>.from(json['trips']),
      groups: List<String>.from(json['groups']),
      favourites: List<String>.from(json['favourites']),
    );
  }
}

class Group {
  final String name;
  final List<User> members; //Json collect members name

  Group({
    required this.name,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    final dataLoader = DataLoader();

    return Group(
      name: json['name'],
      members: (json['members'] as List)
          .map((userName) => dataLoader.getUserByUsername(userName)!)
          .toList(),
    );
  }
}

class Trip {
  final String id;
  final String name;
  Place? place;
  final List<String> members;
  String? startDate;
  String? endDate;
  String status; //not_select_date, not_slect_place, planing, finished
  final List<String> topPlaces;

  Trip({
    required this.id,
    required this.name,
    this.place,
    required this.members,
    this.startDate,
    this.endDate,
    required this.status,
    required this.topPlaces,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    final dataLoader = DataLoader.instance;

    return Trip(
      id: json['id'],
      name: json['name'],
      place: json['place'] != null
          ? dataLoader.places.firstWhere(
              (place) => place.id == json['place']) //Json collect Place name
          : null,
      members: List<String>.from(json['members']),
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
      topPlaces: List<String>.from(json['top_places']),
    );
  }
}

class Plan {
  final DateTime date;
  final String startTime;
  final String endTime;
  final String task;
  final String type;

  Plan({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.task,
    required this.type,
  });
}

class DataLoader {
  static final DataLoader _instance = DataLoader._internal();

  List<Place> places = [];
  List<User> users = [];
  List<Group> groups = [];
  List<Trip> trips = [];

  User? selectedUser;
  List<Map<Trip, List<Plan>>> tripPlans = [];

  // Factory constructor to return the instance
  factory DataLoader() {
    return _instance;
  }

  DataLoader._internal();

  // Static getter for the instance
  static DataLoader get instance => _instance;

  Future<void> loadData() async {
    final jsonString = await rootBundle.loadString('assets/mock_data.json');
    final jsonData = json.decode(jsonString);

    //Read Json file and create class instance
    places = (jsonData['places'] as List)
        .map((placeJson) => Place.fromJson(placeJson))
        .toList();
    users = (jsonData['users'] as List)
        .map((userJson) => User.fromJson(userJson))
        .toList();
    groups = (jsonData['groups'] as List)
        .map((groupJson) => Group.fromJson(groupJson))
        .toList();
    trips = (jsonData['trips'] as List)
        .map((tripJson) => Trip.fromJson(tripJson))
        .toList();
  }

  void selectUser(User user) {
    selectedUser = user;
  }

  User? getUserByUsername(String username) {
    return users.firstWhere((user) => user.name == username);
  }

  List<Trip> getTripsForUser(String username) {
    User? user = getUserByUsername(username);
    if (user == null) {
      return [];
    }
    return trips.where((trip) => trip.members.contains(user.name)).toList();
  }

  List<Group> getGroupsFromUser(User user) {
    return groups.where((group) => group.members.contains(user)).toList();
  }

  List<String> collectAllTags() {
    final allTags = <String>{}; //set -> to not collect the duplicate

    for (var place in places) {
      final tags = place.tag.split(',').map((tag) => tag.trim());

      allTags.addAll(tags);
    }

    //Convert set -> list and sort it
    final sortedTags = allTags.toList()..sort();

    return sortedTags;
  }

  List<Place> getPlacesfromKeyword(String tag) {
    return places.where((place) => place.tag.contains(tag)).toList();
  }

  void addPlan(Trip trip, Plan plan) {
    //That trip already has Plan list
    for (var tp in tripPlans) {
      if (tp.keys.first == trip) {
        tp[trip]!.add(plan);
        return;
      }
    }
    //That Trip dont have Plan yet -> create new one
    tripPlans.add({
      trip: [plan]
    });
  }

  void addTrip(String name, List<String> membrs) {
    String lastId = trips.last.id;
    int lastNumericPart = int.parse(lastId.replaceAll(RegExp(r'[^0-9]'), ''));

    String newId = 'trip${lastNumericPart + 1}';

    Trip newTrip = Trip(
        id: newId,
        name: name,
        members: membrs,
        status: "not_select_date",
        topPlaces: []);
    trips.add(newTrip);
  }
}
