import 'package:attendance/models/attendance_model.dart';
import 'package:attendance/models/user_model.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LastScreen extends StatelessWidget {
  final Attend attendance;
  const LastScreen({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(attendance.isOwner.toString()),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            if (!attendance.isOwner)
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.pink),
                  ),
                  onPressed: () {
                    state.markPresenty(
                        context: context,
                        docId: attendance.docId,
                        teamId: attendance.teamId);
                  },
                  child: Text("Mark")),
            SizedBox(height: 20.0),
            Text(
              'Present Students',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: FutureBuilder(
                future: Future.wait(
                  attendance.presentId
                      .map((id) => state.getUserFromId(userId: id))
                      .toList(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<User> users = snapshot.data as List<User>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${users.length}',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  title: Text(
                                    users[index].name,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Icon(Icons.check_circle,
                                      color: Colors.green),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 5.0),
                                color: Colors.grey[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
