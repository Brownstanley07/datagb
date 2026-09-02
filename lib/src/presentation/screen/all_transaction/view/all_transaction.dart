import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../controller/all_transaction_controller.dart';
import '../widgets/dynamic_tabs.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/transaction_list.dart';
import '../widgets/transaction_list_shimmer.dart';

const Color _blue = Color(0xFF2452F9);

class AllTransaction extends GetView<AllTransactionController> {
  const AllTransaction({super.key, this.showBackArrow = true});
  final bool showBackArrow;

  AllTransactionController _resolveController() {
    if (Get.isRegistered<AllTransactionController>()) {
      return Get.find<AllTransactionController>();
    }

    return Get.put<AllTransactionController>(
      AllTransactionController(
        secureApiController: Get.find<SecureApiController>(),
      ),
      permanent: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Resolve before building DynamicTabs, TransactionList, or their Obx
    // descendants, all of which depend on the same controller registration.
    final transactionController = _resolveController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, titleColor, cardBg, borderColor, isDark),
              SizedBox(height: 22.h),
              const DynamicTabs(),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() {
                  if (transactionController.isFirstLoad.value) {
                    return const TransactionListShimmer();
                  }

                  return RefreshIndicator(
                    onRefresh: transactionController.refreshData,
                    backgroundColor: cardBg,
                    color: _blue,
                    child: const TransactionList(),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Header Bar with 'Filter' Text + Icon Trigger
  Widget _header(
    BuildContext context,
    Color titleColor,
    Color cardBg,
    Color borderColor,
    bool isDark,
  ) {
    return Row(
      children: [
        if (showBackArrow) ...[
          GestureDetector(
            onTap: Get.back,
            child: Container(
              height: 38.r,
              width: 38.r,
              decoration: BoxDecoration(
                color: cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 17.sp,
                color: titleColor,
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        Expanded(
          child: Text(
            'Transactions',
            style: TextStyle(
              color: titleColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const FilterBottomSheet(),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderColor),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.filter_list_rounded, color: titleColor, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
