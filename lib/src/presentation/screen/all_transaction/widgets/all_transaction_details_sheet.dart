import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import '../model/all_transaction_response_model.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class AllTransactionDetailsSheet extends StatelessWidget {
  final Transaction transaction;
  const AllTransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color subtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    final typeText = transaction.type?.toReadableText() ?? '';
    final displayType = typeText.toLowerCase() == 'interest' ? 'Earning' : typeText;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 20.r,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Drag handle
            Center(
              child: Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: subtitleColor.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            Text(
              "Transaction Details",
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            SizedBox(height: 14.h),
            Divider(height: 1, color: borderColor),
            SizedBox(height: 16.h),

            /// Title + Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayType,
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
                Text(
                  CurrencyFormatter.nairaText(transaction.amount ?? transaction.finalAmount),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.date ?? '',
                  style: TextStyle(
                    letterSpacing: 0,
                    color: subtitleColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  transaction.time ?? '',
                  style: TextStyle(
                    letterSpacing: 0,
                    color: subtitleColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Text(
              "Description",
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            SizedBox(height: 6.h),

            Text(
              transaction.description?.isNotEmpty == true
                  ? transaction.description!
                  : 'No description provided.',
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 13.sp,
                color: subtitleColor,
                fontWeight: FontWeight.w400,
              ),
            ),

            SizedBox(height: 20.h),

            // Charge row removed as requested

            _row(
              "Transaction ID",
              transaction.tnx.toString(),
              titleColor: titleColor,
              subtitleColor: subtitleColor,
            ),
            _row(
              "Status",
              transaction.status ?? "Success",
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              valueColor: transaction.status?.toLowerCase() == "success" || transaction.status?.toLowerCase() == "completed"
                  ? AppColors.success
                  : transaction.status?.toLowerCase() == "pending"
                  ? AppColors.warning
                  : AppColors.error,
            ),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    required Color titleColor,
    required Color subtitleColor,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: subtitleColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: valueColor ?? titleColor,
            ),
          ),
        ],
      ),
    );
  }
}
