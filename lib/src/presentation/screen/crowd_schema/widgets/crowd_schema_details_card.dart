import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/all_crowd_schema_model.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class CrowdSchemaDetailCard extends StatelessWidget {
  final CrowdSchema schema;
  const CrowdSchemaDetailCard({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.w),
        border: Border.all(color: AppColors.primary.withAlpha(100), width: 2.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.darkPrimary.withAlpha(50),
            ),
            child: Column(
              children: [
                Text(
                  schema.amountRange == 'fixed'
                      ? CurrencyFormatter.naira(schema.fixedAmount)
                      : CurrencyFormatter.nairaRange(
                          schema.minAmount,
                          schema.maxAmount,
                        ),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "crowdSchema.crowdSchemaDetail.totalAmount".trns(),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 30.h),

          _featureRow(
            "crowdSchema.crowdSchemaDetail.investTill".trns(),
            schema.endDate != null
                ? schema.endDateFormat.toString()
                : schema.returnDateFormat.toString(),
          ),

          _featureRow(
            "crowdSchema.crowdSchemaDetail.returnDate".trns(),
            schema.returnDateFormat.toString(),
          ),

          _featureRow(
            "crowdSchema.crowdSchemaDetail.interest".trns(),
            schema.returnInterest.toString(),
          ),
          _featureRow(
            "crowdSchema.crowdSchemaDetail.investor".trns(),
            schema.totalInvestors.toString(),
          ),
          if (schema.endDate != null)
            _featureRow(
              "crowdSchema.crowdSchemaDetail.daysLeft".trns(),
              schema.daysLeft.toString(),
            ),
          _featureRow(
            "crowdSchema.crowdSchemaDetail.withdraw".trns(),
            'crowdSchema.crowdSchemaDetail.anyTime'.trns(),
          ),
          SizedBox(height: 30.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.w),
              color: AppColors.primary.withAlpha(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "crowdSchema.crowdSchemaDetail.investAmount".trns(),
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${schema.totalCollected ?? 0}",
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "${schema.maxCollection ?? 0}",
                      style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                LinearProgressIndicator(
                  minHeight: 10.h,
                  value: (schema.progressPercentage ?? 0) / 100,
                  backgroundColor: AppColors.primary.withAlpha(30),
                  color: AppColors.primary.withAlpha(200),
                  borderRadius: BorderRadius.circular(10.w),
                ),
                SizedBox(height: 15.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${schema.progressPercentage ?? 0}% ${'crowdSchema.crowdSchemaDetail.outOf'.trns()}",
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              label,
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.subText.withValues(alpha: 0.8),
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.visible,

              style: TextStyle(
                letterSpacing: 0,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,

                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
