import 'package:appwrite/models.dart';
import 'package:attendance/screens/team_screen.dart';
import 'package:attendance/screens/trying.dart';
import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  const TeamCard({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: ListTile(
          leading: const Icon(Icons.data_object),
          title: Text(team.name),
          subtitle: const Text("Prof. Preeti Bailke"),
          trailing: const Icon(
            Icons.favorite_border,
            color: Colors.pink,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewPage(
                  team: team,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
