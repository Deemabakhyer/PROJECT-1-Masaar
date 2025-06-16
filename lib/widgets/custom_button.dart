import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onPressed,
  });
  final String text;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isPressed = false;

  void setPressed(bool pressed) {
    setState(() {
      isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF6A42C2), // Button color
        borderRadius: BorderRadius.circular(100),
        boxShadow:
            isPressed
                ? [
                  BoxShadow(
                    color: const Color(0xFF563B9C), // purple shadow
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [],
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed, //important with clicking
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            374,
            60,
          ), // the Width and Height of the button
          backgroundColor: const Color(0xFF6A42C2), // button color

          foregroundColor: Colors.white, //text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: widget.isActive ? 0 : 3,

          shadowColor: Color(0xFF563B9C),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(
                0xFF563B9C,
              ).withOpacity(0.2); // darker when pressed
            }
            return null;
          }),
        ),
        child: Text(
          widget.text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.33,
          ),
        ),
      ),
    );
  }
}
// how to use the wiget
// CustomButton(text: " ",isActive: true, onPressed: () {}, ),