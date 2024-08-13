import 'package:flutter/material.dart';

class EqTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? autofocus;
  final bool? isobsecureText;
  final String? obsecureCharacter;
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;

  final VoidCallback onTap;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;

  const EqTextField(
      {super.key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.autofocus = false,
      this.isobsecureText = false,
      this.obsecureCharacter = '*',
      required this.hintText,
      required this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.textInputAction,
      required this.onTap,
      required this.onChanged,
      this.validator});

  @override
  Widget build(BuildContext context) {
    //double ht = MediaQuery.of(context).size.height;
    //double width = MediaQuery.of(context).size.width;

    //xxx = this.hintText;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextFormField(
          textInputAction: TextInputAction.next,
          autofocus: autofocus!,
          textAlign: TextAlign.center,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isobsecureText!,
          obscuringCharacter: obsecureCharacter!,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(
              //fontFamily: 'verdana', //fontSize: 16,
              //fontWeight: FontWeight.bold
              ),
          decoration: InputDecoration(
            //contentPadding: EdgeInsets.only(top: 16.0),
            //constraints: BoxConstraints(maxHeight: ht * 0.065, maxWidth: width),
            //filled: true,
            //fillColor: Colors.white,
            labelStyle: TextStyle(
                //fontFamily: 'verdana',
                //fontSize: 20,
                //fontWeight: FontWeight.bold
                ),
            hintStyle: TextStyle(
                //fontFamily: 'verdana',
                //fontSize: 14,
                ///fontWeight: FontWeight.bold
                ),
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: UnderlineInputBorder(),
            // border: OutlineInputBorder(
            //     //borderRadius: BorderRadius.circular(30.0),
            //     borderSide: BorderSide(color: Colors.black, width: 1.0)),
            // focusedBorder: OutlineInputBorder(
            //     //borderRadius: BorderRadius.circular(30.0),
            //     borderSide: BorderSide(color: Colors.black, width: 1.0)),
            // enabledBorder: OutlineInputBorder(
            //     //borderRadius: BorderRadius.circular(30.0),
            //     borderSide: BorderSide(color: Colors.black, width: 1.0))
          ),
        ));
  }

  //_CustomTextFieldState createState() => _CustomTextFieldState();
}
