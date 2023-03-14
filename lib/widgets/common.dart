import 'package:flutter/material.dart';

Widget customText(String label, {Color? color}) {
  return Text(
    label,
    style: TextStyle(
      color: color ?? Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 19,
      fontFamily: "PublicSans",
    ),
  );
}

Widget customTextInputField(
    TextEditingController controller, String hinttext, IconData icon) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: hinttext,
      border: const OutlineInputBorder(),
    ),
  );
}

Widget makeInput({controller, label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!)),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ],
  );
}
