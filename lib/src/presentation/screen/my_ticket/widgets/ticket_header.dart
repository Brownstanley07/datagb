import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/ticket_message_response_model.dart';
import 'message_attachment.dart';
import '../../../../utils/constants/app_colors.dart';

class TicketHeader extends StatelessWidget {
  final MessageTicket? ticket;
  const TicketHeader({super.key, this.ticket});

  @override
  Widget build(BuildContext context) {
    if (ticket == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.82,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 18.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (ticket?.attachment?.isNotEmpty ?? false)
                    MessageAttachmentsRow(
                      attachments: ticket?.attachment ?? '',
                    ),
                  Text(
                    ticket!.message ?? '',
                    softWrap: true,
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 14.sp,
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    ticket!.createdAt ?? '',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 11.sp,
                      color: AppColors.white.withAlpha(200),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
