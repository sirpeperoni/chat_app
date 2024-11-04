import 'package:flutter/material.dart';
import 'package:flutter_chat_app/colors.dart';
import 'package:flutter_chat_app/theme.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final Function(String val) onchanged;
  final double height;
  final TextInputAction inputAction;
  const CustomTextField({
    super.key,
    required this.hint,
    this.height = 54.0,
    required this.onchanged,
    required this.inputAction
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration:  BoxDecoration(
        color: isLightTheme(context) ? Colors.white : kBubbleDark,
        border: Border.all(
          color: isLightTheme(context) ? const Color(0xFFC4C4C4) : const Color(0xFF393737),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(45)
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onchanged,
        textInputAction: inputAction,
        cursorColor: kPrimary,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          hintText: hint,
          border: InputBorder.none
        ),
      ),
    );
  }
}