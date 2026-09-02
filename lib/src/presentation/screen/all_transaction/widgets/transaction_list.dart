import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/all_transaction_controller.dart';
import 'single_transaction_tile.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';

class TransactionList extends GetView<AllTransactionController> {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark ? const Color(0xFF94A3B8) : AppColors.muted;

    return Obx(() {
      final transactions = controller.transactions;

      if (transactions.isEmpty) {
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 150.h),
            Icon(
              Icons.receipt_long_outlined,
              size: 48.sp,
              color: subtitleColor,
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                "allTransaction.noTransaction".trns(),
                style: TextStyle(color: titleColor, fontSize: 14.sp),
              ),
            ),
          ],
        );
      }

      return ListView.separated(
        controller: controller.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        itemCount: transactions.length + (controller.isLoadMore.value ? 1 : 0),
        separatorBuilder: (_, __) =>
            Divider(color: isDark ? const Color(0xFF334155) : AppColors.grey.withAlpha(50)),
        itemBuilder: (_, i) {
          if (i < transactions.length) {
            return TransactionTile(transactions[i]);
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(child: SpinLoader.loader(size: 30)),
            );
          }
        },
      );
    });
  }
}
