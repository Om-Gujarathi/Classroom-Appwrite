import 'package:attendance/services/auth_services.dart';
import 'package:attendance/widgets/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateClass extends StatelessWidget {
  CreateClass({Key? key}) : super(key: key);

  Color selectedColor = Colors.green;

  final TextEditingController _classroomnamecontroller =
      TextEditingController();

  final TextEditingController _classroomdescriptioncontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthState state = Provider.of<AuthState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        title: const Text(
          "Create Classroom",
          style: TextStyle(
            fontFamily: "PublicSans",
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              customText("Classroom Name"),
              const SizedBox(height: 9.0),
              customTextInputField(
                  _classroomnamecontroller, "Classroom Name", Icons.abc),
              const SizedBox(height: 16.0),
              customText("Classroom Description"),
              const SizedBox(height: 9.0),
              customTextInputField(_classroomdescriptioncontroller,
                  "Classroom Description", Icons.ac_unit),
              const SizedBox(height: 18.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    state.createTeam(name: _classroomnamecontroller.text);
                    Navigator.pop(context);
                  },
                  child: const Text("CREATE"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
