import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/ticket_message_response_model.dart';
import 'message_attachment.dart';
import '../../../../utils/constants/app_colors.dart';

class MessageBubble extends StatelessWidget {
  final Message msg;
  final bool isAdmin;
  const MessageBubble({super.key, required this.msg, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final bg = isAdmin
        ? AppColors.white
        : AppColors.primary.withValues(alpha: 0.8);
    final textColor = isAdmin ? AppColors.textPrimary : Colors.white;
    final radius = isAdmin
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(0),
          );
    if (kDebugMode) {
      print(' the image is ${msg.attachment}');
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: isAdmin
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.sizeOf(context).width * 0.45,
                maxWidth: MediaQuery.sizeOf(context).width * 0.82,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha(10),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isAdmin
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    if (msg.attachment?.isNotEmpty ?? false)
                      MessageAttachmentsRow(attachments: msg.attachment ?? ''),
                    Text(
                      msg.message ?? '',
                      softWrap: true,
                      style: TextStyle(
                        letterSpacing: 0,
                        color: textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      msg.createdAt ?? '',
                      style: TextStyle(
                        letterSpacing: 0,
                        color: isAdmin
                            ? AppColors.textPrimary.withAlpha(100)
                            : AppColors.white.withAlpha(200),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
