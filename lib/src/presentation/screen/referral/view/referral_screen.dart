import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../controller/referral_controller.dart';
import '../model/referral_success_response.dart';
import '../widgets/referral_tree_screen.dart';

const Color _blue = Color(0xFF2452F9);

class ReferralScreen extends GetView<ReferralController> {
  const ReferralScreen({super.key, this.showBackArrow = true});
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final card = isDark ? const Color(0xFF1E293B) : Colors.white;
    final line = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final title = isDark ? Colors.white : const Color(0xFF0F172A);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return SpinLoader.loader();

          return RefreshIndicator(
            color: _blue,
            backgroundColor: card,
            onRefresh: controller.refreshReferral,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 32.h),
              children: [
                _header(title, muted, line, isDark),
                SizedBox(height: 18.h),
                _sharePanel(title, muted),
                SizedBox(height: 14.h),
                _summary(card, line, title, muted),
                SizedBox(height: 14.h),
                _rules(card, line, title, muted),
                SizedBox(height: 22.h),
                _activity(card, line, title, muted, isDark),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _header(Color title, Color muted, Color line, bool isDark) {
    return Row(
      children: [
        if (showBackArrow) ...[
          InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(19.r),
            child: Container(
              height: 38.r,
              width: 38.r,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: line),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 17.sp,
                color: title,
              ),
            ),
          ),
          SizedBox(width: 12.w),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Referrals',
                style: TextStyle(
                  color: title,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Invite friends and earn 5% when they deposit.',
                style: TextStyle(color: muted, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sharePanel(Color title, Color muted) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: _blue,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '5% referral reward',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'Invite friends. Earn rewards.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Earn 5% when a referred person makes a deposit.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12.sp,
              height: 1.45,
            ),
          ),
          SizedBox(height: 18.h),
          SizedBox(
            height: 46.h,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: controller.shareReferralLink,
              icon: Icon(Icons.ios_share_rounded, color: _blue, size: 18.sp),
              label: Text(
                'Share Invite',
                style: TextStyle(
                  color: _blue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(Color card, Color line, Color title, Color muted) {
    return Row(
      children: [
        _metric(
          card,
          line,
          title,
          muted,
          '${controller.referral.value?.joinedText ?? 0}',
          'Joined',
        ),
        SizedBox(width: 10.w),
        _metric(
          card,
          line,
          title,
          muted,
          controller.totalReferralPoint.value.isEmpty
              ? '0'
              : controller.totalReferralPoint.value,
          'Reward earned',
        ),
      ],
    );
  }

  Widget _metric(
    Color card,
    Color line,
    Color title,
    Color muted,
    String value,
    String label,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: title,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(color: muted, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rules(Color card, Color line, Color title, Color muted) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: line),
      ),
      child: Column(
        children: [
          _rule(
            Icons.link_rounded,
            'Share',
            'Invite through the app share menu.',
            title,
            muted,
          ),
          Divider(height: 22.h, color: line),
          _rule(
            Icons.person_add_alt_1_rounded,
            'Signup',
            'They join using your invite.',
            title,
            muted,
          ),
          Divider(height: 22.h, color: line),
          _rule(
            Icons.check_circle_rounded,
            'Qualify',
            'You earn 5% when they make a deposit.',
            title,
            muted,
          ),
        ],
      ),
    );
  }

  Widget _rule(
    IconData icon,
    String label,
    String text,
    Color title,
    Color muted,
  ) {
    return Row(
      children: [
        Container(
          height: 38.r,
          width: 38.r,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: _blue, size: 19.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: title,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                text,
                style: TextStyle(color: muted, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activity(
    Color card,
    Color line,
    Color title,
    Color muted,
    bool isDark,
  ) {
    final logs = [
      ...controller.general,
      ...controller.targeted.expand((x) => x.transactions ?? <General>[]),
    ].take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Referral Activity',
                style: TextStyle(
                  color: title,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  Get.to(() => ReferralTreeScreen(controller: controller)),
              child: const Text('Network'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: line),
          ),
          child: logs.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(22.w),
                  child: Text(
                    'No referral activity yet. Share your invite to get started.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 12.sp),
                  ),
                )
              : Column(
                  children: List.generate(logs.length, (index) {
                    final log = logs[index];
                    return Column(
                      children: [
                        _activityRow(log, title, muted),
                        if (index != logs.length - 1)
                          Divider(height: 1, color: line),
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }

  Widget _activityRow(General log, Color title, Color muted) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            height: 36.r,
            width: 36.r,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.card_giftcard_rounded, color: _blue, size: 18.sp),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.description ?? 'Referral reward',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: title,
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  log.createdAt ?? 'Recent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted, fontSize: 10.5.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            log.amount ?? '+5%',
            style: TextStyle(
              color: const Color(0xFF10B981),
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
