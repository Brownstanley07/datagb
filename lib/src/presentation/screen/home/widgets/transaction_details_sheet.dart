import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/home_response_model.dart';

import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final RecentTransaction transaction;
  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Drag handle
          Center(
            child: Container(
              width: 30.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 39.h),
              decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(130),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),

          Text(
            "home.recentTransactions.transactionDetails".trns(),
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          Divider(height: 0.h, color: AppColors.grey.withAlpha(80)),
          SizedBox(height: 16.h),

          /// Title + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.type?.toReadableText() ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                CurrencyFormatter.nairaText(transaction.amount),
                style: TextStyle(
                  letterSpacing: 0,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.date ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.subText.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                transaction.time ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.subText.withValues(alpha: 0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          Text(
            "home.recentTransactions.description".trns(),
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),

          Text(
            transaction.description ?? '',
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 14.sp,
              color: AppColors.subText.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 30.h),

          // _row("Account", transaction.id.toString()),
          _row(
            "home.recentTransactions.charge".trns(),
            CurrencyFormatter.nairaText(transaction.charge),
            valueColor: Colors.red,
            isBold: true,
          ),

          _row(
            "home.recentTransactions.transactionId".trns(),
            transaction.tnx.toString(),
          ),
          _row(
            "home.recentTransactions.status".trns(),

            transaction.status ?? "home.recentTransactions.success".trns(),
            valueColor: transaction.status == "Success"
                ? AppColors.success
                : transaction.status == "Pending"
                ? AppColors.warning
                : AppColors.error,
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    Color valueColor = AppColors.textPrimary,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.subText.withValues(alpha: 0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
