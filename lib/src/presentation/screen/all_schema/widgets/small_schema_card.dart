import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../model/all_schema_response_model.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';

class SchemaSmallCard extends StatelessWidget {
  final Schema schema;
  final bool isSelected;
  final VoidCallback onTap;

  const SchemaSmallCard({
    super.key,
    required this.schema,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,

      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 161.w,
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 18.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.04)
                  : AppColors.grey.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 1.w,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(height: 8.h),
                Text(
                  schema.name ?? "",
                  style: TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),

                SizedBox(height: 12.h),

                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: schema.amountRange == 'fixed'
                            ? CurrencyFormatter.naira(schema.fixedAmount)
                            : CurrencyFormatter.nairaRange(
                                schema.minAmount,
                                schema.maxAmount,
                              ),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 18.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: "allSchema.schemaReviewDetails.invest".trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 10.sp,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textPrimary.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected && schema.badge != null)
          Positioned(
            top: 10.h,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                schema.badge.toString(),
                style: const TextStyle(
                  letterSpacing: 0,
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
