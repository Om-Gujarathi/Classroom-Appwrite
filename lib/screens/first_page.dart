import 'package:appwrite/models.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:attendance/widgets/team_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return SafeArea(
      child: Column(
        children: [
          FutureBuilder(
            future: state.listTeams(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data.toMap();
                return Column(
                  children: [
                    ...data["teams"].map(
                      (team) => TeamCard(team: Team.fromMap(team)),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
