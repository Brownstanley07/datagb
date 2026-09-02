import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/app_section_heading/app_section_heading.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import 'transaction_tile.dart';
import '../../../../utils/helper/spin_loader.dart';

import '../../../../utils/constants/app_colors.dart';
import '../controller/home_controller.dart';

class RecentTransactions extends GetView<HomeController> {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: .only(
          topLeft: .circular(30.r),
          topRight: .circular(30.r),
        ),
        boxShadow: [
          BoxShadow(color: AppColors.black.withAlpha(10), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          AppSectionHeading(
            text: "home.recentTransactions.title".trns(),
            onPressed: controller.onSeeAllTransactions,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SpinLoader.loader();
            }
            if (controller.transactions.isEmpty) {
              return Center(
                child: Text("home.recentTransactions.noTransaction".trns()),
              );
            }
            return Padding(
              padding: .only(left: 18.w, right: 18.w),
              child: Column(
                children: controller.transactions
                    .map((t) => TransactionTile(transaction: t))
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
