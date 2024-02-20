import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
   ListButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10,bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(buttonText,
              style: TextStyle(fontSize: 20,color: Colors.blue.shade800)),
        ),
      ),
    );
  }
}
