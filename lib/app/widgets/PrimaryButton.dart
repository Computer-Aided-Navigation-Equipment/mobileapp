import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cane_app/app/AppColors.dart';

class PrimaryButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.buttonText, // Button text as parameter
    required this.onPressed,   // onPressed callback as parameter
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed, // Uses the passed onPressed parameter
        child: Text(
          buttonText, // Uses the passed buttonText parameter
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.mainColor), // Set the background color
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Set the border radius to 20px
            ),
          ),
        ),
      ),
    );
  }
}
