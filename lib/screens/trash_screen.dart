import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Trash extends StatelessWidget {
  Trash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                state.markPresenty(
                    context: context,
                    docId: "6405d2868734ecb760fa",
                    teamId: "640492a1a089cfa256c0");
              },
              child: const Text('MARK'),
            ),
            ElevatedButton(
              onPressed: () {
                state.createAttendance(teamId: "640492a1a089cfa256c0");
              },
              child: const Text('START'),
            ),
            ElevatedButton(
              onPressed: () {
                state.listAllDocsOfTeam(teamId: "640492a1a089cfa256c0");
              },
              child: const Text('FETCH'),
            ),
            ElevatedButton(
              onPressed: () {
                state.markPresenty(context: context,
                    docId: "6405d2868734ecb760fa",
                    teamId: "640492a1a089cfa256c0");
              },
              child: const Text('MARK'),
            ),
            // StreamBuilder(
            //     stream: state.getLatestPresenty(docId: "6405d2868734ecb760fa"),
            //     builder: (context, AsyncSnapshot snapshot) {
            //       if (snapshot.hasData) {
            //         List students = snapshot.data.payload['presentId'];
            //         return ListView.builder(
            //             shrinkWrap: true,
            //             itemCount: students.length,
            //             itemBuilder: (context, index) {
            //               print(students[index]);
            //               return ListTile(
            //                 title: Text(students[index]),
            //               );
            //             });
            //       }
            //       return Container();
            //     }),
          ],
        ),
      ),
    );
  }
}
