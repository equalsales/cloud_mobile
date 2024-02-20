import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
   GenerateButton({
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
          backgroundColor: Colors.green.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(buttonText,
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,fontFamily: "vardana",color: Colors.white)),
        ),
      ),
    );
  }
}
