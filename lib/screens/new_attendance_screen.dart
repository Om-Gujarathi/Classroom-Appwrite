import 'package:appwrite/appwrite.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:attendance/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/models.dart';
import 'package:provider/provider.dart';

class Attendance extends StatefulWidget {
  final Team team;
  const Attendance({super.key, required this.team});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isOwner = false;
  String? docId;
  bool currStatus = true;
  RealtimeSubscription? subscription;

  @override
  void initState() {
    onTeamFormed();
    super.initState();
  }

  void onTeamFormed() async {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    docId = await state.createAttendance(teamId: widget.team.$id);
    subscription = state.getLatestPresenty(docId: docId!);
    isOwner = await state.getTeamOwner(docId: docId!);
    print(isOwner);
    setState(() {});
    print(docId);
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text('A T T E N D A N C E'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              state.whenPresentyStopped(subscription: subscription!);
              if (currStatus) {
                state.stopOrStartAttendance(
                    docId: docId!, currStatus: currStatus);
                currStatus = !currStatus;
              }
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isOwner)
              ElevatedButton(
                onPressed: () {
                  state.stopOrStartAttendance(
                      docId: docId!, currStatus: currStatus);
                  currStatus = !currStatus;
                },
                child: const Text('STOP/START'),
              ),
            if (!isOwner)
              ElevatedButton(
                onPressed: () {
                  state.markPresenty(
                      context: context, docId: docId!, teamId: widget.team.$id);
                },
                child: const Text('MARK'),
              ),
            if (docId != null && subscription != null)
              StreamBuilder(
                  stream: subscription!.stream,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List students = snapshot.data.payload['presentId'];
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.people_alt),
                                  customText(students.length.toString()),
                                  const Text(
                                    'Present Students',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  const Icon(Icons.class_),
                                  customText(widget.team.total.toString()),
                                  const Text(
                                    'Total Students',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300),
                                  )
                                ],
                              ),
                            ],
                          ),
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              print(students[index]);
                              return FutureBuilder(
                                future: state.getUserFromId(
                                    userId: students[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Card(
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data!.name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        trailing: Icon(Icons.check_circle,
                                            color: Colors.green),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 5.0),
                                      color: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return Text('NOONE');
                    }
                  }),
            Container(),
          ],
        ),
      )),
    );
  }
}
