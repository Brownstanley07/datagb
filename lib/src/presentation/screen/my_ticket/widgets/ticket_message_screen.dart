import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import 'input_area.dart';
import 'message_bubble.dart';
import 'picked_file_preview.dart';
import 'ticket_header.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../controller/my_ticket_controller.dart';

class TicketMessageScreen extends StatefulWidget {
  final String ticketId;

  const TicketMessageScreen({super.key, required this.ticketId});

  @override
  State<TicketMessageScreen> createState() => _TicketMessageScreenState();
}

class _TicketMessageScreenState extends State<TicketMessageScreen> {
  final MyTicketController controller = Get.find<MyTicketController>();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      controller.getMessage(widget.ticketId);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.ticketId,
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),

        backgroundColor: AppColors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: () => controller.markAsCompleted(widget.ticketId),
            child: Obx(
              () => Container(
                padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                margin: EdgeInsets.only(right: 18.w),
                decoration: BoxDecoration(
                  color: controller.messageTicket.value?.status == 'Open'
                      ? AppColors.error.withAlpha(15)
                      : AppColors.success.withAlpha(15),
                  borderRadius: BorderRadius.circular(36.r),
                ),
                child: Text(
                  controller.messageTicket.value?.status == 'Open'
                      ? 'myTicket.messageScreen.closeTicketButton'.trns()
                      : 'myTicket.messageScreen.reopenTicketButton'.trns(),
                  style: TextStyle(
                    letterSpacing: 0,
                    color: controller.messageTicket.value?.status == 'Open'
                        ? AppColors.error
                        : AppColors.success,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loadMessage.value || controller.isClose.value) {
          return SpinLoader.loader();
        }

        final data = controller.message.value;
        if (data == null) {
          return Center(
            child: Text('myTicket.messageScreen.noTicketData'.trns()),
          );
        }

        final ticket = data.ticket;
        final messages = data.messages ?? [];
        return RefreshIndicator(
          onRefresh: () => controller.refreshMessage(widget.ticketId),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: controller.messageScrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 18.h),
                      TicketHeader(ticket: ticket),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 18.w),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                          itemBuilder: (_, index) {
                            final msg = messages[index];
                            return MessageBubble(
                              msg: msg,
                              isAdmin: msg.isAdmin ?? false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.pickedReplyFiles.isNotEmpty)
                PickedFilesPreview(controller: controller),
              controller.messageTicket.value?.status == 'Open'
                  ? InputArea(controller: controller, ticketId: widget.ticketId)
                  : const SizedBox.shrink(),
            ],
          ),
        );
      }),
    );
  }
}
