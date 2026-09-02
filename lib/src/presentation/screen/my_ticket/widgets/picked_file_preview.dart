import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/my_ticket_controller.dart';
import '../../../../utils/constants/app_colors.dart';

class PickedFilesPreview extends StatelessWidget {
  final MyTicketController controller;
  const PickedFilesPreview({super.key, required this.controller});

  bool _isImage(String path) {
    final l = path.toLowerCase();
    return l.endsWith('.png') ||
        l.endsWith('.jpg') ||
        l.endsWith('.jpeg') ||
        l.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    final keys = controller.pickedReplyFiles.keys.toList();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: keys.map((k) {
          final file = controller.pickedReplyFiles[k]!;
          if (_isImage(file.path)) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    file,
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      controller.removeFile(k);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.black.withValues(alpha: 0.6),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        size: 16.r,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            final filename = file.path.split(Platform.pathSeparator).last;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.grey.withAlpha(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.insert_drive_file),
                  SizedBox(width: 8.w),
                  Text(
                    filename,
                    style: TextStyle(letterSpacing: 0, fontSize: 12.sp),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      controller.removeFile(k);
                    },
                    child: Icon(
                      Icons.close,
                      size: 18.r,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            );
          }
        }).toList(),
      ),
    );
  }
}
