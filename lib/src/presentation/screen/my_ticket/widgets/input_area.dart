import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/my_ticket_controller.dart';
import '../../../../utils/constants/app_colors.dart';

class InputArea extends StatelessWidget {
  final MyTicketController controller;
  final String ticketId;

  const InputArea({
    super.key,
    required this.controller,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        color: AppColors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // file picker

            // message input
            Expanded(
              child: TextFormField(
                controller: controller.replyController,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'myTicket.messageScreen.writeMessageHint'.trns(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  filled: true,
                  fillColor: AppColors.textfieldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () => controller.pickReplyFile(),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withAlpha(25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: const Icon(Icons.attach_file, color: AppColors.grey),
              ),
            ),

            SizedBox(width: 12.w),
            Obx(
              () => GestureDetector(
                onTap: controller.isSending.value
                    ? null
                    : () => controller.sendReply(ticketId),
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: controller.isSending.value
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Icon(Icons.send, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
