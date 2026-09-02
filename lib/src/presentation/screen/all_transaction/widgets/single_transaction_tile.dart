import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import '../model/all_transaction_response_model.dart';
import 'all_transaction_details_sheet.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/transaction_icon_helper.dart';
import '../../../../utils/helper/currency_formatter.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  const TransactionTile(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final typeText = transaction.type?.toReadableText() ?? '';
    final displayType = typeText.toLowerCase() == 'interest'
        ? 'Earning'
        : typeText;

    final normalizedStatus = transaction.status?.toLowerCase() ?? '';
    final isSuccess =
        normalizedStatus == 'success' ||
        normalizedStatus == 'approved' ||
        normalizedStatus == 'completed';
    final isPending = normalizedStatus == 'pending';
    final statusColor = isSuccess
        ? AppColors.success
        : isPending
        ? AppColors.pending
        : AppColors.error;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) =>
                AllTransactionDetailsSheet(transaction: transaction),
          );
        },
        leading: SvgPicture.asset(
          TransactionIconHelper.getIcon(transaction.type ?? ''),
          width: 44.w,
          height: 44.h,
        ),
        title: Text(
          displayType,
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: titleColor,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Text(
            transaction.createdAt ?? '',
            style: TextStyle(
              letterSpacing: 0,
              color: subtitleColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        trailing: SizedBox(
          width: 112.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                CurrencyFormatter.nairaText(transaction.finalAmount),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  transaction.status ?? '',
                  style: TextStyle(
                    letterSpacing: 0,
                    color: statusColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
