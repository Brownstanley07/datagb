import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/app_colors.dart';

class PhoneField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String countryCode;
  final String? Function(String?)? validator;
  final bool isRequired;

  const PhoneField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.countryCode,
    this.validator,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text.rich(
          TextSpan(
            text: "$label ",
            style: TextStyle(
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            children: [
              isRequired
                  ? const TextSpan(
                      text: "*",
                      style: TextStyle(letterSpacing: 0, color: Colors.red),
                    )
                  : const TextSpan(),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(letterSpacing: 0, color: AppColors.grey),
            filled: true,
            fillColor: AppColors.textfieldColor,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 6.0).r,
              child: Container(
                margin: const EdgeInsets.all(4).w,
                decoration: BoxDecoration(
                  color: AppColors.grey.withAlpha(45),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone,
                  color: AppColors.primary.withAlpha(200),
                ),
              ),
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    countryCode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14).r,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20).w,
              borderSide: BorderSide(color: AppColors.primary.withAlpha(200)),
            ),
          ),
        ),
      ],
    );
  }
}
