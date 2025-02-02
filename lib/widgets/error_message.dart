import 'package:flutter/material.dart';
import '../theme/app_styles.dart';
import '../theme/app_colors.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.errorBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.errorBorder, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.textError, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppStyles.errorTextStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
