import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/models.dart';

class Just2 extends StatelessWidget {
  final Team team;
  const Just2({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return FutureBuilder(
        future: state.listTeamMemberships(teamId: team.$id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data.toMap();
            print(data);
            return Column(
              children: [
                ...data["memberships"].map(
                  (team) => ListTile(
                    title: Text(team['userName']),
                    subtitle: Text('PRN'),
                    leading: Icon(Icons.person),
                    trailing: Text(team['roles'].toString()),
                  ),
                ),
              ],
            );
          }
          return Container();
        });
  }
}
