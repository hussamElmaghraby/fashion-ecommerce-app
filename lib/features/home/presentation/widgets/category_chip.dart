import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.paddingSM),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          label: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: AppDimensions.fontSM,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
            ),
          ),
          backgroundColor: isSelected ? AppColors.primary : AppColors.backgroundGrey,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingMD,
            vertical: AppDimensions.paddingSM,
          ),
        ),
      ),
    );
  }
}
