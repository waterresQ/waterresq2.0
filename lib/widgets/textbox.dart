import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class textbox extends StatefulWidget {
  const textbox(this.data, this.control, {super.key});
  final String data;
  final TextEditingController control;

  @override
  State<textbox> createState() => _textboxState();
}

class _textboxState extends State<textbox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20,left: 10,right: 10),
      child: TextFormField(
        controller: widget.control,
        style: GoogleFonts.jost(color: Colors.black),
        decoration: InputDecoration(
          hintText: widget.data,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20.0), // Set the border radius here
          ),
          filled: true,
          fillColor: Colors.white,
          hintStyle: GoogleFonts.jost(color: Colors.black),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Color of border when not focused
            ),
            borderRadius:
                BorderRadius.circular(20.0), // Set the border radius here
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Color of border when focused
            ),
            borderRadius:
                BorderRadius.circular(20.0), // Set the border radius here
          ),
        ),
      ),
    );
  }
}
