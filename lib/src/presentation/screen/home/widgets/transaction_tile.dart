import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import 'transaction_details_sheet.dart';
import '../../../../utils/helper/transaction_icon_helper.dart';
import '../../../../utils/constants/app_colors.dart';
import '../model/home_response_model.dart';
import '../../../../utils/helper/currency_formatter.dart';

class TransactionTile extends StatelessWidget {
  final RecentTransaction transaction;
  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) =>
                    TransactionDetailsSheet(transaction: transaction),
              );
            },
            leading: SvgPicture.asset(
              TransactionIconHelper.getIcon(transaction.type ?? ''),
              width: 44.w,
              height: 44.h,
            ),
            title: Text(
              transaction.type?.toReadableText() ?? '',
              style: TextStyle(
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                transaction.createdAt ?? '',
                style: TextStyle(
                  letterSpacing: 0,
                  color: AppColors.subText.withValues(alpha: 0.6),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  CurrencyFormatter.nairaText(transaction.finalAmount),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: AppColors.subText,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: transaction.status == 'Success'
                        ? AppColors.success.withAlpha(15)
                        : transaction.status == 'Pending'
                        ? AppColors.pending.withAlpha(15)
                        : AppColors.error.withAlpha(15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    transaction.status ?? '',
                    style: TextStyle(
                      letterSpacing: 0,
                      color: transaction.status == 'Success'
                          ? AppColors.success
                          : transaction.status == 'Pending'
                          ? AppColors.pending
                          : AppColors.error,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(color: AppColors.grey.withAlpha(50), height: 0.h),
      ],
    );
  }
}
