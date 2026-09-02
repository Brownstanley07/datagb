import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../model/referral_success_response.dart';
import '../../../../utils/constants/app_colors.dart';

class ReferralTile extends StatelessWidget {
  final Tree node;
  final bool isExpanded;
  final VoidCallback? onTap;
  final double indent;

  const ReferralTile({
    super.key,
    required this.node,
    required this.isExpanded,
    required this.onTap,
    required this.indent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: indent),

            /// Arrow
            GestureDetector(
              onTap: onTap,
              child: (node.children?.isNotEmpty ?? false)
                  ? Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      size: 20.sp,
                      color: AppColors.grey,
                    )
                  : SizedBox(width: 22.w),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ListTile(
                contentPadding: .zero,
                leading: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                    imageUrl: node.avatar ?? '',
                    fit: BoxFit.cover,
                    width: 48.r,
                    height: 48.r,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: AppColors.shimmerBase,
                      highlightColor: AppColors.shimmerHighlight,
                      child: Container(
                        width: 48.r,
                        height: 48.r,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48.r,
                      height: 48.r,
                      color: AppColors.grey.withAlpha(30),
                      child: const Icon(Icons.person, color: AppColors.grey),
                    ),
                  ),
                ),
                title: Text(
                  node.name ?? "",
                  style: TextStyle(
                    letterSpacing: 0,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  node.isMe == true
                      ? 'You · Referral owner'
                      : 'Level ${node.depth ?? 1} referral',
                  style: _miniStyle(AppColors.grey),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),
        Divider(color: AppColors.grey.withAlpha(100)),
      ],
    );
  }

  TextStyle _miniStyle(Color? color) => TextStyle(
    letterSpacing: 0,
    fontSize: 12.sp,
    color: color ?? AppColors.grey,
  );
}
