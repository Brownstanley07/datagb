import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../model/ticket_response_model.dart';
import '../widgets/ticket_message_screen.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../controller/my_ticket_controller.dart';

class MyTicketScreen extends GetView<MyTicketController> {
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CommonHeader(title: 'myTicket.title'.trns()),
            SizedBox(height: 12.h),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }

                if (controller.tickets.isEmpty) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => controller.refreshTickets(),
                    child: LayoutBuilder(
                      builder: (context, constraints) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: constraints.maxHeight,
                            child: Center(
                              child: Text(
                                'myTicket.noTicketsYet'.trns(),
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () => controller.refreshTickets(),
                        child: _ticketList(),
                      ),
                    ),
                    _createNewButton(),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketList() {
    return Obx(() {
      return ListView.separated(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(18.w),
        itemCount:
            controller.tickets.length + (controller.isLoadMore.value ? 1 : 0),
        itemBuilder: (_, index) {
          if (index >= controller.tickets.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: SpinLoader.loader(size: 30),
            );
          }

          final Ticket t = controller.tickets[index];
          return _ticketCard(t);
        },
        separatorBuilder: (_, index) => index >= controller.tickets.length - 1
            ? const SizedBox.shrink()
            : SizedBox(height: 14.h),
      );
    });
  }

  Widget _ticketCard(Ticket? ticket) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${'myTicket.ticketID'.trns()} #${ticket?.id ?? ''}",
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ticket?.status?.toLowerCase() == 'open'
                      ? AppColors.success.withValues(alpha: .15)
                      : AppColors.error.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  ticket?.status?.toLowerCase() == 'open'
                      ? 'myTicket.statusOpen'.trns()
                      : 'myTicket.statusClosed'.trns(),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: ticket?.status?.toLowerCase() == 'open'
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 13.h),

          Text(
            ticket?.title ?? '',
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${'myTicket.createdOn'.trns()} ${ticket?.createdAt}",
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 12.sp,
                    color: AppColors.muted,
                  ),
                ),
              ),

              if (ticket?.lastReply != null)
                Expanded(
                  child: Text(
                    "${'myTicket.lastReply'.trns()} ${ticket?.lastReply}",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 12.sp,
                      color: AppColors.muted,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 20.h),
          AppButton(
            text: 'myTicket.viewButton'.trns(),
            onPressed: () => Get.to(
              () =>
                  TicketMessageScreen(ticketId: ticket?.uuid?.toString() ?? ''),
            ),
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            textStyle: TextStyle(
              letterSpacing: 0,
              color: AppColors.primary,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createNewButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: AppButton(
        text: 'myTicket.createNewTicketButton'.trns(),
        onPressed: () => Get.toNamed(BaseRoute.createNewTicket),
      ),
    );
  }
}
