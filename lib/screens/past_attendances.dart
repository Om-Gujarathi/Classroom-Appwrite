import 'package:appwrite/models.dart';
import 'package:attendance/models/attendance_model.dart';
import 'package:attendance/screens/that_class_attendance.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Previous extends StatelessWidget {
  final Team team;
  const Previous({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return SingleChildScrollView(
      child: FutureBuilder(
          future: state.listAllDocsOfTeam(teamId: team.$id),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data.toMap();
              print(data.toString());
              int lectures = data["total"];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'RECENT CLASSES : $lectures',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...data["documents"].map(
                    (doc) => ListTile(
                      title: Text(DateFormat('MMMM d, h:mm a')
                          .format(DateTime.parse(doc["data"]["date"]))
                          .toString()),
                      onTap: () {
                        Attend attend = Attend(
                            docId: doc["\$id"],
                            teamId: doc["data"]["teamId"],
                            status: doc["data"]["status"],
                            presentId: doc["data"]["presentId"]);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LastScreen(attendance: attend)));
                      },
                    ),
                  )
                ],
              );
            }
            return Container();
          }),
    );
  }
}
