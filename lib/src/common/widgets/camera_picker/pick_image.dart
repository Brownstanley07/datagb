import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../extension/translation_extension.dart';

import '../../../utils/constants/app_colors.dart';

class ImagePickerField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final File? selectedImage;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color borderColor;
  final Color? iconColor;
  final Color labelColor;
  final VoidCallback? onTapCamera;
  final String? errorText;

  const ImagePickerField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.selectedImage,
    this.height,
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.iconColor,
    this.labelColor = AppColors.textPrimary,
    this.onTapCamera,
    this.backgroundColor,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        /// Label + Required Mark
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(letterSpacing: 0, color: labelColor),
            children: [
              if (isRequired)
                const TextSpan(
                  text: " *",
                  style: TextStyle(letterSpacing: 0, color: Colors.red),
                ),
            ],
          ),
        ),
        SizedBox(height: 6.h),

        /// Main Field
        FormField<File>(
          validator: (_) => errorText,
          builder: (FormFieldState<File> state) {
            return GestureDetector(
              onTap: onTapCamera,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  color: (errorText != null || state.hasError)
                      ? AppColors.error
                      : AppColors.primary.withAlpha(200),
                  strokeWidth: 1.w,
                  dashPattern: const [6, 6],
                  radius: const Radius.circular(18).w,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor ?? AppColors.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(borderRadius ?? 16).w,
                  ),
                  child: selectedImage == null
                      ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 37.h),
                          child: Column(
                            mainAxisAlignment: .center,
                            children: [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 18.w,
                                color:
                                    iconColor ?? AppColors.grey.withAlpha(150),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                state.hasError && state.errorText != null
                                    ? state.errorText!
                                    : "${'withdraw.upload'.trns()} $label",
                                style: TextStyle(
                                  letterSpacing: 0,
                                  color:
                                      state.hasError && state.errorText != null
                                      ? AppColors.error
                                      : iconColor ??
                                            AppColors.grey.withAlpha(150),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(
                            borderRadius ?? 16,
                          ).w,
                          child: Image.file(
                            selectedImage!,
                            width: double.infinity,
                            height: height,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 12.w),
            child: Text(
              errorText!,
              style: TextStyle(
                letterSpacing: 0,
                color: AppColors.error,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
