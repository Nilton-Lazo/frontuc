import 'package:flutter/material.dart';
import 'app_styles.dart';
import 'app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonBackground,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Image.asset(
                'assets/google_logo.png',
                height: 24,
              ),
            ),
            Expanded(
              child: Center(
                child: Text("Continuar con Google", style: AppStyles.buttonTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
