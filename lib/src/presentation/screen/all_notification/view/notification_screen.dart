import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../controller/notification_controller.dart';
import '../model/notification_response_model.dart';
import '../widgets/notification_tile.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 30.h),
              color: bgColor,
              width: double.infinity,
              child: CommonHeader(
                title: "notification.title".trns(),
                icon: Icons.done_all,
                onTap: controller.loadMarkAllAsReadNotifications,
              ),
            ),
            SizedBox(height: 15.h),

            Expanded(
              child: Stack(
                children: [
                  RefreshIndicator(
                    color: AppColors.primary,
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    onRefresh: () => controller.loadNotifications(),
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return SpinLoader.loader();
                      }

                      if (controller.filteredNotifications.isEmpty) {
                        return LayoutBuilder(
                          builder: (context, constraints) => ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: constraints.maxHeight,
                                child: Center(
                                  child: Text(
                                    "notification.noNotification".trns(),
                                    style: TextStyle(color: titleColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView(
                        controller: controller.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        clipBehavior: Clip.hardEdge,
                        padding: EdgeInsets.only(
                          left: 18.w,
                          right: 18.w,
                          top: 5.h,
                        ),
                        children: controller.filteredNotifications.entries.map((
                          entry,
                        ) {
                          String dateLabel = entry.key;
                          List<Notifications> list = entry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 14.h),
                              Text(
                                dateLabel,
                                style: TextStyle(
                                  letterSpacing: 0,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: titleColor,
                                ),
                              ),
                              SizedBox(height: 10.h),

                              ...list.map(
                                (n) => NotificationTile(notification: n),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Obx(
              () => controller.isMoreLoading.value
                  ? Padding(
                      padding: EdgeInsets.all(10.0.w),
                      child: SpinLoader.loader(size: 30),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
