import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/userDataModel.dart';
import 'substituteComp.dart';

class substituteList extends StatefulWidget {
  const substituteList(
      {Key? key,
      required this.id,
      required this.footballLineupByMatchId,
      required this.isLoading})
      : super(key: key);

  final String id;
  final Map<String, dynamic> footballLineupByMatchId;
  final bool isLoading;

  @override
  State<substituteList> createState() => substituteListState(
      id: id,
      footballLineupByMatchId: footballLineupByMatchId,
      isLoading: isLoading);
}

class substituteListState extends State<substituteList> {
  final String id;
  final Map<String, dynamic> footballLineupByMatchId;
  final isLoading;
  UserDataModel UserModel = Get.find<UserDataModel>();

  substituteListState(
      {required this.id,
      required this.footballLineupByMatchId,
      required this.isLoading});

  void initState() {
    super.initState();
  }

  final List<Map<String, dynamic>> teamASubstitutes = [];

  final List<Map<String, dynamic>> teamBSubstitutes = [];

  @override
  Widget build(BuildContext context) {
    var homeMatchLineUpList = footballLineupByMatchId['homeMatchLineUpList'];
    var awayMatchLineUpList = footballLineupByMatchId['awayMatchLineList'];

    if (homeMatchLineUpList != null) {
      if (teamASubstitutes.isEmpty) {
        for (var player in homeMatchLineUpList) {
          int first = player["first"];

          if (first == 0) {
            String fullName = player['playerName'];
            // Split the full name by either '.' or '·'
            List<String> nameParts = fullName.split(RegExp(r'[·.]'));

            // Split the full name by either '.' or '·' or space
            List<String> namePartsEng = fullName.split(RegExp(r'[·.\s]'));

            // Get the last part of the split name
            String name =
                nameParts.isNotEmpty ? nameParts.last.trim() : fullName;

            // Get the last part of the split name
            String nameEng =
                nameParts.isNotEmpty ? namePartsEng.last.trim() : fullName;

            dynamic position;

            if (UserModel.isCN.value) {
              String positionAbbreviation = player['position'];
              position;

              // Map the position abbreviation to the full position name
              switch (positionAbbreviation) {
                case "F":
                  position = "前锋";
                  break;
                case "G":
                  position = "守门员";
                  break;
                case "D":
                  position = "后卫";
                  break;
                case "M":
                  position = "中锋";
                  break;
                default:
                  position =
                      positionAbbreviation; // Keep it as is if not matched
                  break;
              }
            }

            teamASubstitutes.add({
              'shirtNumber': player['shirtNumber'],
              'position': UserModel.isCN.value ? position : "",
              'playerName': UserModel.isCN.value ? name : nameEng,
              'color': Color.fromARGB(247, 218, 218, 218),
            });
          }
        }
      }
    }
    if (awayMatchLineUpList != null) {
      if (teamBSubstitutes.isEmpty) {
        for (var player in awayMatchLineUpList) {
          int first = player["first"];

          if (first == 0) {
            String fullName = player['playerName'];
            // Split the full name by either '.' or '·'
            List<String> nameParts = fullName.split(RegExp(r'[·.]'));

            // Split the full name by either '.' or '·' or space
            List<String> namePartsEng = fullName.split(RegExp(r'[·.\s]'));

            // Get the last part of the split name
            String name =
                nameParts.isNotEmpty ? nameParts.last.trim() : fullName;

            String nameEng =
                nameParts.isNotEmpty ? namePartsEng.last.trim() : fullName;

            dynamic position;

            if (UserModel.isCN.value) {
              String positionAbbreviation = player['position'];
              position;

              // Map the position abbreviation to the full position name
              switch (positionAbbreviation) {
                case "F":
                  position = "前锋";
                  break;
                case "G":
                  position = "守门员";
                  break;
                case "D":
                  position = "后卫";
                  break;
                case "M":
                  position = "中锋";
                  break;
                default:
                  position =
                      positionAbbreviation; // Keep it as is if not matched
                  break;
              }
            }

            teamBSubstitutes.add({
              'shirtNumber': player['shirtNumber'],
              'position': UserModel.isCN.value ? position : "",
              'playerName': UserModel.isCN.value ? name : nameEng,
              'color': Color.fromARGB(247, 218, 218, 218),
            });
          }
        }
      }
    }

    return isLoading
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0), // Adjust the value as needed
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children:
                            List.generate(teamASubstitutes.length, (index) {
                          final player = teamASubstitutes[index];
                          final backcolor = index.isOdd
                              ? Colors.transparent
                              : Color.fromARGB(247, 231, 231, 231);

                          return SubstituteComp(
                            textColor: Colors.white,
                            shirtNo: player['shirtNumber'],
                            playerName: player['playerName'],
                            circleColor: Color(0xFF1168B9),
                            position: player["position"],
                            backcolor: backcolor,
                          );
                        }),
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    children: List.generate(teamBSubstitutes.length, (index) {
                      final player = teamBSubstitutes[index];
                      final backcolor = index.isOdd
                          ? Colors.transparent
                          : Color.fromARGB(247, 231, 231, 231);

                      return SubstituteComp(
                        textColor: Colors.white,
                        shirtNo: player['shirtNumber'],
                        playerName: player['playerName'],
                        circleColor: Color(0xFFD043D3),
                        position: player['position'],
                        backcolor:
                            backcolor, // Use the calculated background color
                      );
                    }),
                  ),
                ),
              )
            ],
          );
  }
}