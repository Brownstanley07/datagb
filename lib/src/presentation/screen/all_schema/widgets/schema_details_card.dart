import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/all_schema_response_model.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class SchemaDetailCard extends StatelessWidget {
  final Schema schema;
  const SchemaDetailCard({super.key, required this.schema});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF819CFF), Color(0xFF2452F9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// PLAN NAME + DAILY PROFIT
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    schema.icon ?? "",
                    width: 16.w,
                    height: 16.h,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Shimmer.fromColors(
                        baseColor: AppColors.shimmerBase,
                        highlightColor: AppColors.shimmerHighlight,
                        child: Container(
                          width: 16.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: AppColors.shimmerBase,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    schema.name ?? "",
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 16.sp,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
              Text(
                " ${schema.returnInterest}",
                style: TextStyle(
                  letterSpacing: 0,
                  color: const Color(0xFFCEFF1F),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          /// INVEST AMOUNT
          Text(
            schema.amountRange == 'fixed'
                ? CurrencyFormatter.naira(schema.fixedAmount)
                : CurrencyFormatter.nairaRange(
                    schema.minAmount,
                    schema.maxAmount,
                  ),
            style: TextStyle(
              letterSpacing: 0,
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 30.h),

          /// FEATURES BOX
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16.w),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                _featureRow(
                  "allSchema.schemaDetailsPage.profitHoliday".trns(),
                  schema.holiday ?? "No",
                ),
                _featureRow(
                  "allSchema.schemaDetailsPage.returnOfInterest".trns(),
                  "${schema.returnInterest}",
                ),
                if (schema.isAutoRenewal == true)
                  _featureRow(
                    "allSchema.schemaDetailsPage.autoRenewalSource".trns(),
                    "${schema.autoRenewalSource}",
                  ),
                if (schema.returnInterestType != null)
                  _featureRow(
                    "allSchema.schemaDetailsPage.returnInterestType".trns(),
                    "${schema.returnInterestType}",
                  ),
                _featureRow(
                  "allSchema.schemaDetailsPage.returnOfPeriod".trns(),
                  "${schema.numberPeriod}",
                ),
                _featureRow(
                  "crowdSchema.crowdSchemaDetail.withdraw".trns(),
                  'crowdSchema.crowdSchemaDetail.anyTime'.trns(),
                ),
                _featureRow(
                  "allSchema.schemaDetailsPage.capitalBack".trns(),
                  schema.capitalBack == true
                      ? "allSchema.schemaReviewDetails.yes".trns()
                      : "allSchema.schemaDetailsPage.no".trns(),
                ),
                _featureRow(
                  "allSchema.schemaDetailsPage.autoRenew".trns(),
                  schema.isAutoRenewal == true
                      ? "allSchema.schemaDetailsPage.available".trns()
                      : "allSchema.schemaDetailsPage.notAvailable".trns(),
                ),
                _featureRow(
                  "allSchema.schemaDetailsPage.compoundingInterest".trns(),
                  schema.isCompounding == true
                      ? "allSchema.schemaDetailsPage.available".trns()
                      : "allSchema.schemaDetailsPage.notAvailable".trns(),
                ),
                _featureRow(
                  "allSchema.schemaDetailsPage.cancel".trns(),
                  schema.isCancel == true
                      ? "allSchema.schemaReviewDetails.yes".trns()
                      : "allSchema.schemaDetailsPage.no".trns(),
                ),
                if (schema.amountRange == 'fixed')
                  _featureRow(
                    "allSchema.schemaDetailsPage.totalInvestAmount".trns(),
                    schema.amountRange == 'fixed'
                        ? CurrencyFormatter.naira(schema.fixedAmount)
                        : CurrencyFormatter.nairaRange(
                            schema.minAmount,
                            schema.maxAmount,
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
                fontSize: 11.sp,
                color: AppColors.white,

                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.toReadableText(),
              textAlign: TextAlign.right,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 12.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
