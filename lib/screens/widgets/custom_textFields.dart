// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String suffix;
  final bool obscure;
  final TextEditingController? controller;
  const CustomTextField(
      {this.suffix = '', this.obscure = false, this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(.7),
          border: InputBorder.none,
          suffixIcon: Text(
            '$suffix    ',
            style: TextStyle(
              color: Colors.black.withOpacity(0.65),
              fontSize: 13,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.07,
            ),
          ),
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}

class CustomTextField2 extends StatefulWidget {
  final String hint;
  final bool padding;
  final bool? readOnly;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  const CustomTextField2({
    super.key,
    required this.hint,
    required this.padding,
    this.controller,
    this.onChanged,
    this.readOnly,
  });

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  TextEditingController? textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.controller == null && widget.hint != 'Medicine') {
      textEditingController = TextEditingController()..text = widget.hint;
    } else {
      textEditingController = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding
          ? const EdgeInsets.symmetric(vertical: 5.0)
          : EdgeInsets.zero,
      child: TextFormField(
        readOnly: widget.readOnly ?? false,
        controller: textEditingController,
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class CustomDigitField extends StatelessWidget {
  final TextEditingController? controller;
  const CustomDigitField({this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(.7),
          border: InputBorder.none,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
