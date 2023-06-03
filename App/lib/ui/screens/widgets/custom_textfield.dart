import 'package:flutter/material.dart';
import 'package:green_garden/constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String?)? onSaved;
  final FormFieldValidator<String>? validator;
  final IconData icon;
  final bool obscureText;
  final String hinText;
  const CustomTextField({Key? key,  required this.icon, required this.obscureText, required this.hinText, this.validator,  this.onSaved, this.controller, }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}
class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onSaved: widget.onSaved,
      validator: widget.validator,
      obscureText: widget.obscureText,
      style: TextStyle(
        color: Constants.blackColor,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        prefixIcon: Icon(widget.icon, color: Constants.blackColor.withOpacity(.3),),
        hintText: widget.hinText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),

      ),
      cursorColor: Constants.blackColor.withOpacity(.5),
    );

  }

}