import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/currency_formatter.dart';
import '../../../../utils/constants/image_string.dart';

class WalletCard extends StatelessWidget {
  final String title;
  final double balance;
  final String label;
  final bool isBlue;

  const WalletCard({
    super.key,
    required this.title,
    required this.balance,
    required this.label,
    this.isBlue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.topRight,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            gradient: isBlue
                ? const LinearGradient(
                    colors: [Color(0xFF819CFF), Color(0xFF2452F9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFFF5F5F5),
                      Color.fromARGB(255, 243, 245, 255),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
            borderRadius: BorderRadius.circular(30.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: isBlue ? AppColors.white : AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    letterSpacing: 0,
                    color: isBlue ? AppColors.primary : AppColors.white,
                    fontSize: 11.sp,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      letterSpacing: 0,
                      color: isBlue ? AppColors.white : AppColors.textPrimary,
                      fontSize: 13.sp,
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        CurrencyFormatter.naira(balance),
                        style: TextStyle(
                          letterSpacing: 0,
                          color: isBlue
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      Text(
                        "walletExchange.currencySymbol".trns(),
                        style: TextStyle(
                          letterSpacing: 0,
                          color: isBlue
                              ? AppColors.white
                              : AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30.w)),
          child: Image.asset(isBlue ? AppImages.ellipsis : AppImages.ellipsis2),
        ),
      ],
    );
  }
}
