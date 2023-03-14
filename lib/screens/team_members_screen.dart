import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appwrite/models.dart';

class Members extends StatelessWidget {
  final Team team;
  const Members({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          FutureBuilder(
              future: state.listTeamMemberships(teamId: team.$id),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.toMap();
                  print(data);
                  return Column(
                    children: [
                      ...data["memberships"].map(
                        (team) => ListTile(
                            subtitle: Text(team['userName']),
                            leading: CircleAvatar()),
                      ),
                    ],
                  );
                }
                return Container();
              }),
              
        ],
      )),
    );
  }
}
