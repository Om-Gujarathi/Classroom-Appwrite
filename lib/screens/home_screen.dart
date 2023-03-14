import 'package:appwrite/models.dart';
import 'package:attendance/screens/create_class_screen.dart';
import 'package:attendance/screens/trash_screen.dart';
import 'package:attendance/services/auth_services.dart';
import 'package:attendance/widgets/team_card.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          FutureBuilder(
              future: state.listTeams(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.toMap();
                  // print(data);
                  return Column(
                    children: [
                      ...data["teams"]
                          .map((team) => TeamCard(team: Team.fromMap(team))),
                    ],
                  );
                }
                return Container();
              }),
        ],
      )),
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Join Class",
            iconColor: Colors.blue,
            bubbleColor: Colors.white,
            icon: Icons.join_inner,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontFamily: "PublicSans",
              fontWeight: FontWeight.bold,
            ),
            onPress: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Trash()));
            },
          ),
          Bubble(
            title: "Create Class",
            iconColor: Colors.blue,
            bubbleColor: Colors.white,
            icon: Icons.create,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontFamily: "PublicSans",
              fontWeight: FontWeight.bold,
            ),
            onPress: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateClass()))
                  .whenComplete(() {
                setState(() {});
              });
              _animationController.reverse();
            },
          ),
          Bubble(
            title: "LOGOUT",
            iconColor: Colors.blue,
            bubbleColor: Colors.white,
            icon: Icons.create,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontFamily: "PublicSans",
              fontWeight: FontWeight.bold,
            ),
            onPress: () {
              state.logout();
              _animationController.reverse();
            },
          ),
        ],
        iconColor: Colors.blue,
        iconData: FontAwesomeIcons.circlePlus,
        backGroundColor: Colors.white,
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
      ),
    );
  }
}
