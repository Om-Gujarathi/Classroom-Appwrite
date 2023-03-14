import 'package:appwrite/models.dart';
import 'package:attendance/screens/new_attendance_screen.dart';
import 'package:attendance/screens/t1_screen.dart';
import 'package:attendance/screens/t2_screen.dart';
import 'package:attendance/screens/team_members_screen.dart';
import 'package:attendance/screens/trash_screen.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:attendance/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeamScreen extends StatefulWidget {
  final Team team;
  const TeamScreen({super.key, required this.team});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  int _selectedTag = 0;

  void changeTab(int index) {
    setState(() {
      _selectedTag = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: [
            Center(child: customText(widget.team.name)),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Icon(Icons.people_alt),
                    customText(widget.team.total.toString()),
                    const Text(
                      'Students',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.mic),
                    customText('13'),
                    const Text(
                      'Lectures',
                      style: TextStyle(fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Attendance(team: widget.team)));
                  },
                  child: const Text('START NEW ATTENDANCE'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Members(team: widget.team)));
                  },
                  child: const Text('SEE TEAM MEMBERS'),
                ),
              ],
            ),
            const SizedBox(
              height: 18.0,
            ),
            // FutureBuilder(
            //     future: state.listAllDocsOfTeam(teamId: team.$id),
            //     builder: (context, AsyncSnapshot snapshot) {
            //       if (snapshot.hasData) {
            //         final data = snapshot.data.toMap();
            //         // print(data["documents"]);
            //         int lectures = data["total"];
            //         return Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Text(
            //               'PREVIOUS CLASSES : $lectures',
            //               style: TextStyle(fontWeight: FontWeight.bold),
            //             ),
            //             ...data["documents"].map(
            //                 (doc) => ListTile(title: Text(doc["data"]["date"])))
            //           ],
            //         );
            //       }
            //       return Container();
            //     }),

            CustomTabView(
              index: _selectedTag,
              changeTab: changeTab,
            ),
            _selectedTag == 0
                ? Previous(team: widget.team)
                : Just2(team: widget.team),
          ]),
        ),
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Function(int) changeTab;
  final int index;
  const CustomTabView({Key? key, required this.changeTab, required this.index})
      : super(key: key);

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  final List<String> _tags = ["Attendances", "People"];

  Widget _buildTags(int index) {
    return GestureDetector(
      onTap: () {
        widget.changeTab(index);
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: widget.index == index ? Colors.yellow : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _tags[index],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: widget.index != index ? Colors.black : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _tags
            .asMap()
            .entries
            .map((MapEntry map) => _buildTags(map.key))
            .toList(),
      ),
    );
  }
}

class Previous extends StatelessWidget {
  final Team team;
  const Previous({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return FutureBuilder(
        future: state.listAllDocsOfTeam(teamId: team.$id),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data.toMap();
            // print(data["documents"]);
            int lectures = data["total"];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'PREVIOUS CLASSES : $lectures',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...data["documents"]
                    .map((doc) => ListTile(title: Text(doc["data"]["date"])))
              ],
            );
          }
          return Container();
        });
  }
}
