import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../extension/translation_extension.dart';

import '../../../utils/constants/app_colors.dart';

class FilePickerField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final File? selectedFile;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color labelColor;
  final VoidCallback? onFilePicked;
  final String? errorText;
  final String? existingFileUrl;

  const FilePickerField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.selectedFile,
    this.height,
    this.borderRadius,
    this.iconColor,
    this.labelColor = AppColors.textPrimary,
    this.onFilePicked,
    this.backgroundColor,
    this.errorText,
    this.existingFileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        FormField<File>(
          initialValue: selectedFile,
          validator: (_) => errorText,
          builder: (FormFieldState<File> state) {
            return GestureDetector(
              onTap: onFilePicked,
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

                  child: _buildChild(state),
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

  Widget _buildChild(FormFieldState<File> state) {
    /// New file selected
    if (selectedFile != null) {
      final fileName = selectedFile!.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      final isImage = ['jpg', 'jpeg', 'png'].contains(fileExtension);

      if (isImage) {
        // Display image preview
        return ClipRRect(
          borderRadius: BorderRadius.circular((borderRadius ?? 16)).w,
          child: Image.file(
            selectedFile!,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        );
      } else {
        // Display file name for other file types
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 12.w),
          child: Row(
            children: [
              Icon(Icons.upload_file, size: 22.w, color: AppColors.primary),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(letterSpacing: 0, fontSize: 12.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }
    }

    /// Existing file from URL
    if (existingFileUrl != null && existingFileUrl!.isNotEmpty) {
      final isSvg = existingFileUrl!.toLowerCase().endsWith('.svg');
      return Row(
        children: [
          isSvg
              ? Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular((borderRadius ?? 16)).w,
                    child: SvgPicture.network(
                      existingFileUrl!,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular((borderRadius ?? 16)).w,
                    child: Image.network(
                      existingFileUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: AppColors.shimmerBase,
                          highlightColor: AppColors.shimmerHighlight,
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.shimmerBase,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  ),
                ),
          // SizedBox(width: 10.w),
          // Expanded(
          //   child: Text(
          //     existingFileUrl!.split("/").last,
          //     style: TextStyle( letterSpacing: 0,fontSize: 12.sp),
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
        ],
      );
    }

    /// Placeholder for upload
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            size: 22.w,
            color: iconColor ?? AppColors.grey.withAlpha(150),
          ),
          SizedBox(height: 6.h),
          Text(
            state.hasError && state.errorText != null
                ? state.errorText!
                : "${'withdraw.upload'.trns()} $label",
            style: TextStyle(
              letterSpacing: 0,
              color: state.hasError && state.errorText != null
                  ? AppColors.error
                  : iconColor ?? AppColors.grey.withAlpha(150),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
