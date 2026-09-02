import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/constants/app_colors.dart';
import 'package:get/get.dart';

class MessageAttachmentsRow extends StatelessWidget {
  final String attachments;
  const MessageAttachmentsRow({super.key, required this.attachments});

  bool _isImage(String? url) {
    if (url == null) return false;
    final l = url.toLowerCase();
    return l.endsWith('.png') ||
        l.endsWith('.jpg') ||
        l.endsWith('.jpeg') ||
        l.endsWith('.gif') ||
        l.contains('image');
  }

  @override
  Widget build(BuildContext context) {
    final isImage = _isImage(attachments);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: isImage
              ? GestureDetector(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(10.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            InteractiveViewer(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Image.network(
                                  attachments,
                                  fit: BoxFit.contain,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                  errorBuilder: (c, e, st) => const Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: AppColors.error,
                                      size: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: AppColors.error,
                                  size: 30,
                                ),
                                onPressed: () => Get.back(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      attachments,
                      width: double.infinity,
                      height: 120.h,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (c, e, st) => Container(
                        width: double.infinity,
                        height: 120.h,
                        alignment: Alignment.center,
                        color: AppColors.grey.withAlpha(30),
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.error,
                          size: 36.w,
                        ),
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: AppColors.white),
                    SizedBox(width: 8.w),
                    Text(
                      attachments,
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 12.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
