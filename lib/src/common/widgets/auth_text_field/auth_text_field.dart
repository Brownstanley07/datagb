import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants/app_colors.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isVisible, isRequired;
  final VoidCallback? onVisibilityToggle;
  final IconData? icon;
  final bool showIcon, showImageIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final FontWeight? labelFontWeight;
  final double? labelFontSize;
  final int? maxLines;
  final String symbol;
  final bool readOnly;
  final void Function()? onTap;
  final bool showLevel;
  final List<String>? autofillHints;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.icon,
    this.isPassword = false,
    this.isVisible = false,
    this.isRequired = true,
    this.showIcon = true,
    this.showImageIcon = false,
    this.onVisibilityToggle,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.labelFontWeight = FontWeight.w500,
    this.labelFontSize,
    this.maxLines = 1,
    this.symbol = '',
    this.readOnly = false,
    this.onTap,
    this.showLevel = true,
    this.autofillHints,
    this.onEditingComplete,
    this.textInputAction,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLevel) ...[
          Text.rich(
            TextSpan(
              text: label,
              style: TextStyle(
                color: dark ? Colors.white : AppColors.textPrimary,
                fontWeight: labelFontWeight,
                fontSize: labelFontSize ?? 12.5.sp,
              ),
              children: isRequired
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ]
                  : const [],
            ),
          ),
          SizedBox(height: 7.h),
        ],
        TextFormField(
          controller: controller,
          obscureText: isPassword && !isVisible,
          validator: validator,
          readOnly: readOnly,
          maxLines: maxLines,
          onChanged: onChanged,
          onTap: onTap,
          keyboardType: keyboardType,
          autofillHints: autofillHints,
          onEditingComplete: onEditingComplete,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: dark ? Colors.white : AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: showIcon
                ? Icon(
                    icon ?? Icons.person_outline_rounded,
                    size: 19.sp,
                    color: AppColors.textTertiary,
                  )
                : null,
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onVisibilityToggle,
                    icon: Icon(
                      isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19.sp,
                      color: AppColors.textTertiary,
                    ),
                  )
                : null,
            filled: true,
            fillColor: dark
                ? const Color(0xFF19261F)
                : AppColors.textfieldColor,
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 13.sp,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 15.h,
            ),
            border: _border(AppColors.border),
            enabledBorder: _border(dark ? Colors.white12 : AppColors.border),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(13.r),
        borderSide: BorderSide(color: color, width: width),
      );
}
