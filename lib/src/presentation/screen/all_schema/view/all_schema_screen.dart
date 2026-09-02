import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../../app/routes/routes.dart';
import '../../../../utils/helper/currency_formatter.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../controller/all_schema_controller.dart';
import '../model/all_schema_response_model.dart';
import '../../deposit/model/deposit_method_response.dart';

const Color _blue = Color(0xFF2452F9);
const Color _lightBlueBg = Color(0xFFF0F9FF);
const Color _lightBlueCard = Color(0xFFE0F2FE);
const Color _lightBlueBorder = Color(0xFFBAE6FD);
const Color _ink = Color(0xFF0F172A);
const Color _muted = Color(0xFF475569);
const Color _line = Color(0xFFE2E8F0);

class AllSchemaScreen extends GetView<AllSchemaController> {
  const AllSchemaScreen({super.key, this.showBackArrow = true});
  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final fundingFlow = arguments is Map && arguments['fundingFlow'] == true;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 10.h),
              child: Row(
                children: [
                  if (showBackArrow) ...[
                    GestureDetector(
                      onTap: Get.back,
                      child: Container(
                        height: 38.r,
                        width: 38.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: _line),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF0F172A,
                              ).withValues(alpha: 0.04),
                              blurRadius: 8.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 17.sp,
                          color: _ink,
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
                          fundingFlow
                              ? 'Fund & Invest'
                              : 'Available Investments',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          fundingFlow
                              ? 'Review details & fund your preferred plan'
                              : 'Explore high-yielding plans tailored for you',
                          style: TextStyle(fontSize: 11.5.sp, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(BaseRoute.schemaHistory),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: _line),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: _blue,
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'History',
                            style: TextStyle(
                              color: _blue,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) return SpinLoader.loader();

                return RefreshIndicator(
                  color: _blue,
                  onRefresh: controller.refreshSchemas,
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(18.w, 8.h, 18.w, 30.h),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      // Balance & Instant Deposit Hero Card
                      _balanceDepositCard(),
                      SizedBox(height: 20.h),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Investment Plans',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Text(
                            '${controller.schemas.length} Available',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      if (controller.schemas.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(32.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: _line),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.trending_up_rounded,
                                size: 40.sp,
                                color: _muted.withValues(alpha: 0.5),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'No investment plans available yet',
                                style: TextStyle(
                                  color: _ink,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Please check back later or contact support.',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.schemas.length,
                          separatorBuilder: (_, __) => SizedBox(height: 14.h),
                          itemBuilder: (_, i) =>
                              _planCard(controller.schemas[i], i, fundingFlow),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Light Blue Balance & Direct Deposit Hero Banner
  Widget _balanceDepositCard() {
    final wallet =
        controller.homeController.wallets.value?.mainWallet ?? '0.00';
    final profit =
        controller.homeController.wallets.value?.profitWallet ?? '0.00';

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_lightBlueBg, _lightBlueCard],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: _lightBlueBorder),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Wallet',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: _muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    CurrencyFormatter.nairaText(wallet),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                ],
              ),
              Container(height: 32.h, width: 1, color: _lightBlueBorder),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Investment Earnings',
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: _muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    CurrencyFormatter.nairaText(profit),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 44.h,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(BaseRoute.deposit),
              icon: Icon(
                Icons.add_circle_outline_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
              label: Text(
                'Make Deposit',
                style: TextStyle(
                  fontSize: 13.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Modern Investment Plan Card
  Widget _planCard(Schema plan, int index, bool fundingFlow) {
    final minimum = plan.amountRange == 'fixed'
        ? plan.fixedAmount
        : plan.minAmount;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon, Name & ROI Badge
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: _blue.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  index.isEven
                      ? Icons.trending_up_rounded
                      : Icons.shield_rounded,
                  color: _blue,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name ?? 'Investment Plan',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      plan.numberPeriod ?? 'Flexible investment schedule',
                      style: TextStyle(fontSize: 11.5.sp, color: _muted),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: Text(
                  '${plan.returnInterest ?? plan.interest ?? 'ROI'} ROI',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Structured Metrics Grid
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: _line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _metricPill(
                    label: 'Minimum Deposit',
                    value: CurrencyFormatter.nairaText(minimum),
                    valueColor: _ink,
                  ),
                ),
                Container(width: 1, height: 32.h, color: _line),
                SizedBox(width: 10.w),
                Expanded(
                  child: _metricPill(
                    label: 'Est. Return',
                    value: plan.returnInterest ?? plan.interest ?? 'Flexible',
                    valueColor: const Color(0xFF10B981),
                  ),
                ),
                Container(width: 1, height: 32.h, color: _line),
                SizedBox(width: 10.w),
                Expanded(
                  child: _metricPill(
                    label: 'Capital Return',
                    value: plan.capitalBack == true ? 'Included' : 'No',
                    valueColor: _blue,
                  ),
                ),
              ],
            ),
          ),

          if (fundingFlow) ...[
            SizedBox(height: 14.h),
            _detailRow(
              'Investment Range',
              plan.amountRange == 'fixed'
                  ? CurrencyFormatter.nairaText(plan.fixedAmount)
                  : '${CurrencyFormatter.nairaText(plan.minAmount)} – ${CurrencyFormatter.nairaText(plan.maxAmount)}',
            ),
            _detailRow(
              'Return Schedule',
              plan.returnInterestType ?? 'Scheduled',
            ),
            _detailRow('Payout Frequency', plan.numberPeriod ?? 'Unlimited'),
            _detailRow(
              'Auto Renewal',
              plan.isAutoRenewal == true ? 'Yes' : 'No',
              isLast: true,
            ),
          ],

          SizedBox(height: 16.h),

          // Invest Action Button
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton(
              onPressed: fundingFlow
                  ? () => _showDepositSheet(plan)
                  : () => _chooseSource(plan),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Invest Now',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricPill({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: _muted),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.5.sp, color: _muted),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
        ],
      ),
    );
  }

  /// Funding Source Bottom Sheet
  Future<void> _showDepositSheet(Schema plan) async {
    await controller.loadDepositMethods();
    if (controller.depositMethods.isEmpty) {
      ToastService.showError('No bank payment account is available right now.');
      return;
    }

    final dark = Get.isDarkMode;
    final surface = dark ? const Color(0xFF111C2F) : Colors.white;
    final title = dark ? const Color(0xFFF8FAFC) : _ink;
    final muted = dark ? const Color(0xFF94A3B8) : _muted;
    final line = dark ? const Color(0xFF334155) : _line;
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * .82),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 12.w, 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Make Deposit',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w800,
                              color: title,
                            ),
                          ),
                          Text(
                            'Choose a verified payment account for ${plan.name ?? 'this investment'}.',
                            style: TextStyle(fontSize: 11.sp, color: muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: line),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(18.w),
                  itemCount: controller.depositMethods.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, index) =>
                      _paymentAccount(controller.depositMethods[index], plan),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _paymentAccount(DepositMethod method, Schema plan) {
    final dark = Theme.of(Get.context!).brightness == Brightness.dark;
    final card = dark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final title = dark ? const Color(0xFFF8FAFC) : _ink;
    final line = dark ? const Color(0xFF334155) : _line;
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFEFF6FF),
                child: Icon(Icons.account_balance_rounded, color: _blue),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  method.name ?? 'Bank Transfer',
                  style: TextStyle(fontWeight: FontWeight.w800, color: title),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Text(
                  'Manual',
                  style: TextStyle(color: Color(0xFFC2410C)),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _accountDetail('Bank Name', method.bankName),
          _accountDetail('Account Number', method.accountNumber),
          _accountDetail('Account Owner', method.accountName),
          if ((method.paymentDetails ?? '').trim().isNotEmpty) ...[
            SizedBox(height: 8.h),
            Divider(height: 1, color: line),
            SizedBox(height: 8.h),
          ],
          if ((method.paymentDetails ?? '').trim().isNotEmpty)
            HtmlWidget(method.paymentDetails!),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.back();
                Get.toNamed(
                  BaseRoute.deposit,
                  arguments: {
                    'gatewayCode': method.gatewayCode,
                    'schemaId': plan.id,
                  },
                );
              },
              icon: const Icon(Icons.upload_file_rounded, color: Colors.white),
              label: const Text(
                'Continue & Add Payment Proof',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: _blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountDetail(String label, String? value) {
    final dark = Theme.of(Get.context!).brightness == Brightness.dark;
    final title = dark ? const Color(0xFFF8FAFC) : _ink;
    final muted = dark ? const Color(0xFF94A3B8) : _muted;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 11.sp, color: muted),
            ),
          ),
          Flexible(
            child: Text(
              (value ?? '').trim().isEmpty ? 'Not configured' : value!.trim(),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: title,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _chooseSource(Schema plan) {
    final user = controller.homeController.user.value;
    if (user?.kyc == 0 || user?.kyc == 2 || user?.kyc == 3) {
      ToastService.showError('Complete your KYC before investing.');
      return;
    }

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: _line,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Select Funding Source',
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Choose where your investment capital should be deducted from.',
                style: TextStyle(fontSize: 12.sp, color: _muted),
              ),
              SizedBox(height: 20.h),
              _sourceTile(
                plan: plan,
                key: 'main',
                title: 'Available Wallet',
                balance:
                    controller.homeController.wallets.value?.mainWallet ??
                    '0.00',
                icon: Icons.account_balance_wallet_rounded,
                iconColor: _blue,
                bgColor: const Color(0xFFEFF6FF),
              ),
              SizedBox(height: 12.h),
              _sourceTile(
                plan: plan,
                key: 'profit',
                title: 'Investment Earnings',
                balance:
                    controller.homeController.wallets.value?.profitWallet ??
                    '0.00',
                icon: Icons.auto_graph_rounded,
                iconColor: const Color(0xFF10B981),
                bgColor: const Color(0xFFECFDF5),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _sourceTile({
    required Schema plan,
    required String key,
    required String title,
    required String balance,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return GestureDetector(
      onTap: () {
        Get.back();
        Get.toNamed(
          BaseRoute.payNow,
          arguments: {'schema': plan, 'wallet': key},
        );
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: _line),
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: _ink,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Balance: ${CurrencyFormatter.nairaText(balance)}',
                    style: TextStyle(fontSize: 11.5.sp, color: _muted),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: _ink, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
