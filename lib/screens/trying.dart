import 'package:appwrite/models.dart';
import 'package:attendance/screens/new_attendance_screen.dart';
import 'package:attendance/screens/past_attendances.dart';
import 'package:attendance/screens/t2_screen.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:attendance/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewPage extends StatefulWidget {
  final Team team;
  const NewPage({super.key, required this.team});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  void _showDialog() {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController _addEmail = TextEditingController();
          return AlertDialog(
            title: const Text('Add Member'),
            content: customTextInputField(
                _addEmail, 'Email ID', Icons.email_outlined),
            actions: [
              MaterialButton(
                onPressed: () {
                  state.inviteToTeam(
                      teamId: widget.team.$id, emailId: _addEmail.text);
                },
                color: Colors.deepPurpleAccent,
                elevation: 0,
                child: const Text('Add'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: Colors.pink,
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => Attendance(team: widget.team)));
        //     },
        //     child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text('A T T E N D A N C E'),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: _showDialog,
                icon: const Icon(
                  Icons.new_label,
                  color: Colors.white,
                ))
          ],
          backgroundColor: Colors.deepPurpleAccent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      widget.team.name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Students - ${widget.team.total}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.0),
            const TabBar(dividerColor: Colors.deepPurpleAccent, tabs: [
              Tab(
                icon: Icon(
                  Icons.history,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.people,
                  color: Colors.black,
                ),
              )
            ]),
            Expanded(
              child: TabBarView(children: [
                Previous(team: widget.team),
                Just2(team: widget.team),
              ]),
            ),
            if (state.user!.id != "6404718fbdb12b1e640f")
              Container(
                padding: EdgeInsets.all(16.0),
                child: FloatingActionButton(
                    backgroundColor: Colors.pink,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Attendance(team: widget.team)));
                    },
                    child: Icon(Icons.add)),
              )
          ],
        ),
      ),
    );
  }
}
