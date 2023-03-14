import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        state.logout();
      }),
      body: Column(
        children: [
          Center(
            child: Text('HOME'),
          ),
          ElevatedButton(
            onPressed: () {
              state.createTeam(name: 'THE BOYS');
            },
            child: Text('Create Team'),
          ),
          ElevatedButton(
            onPressed: () {
            },
            child: Text('Invite Om'),
          ),
          ElevatedButton(
            onPressed: () {
              state.acceptTeamInvite();
            },
            child: Text('ACCEPT'),
          ),
          FutureBuilder(
              future: state.listTeams(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.toMap();
                  print(data);
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...data["teams"].map((team) => ListTile(
                            title: Text(team['name']),
                          ))
                    ],
                  );
                }
                return Container();
              })
        ],
      ),
    );
  }
}
