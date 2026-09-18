import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../withdraw/widgets/bank_account_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/exit_dialog/exit_dialog.dart';
import '../../../../common/widgets/whatsapp_support/whatsapp_support_button.dart';
import '../../../../common/widgets/community_links_card.dart';
import '../../../../utils/helper/currency_formatter.dart';
import '../../../../utils/helper/currency_amount_formatter.dart';
import '../../../../utils/helper/transaction_icon_helper.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../controller/home_controller.dart';
import '../model/home_response_model.dart';
import '../../schema_history/model/schema_history_response_model.dart'
    as history_model;
import '../../all_schema/model/all_schema_response_model.dart' as schema_model;
import '../../withdraw/model/withdraw_account_response_model.dart';
import '../widgets/home_shimmer.dart';

const Color _blue = Color(0xFF2452F9);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find();
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgColor,
      body: Obx(() {
        if (controller.isLoading.value) return const HomeShimmer();
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (p, _) {
            if (!p) Get.dialog(const ExitDialog(logOut: true));
          },
          child: Column(
            children: [
              _header(context),
              Expanded(
                child: RefreshIndicator(
                  color: _blue,
                  backgroundColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  onRefresh: controller.refreshData,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _balanceCard(context),
                          SizedBox(height: 10.h),
                          _pendingTransactionsCard(context),
                          SizedBox(height: 10.h),
                          _freeDataCard(context),
                          SizedBox(height: 12.h),
                          const CommunityLinksCard(),
                          SizedBox(height: 12.h),
                          _quickActionsGrid(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  List<RecentTransaction> get _pendingTransactions =>
      controller.transactions.where((item) {
        if ((item.status ?? '').toLowerCase() != 'pending') return false;
        final searchable = '${item.type} ${item.description}'.toLowerCase();
        return searchable.contains('deposit') ||
            searchable.contains('redeem') ||
            searchable.contains('redemption') ||
            searchable.contains('capital');
      }).toList();

  bool _isPendingRedemption(RecentTransaction item) {
    final searchable = '${item.type} ${item.description}'.toLowerCase();
    return searchable.contains('redeem') ||
        searchable.contains('redemption') ||
        searchable.contains('capital');
  }

  Widget _pendingTransactionsCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final items = _pendingTransactions.take(2).toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending Transactions',
            style: TextStyle(
              color: titleColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 7.h),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Row(
                children: [
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF273449)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(11.r),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: subtitleColor,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'No pending transactions',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...List.generate(items.length, (index) {
              final item = items[index];
              final redemption = _isPendingRedemption(item);
              return Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36.r,
                        height: 36.r,
                        decoration: BoxDecoration(
                          color: redemption
                              ? const Color(0xFFFFF7ED)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                        child: Icon(
                          redemption
                              ? Icons.savings_outlined
                              : Icons.account_balance_rounded,
                          color: redemption ? const Color(0xFFEA580C) : _blue,
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              redemption
                                  ? 'Capital Redemption'
                                  : 'Bank Deposit',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              redemption
                                  ? 'Your redemption is being processed'
                                  : 'Awaiting review',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 10.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        item.amount ?? item.finalAmount ?? '',
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  if (index != items.length - 1)
                    Divider(height: 12.h, color: borderColor),
                ],
              );
            }),
          Divider(height: 12.h, color: borderColor),
          InkWell(
            onTap: () => Get.toNamed(BaseRoute.allTransaction),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all transactions',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 7.w),
                  Icon(Icons.chevron_right_rounded, color: _blue, size: 17.sp),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /* Previous standalone recent-transactions preview.
  Widget _recentTransactionsPreview(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final items = controller.transactions.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent Transactions',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Get.toNamed(BaseRoute.allTransaction),
              child: const Text('View all transactions'),
            ),
          ],
        ),
        if (items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: titleColor),
              ),
            ),
          )
        else
          ...items.map((item) => _compactTransactionRow(context, item)),
      ],
    );
  }

  Widget _compactTransactionRow(
    BuildContext context,
    RecentTransaction transaction,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final muted = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 38.r,
            height: 38.r,
            padding: EdgeInsets.all(9.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset(
              TransactionIconHelper.getIcon(transaction.type ?? ''),
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description ?? transaction.type ?? 'Transaction',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  transaction.createdAt ?? '',
                  style: TextStyle(color: muted, fontSize: 9.5.sp),
                ),
              ],
            ),
          ),
          Text(
            transaction.finalAmount ?? transaction.amount ?? '',
            style: TextStyle(
              color: titleColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
  */

  /* Legacy expanded pending-deposit card retained for reference.
  Widget _pendingDepositCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deposits = _pendingDeposits;
    final visibleDeposits = _showAllPendingDeposits
        ? deposits
        : deposits.take(3).toList();
    final hasMore = deposits.length > 3;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 34.r,
                width: 34.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF451A03)
                      : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.pending_actions_rounded,
                  color: const Color(0xFFD97706),
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending Transactions',
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${deposits.length} bank transfer${deposits.length == 1 ? '' : 's'} awaiting approval',
                      style: TextStyle(color: subtitleColor, fontSize: 10.5.sp),
                    ),
                  ],
                ),
              ),
              if (hasMore)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showAllPendingDeposits = !_showAllPendingDeposits;
                    });
                  },
                  child: Text(
                    _showAllPendingDeposits ? 'Show less' : 'See more',
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          ...List.generate(visibleDeposits.length, (index) {
            final deposit = visibleDeposits[index];
            final isLast = index == visibleDeposits.length - 1;
            return Column(
              children: [
                _pendingDepositRow(deposit, titleColor, subtitleColor, isDark),
                if (!isLast) Divider(height: 16.h, color: borderColor),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _pendingDepositRow(
    RecentTransaction deposit,
    Color titleColor,
    Color subtitleColor,
    bool isDark,
  ) {
    return Row(
      children: [
        Container(
          height: 8.r,
          width: 8.r,
          decoration: const BoxDecoration(
            color: Color(0xFFD97706),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deposit.description ?? 'Deposit with bank transfer',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                '${deposit.tnx ?? '-'} · ${deposit.createdAt ?? deposit.date ?? 'Recent'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: subtitleColor, fontSize: 10.sp),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              deposit.amount ?? deposit.finalAmount ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: titleColor,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF451A03)
                    : const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Pending',
                style: TextStyle(
                  color: const Color(0xFFD97706),
                  fontSize: 9.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
  */

  Widget _freeDataCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final balance = controller.dataBalanceMb.value;
    final threshold = controller.dataClaimThresholdMb.value;
    final pending = controller.pendingDataClaim.value;
    final eligible = balance >= threshold && pending == null;
    final hasData = balance > 0;

    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFBBF7D0);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFE2FFF7), Color(0xFFF0F2FF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isDark ? cardBg : null,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF0F172A,
            ).withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Free data',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  _formatData(balance),
                  style: TextStyle(
                    color: _blue,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 36.h,
                  child: FilledButton(
                    onPressed: !hasData
                        ? controller.onDeposit
                        : eligible
                        ? () => _scrollToQuickActionNotice()
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: _blue,
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                    ),
                    child: Text(
                      !hasData
                          ? 'Fund Account'
                          : pending != null
                          ? 'Pending'
                          : 'Use Data below',
                      style: TextStyle(fontSize: 10.5.sp),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  !hasData
                      ? 'Fund your account and receive free internet data.'
                      : pending != null
                      ? 'Your ${_formatData(pending.megabytes ?? 0)} request is being processed.'
                      : eligible
                      ? 'Free data is ready. Tap Redeem Data under Quick Actions to claim it.'
                      : '${threshold - balance} MB more needed to claim.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 10.5.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Image.asset(
            'assets/images/home/datago-gift-box.png',
            width: 116.w,
            height: 116.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  void _scrollToQuickActionNotice() {
    ToastService.showInfo(
      'Tap Redeem Data under Quick Actions to claim your free data.',
    );
  }

  void _openDataAction() {
    final balance = controller.dataBalanceMb.value;
    final threshold = controller.dataClaimThresholdMb.value;
    final pending = controller.pendingDataClaim.value;

    if (pending != null) {
      ToastService.showInfo(
        'Your ${_formatData(pending.megabytes ?? 0)} data request is pending.',
      );
      return;
    }
    if (balance < threshold) {
      ToastService.showInfo(
        'You need ${threshold - balance} MB more before you can claim data.',
      );
      return;
    }
    _showDataClaimSheet();
  }

  Future<void> _showDataClaimSheet() async {
    final available = controller.dataBalanceMb.value;
    final minimum = controller.dataClaimThresholdMb.value;
    final phone = TextEditingController();
    final amount = TextEditingController();
    String? network;
    String unit = available >= 1024 ? 'GB' : 'MB';

    int selectedMegabytes() {
      final value = double.tryParse(amount.text.trim()) ?? 0;
      return (value * (unit == 'GB' ? 1024 : 1)).round();
    }

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          final dark = Theme.of(context).brightness == Brightness.dark;
          final title = dark ? Colors.white : const Color(0xFF172033);
          final muted = dark
              ? const Color(0xFF94A3B8)
              : const Color(0xFF64748B);
          final surface = dark ? const Color(0xFF111827) : Colors.white;
          final field = dark
              ? const Color(0xFF1E293B)
              : const Color(0xFFF8FAFC);
          final claimMb = selectedMegabytes();
          final validAmount = claimMb >= minimum && claimMb <= available;
          final remaining = (available - claimMb).clamp(0, available);

          InputDecoration inputDecoration(String label, {String? hint}) =>
              InputDecoration(
                labelText: label,
                hintText: hint,
                filled: true,
                fillColor: field,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide(
                    color: dark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
              );

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .92,
            ),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(26.r)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                20.w,
                12.h,
                20.w,
                MediaQuery.viewInsetsOf(context).bottom + 24.h,
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: muted.withValues(alpha: .35),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        Container(
                          width: 44.r,
                          height: 44.r,
                          decoration: BoxDecoration(
                            color: _blue.withValues(alpha: .10),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: const Icon(Icons.wifi_rounded, color: _blue),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Withdraw free data',
                                style: TextStyle(
                                  color: title,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Choose any amount from your data balance.',
                                style: TextStyle(color: muted, fontSize: 11.sp),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2452F9), Color(0xFF173DBB)],
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AVAILABLE DATA',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .72),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .7,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            _formatData(available),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Amount to withdraw',
                      style: TextStyle(
                        color: title,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amount,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,3}'),
                              ),
                            ],
                            decoration: inputDecoration(
                              'Amount',
                              hint: unit == 'GB' ? 'e.g. 1.5' : 'e.g. 500',
                            ),
                            onChanged: (_) => setSheetState(() {}),
                          ),
                        ),
                        SizedBox(width: 9.w),
                        SizedBox(
                          width: 92.w,
                          child: DropdownButtonFormField<String>(
                            initialValue: unit,
                            decoration: inputDecoration('Unit'),
                            items: [
                              const DropdownMenuItem(
                                value: 'MB',
                                child: Text('MB'),
                              ),
                              DropdownMenuItem(
                                value: 'GB',
                                enabled: available >= 1024,
                                child: const Text('GB'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              final mb = selectedMegabytes();
                              setSheetState(() {
                                unit = value;
                                if (mb > 0) {
                                  amount.text = value == 'GB'
                                      ? (mb / 1024)
                                            .toStringAsFixed(2)
                                            .replaceFirst(RegExp(r'\.?0+$'), '')
                                      : '$mb';
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Minimum ${_formatData(minimum)}',
                          style: TextStyle(
                            color: validAmount || amount.text.isEmpty
                                ? muted
                                : Colors.red,
                            fontSize: 10.5.sp,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setSheetState(() {
                            amount.text = unit == 'GB'
                                ? (available / 1024)
                                      .toStringAsFixed(2)
                                      .replaceFirst(RegExp(r'\.?0+$'), '')
                                : '$available';
                          }),
                          child: const Text('Use maximum'),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: field,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _dataPreview(
                              'You will receive',
                              claimMb > 0 ? _formatData(claimMb) : '—',
                              title,
                              muted,
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 35.h,
                            color: muted.withValues(alpha: .2),
                          ),
                          Expanded(
                            child: _dataPreview(
                              'Balance after',
                              _formatData(remaining),
                              title,
                              muted,
                              alignEnd: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    DropdownButtonFormField<String>(
                      initialValue: network,
                      decoration: inputDecoration('Internet provider'),
                      items: const [
                        DropdownMenuItem(
                          value: 'mtn',
                          child: Text('MTN Nigeria'),
                        ),
                        DropdownMenuItem(
                          value: 'airtel',
                          child: Text('Airtel Nigeria'),
                        ),
                        DropdownMenuItem(
                          value: 'glo',
                          child: Text('Globacom (Glo)'),
                        ),
                        DropdownMenuItem(
                          value: 't2',
                          child: Text('T2 Mobile (formerly 9mobile)'),
                        ),
                      ],
                      onChanged: (v) => setSheetState(() => network = v),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: inputDecoration(
                        'Phone number',
                        hint: '08012345678',
                      ),
                    ),
                    SizedBox(height: 18.h),
                    SizedBox(
                      width: double.infinity,
                      height: 52.h,
                      child: FilledButton(
                        onPressed: !validAmount || network == null
                            ? null
                            : () async {
                                if (!RegExp(
                                  r'^0[789][01][0-9]{8}$',
                                ).hasMatch(phone.text.trim())) {
                                  ToastService.showError(
                                    'Enter a valid Nigerian phone number.',
                                  );
                                  return;
                                }
                                Get.back();
                                await controller.claimFreeData(
                                  network!,
                                  phone.text.trim(),
                                  claimMb,
                                );
                              },
                        style: FilledButton.styleFrom(
                          backgroundColor: _blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          'Withdraw ${claimMb > 0 ? _formatData(claimMb) : 'data'}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
    // GetX completes the bottom-sheet future when dismissal starts, while the
    // TextFields remain mounted for the reverse transition. Do not dispose
    // their controllers until that route has fully left the widget tree.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    amount.dispose();
    phone.dispose();
  }

  Widget _dataPreview(
    String label,
    String value,
    Color title,
    Color muted, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: muted, fontSize: 9.5.sp),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: TextStyle(
            color: title,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _formatData(int mb) {
    if (mb >= 1024) {
      final gb = mb / 1024;
      return '${gb.toStringAsFixed(gb % 1 == 0 ? 0 : 1)} GB';
    }
    return '$mb MB';
  }

  /// Minimal home header inspired by the supplied reference.
  Widget _header(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final name = (controller.userInfo.value?.name ?? '').trim();
    final firstName = name.isEmpty ? 'Investor' : name.split(' ').first;
    final image = controller.userInfo.value?.image ?? '';
    final greeting = GetDayTimeNow.getTimeNow(controller.welcomeText.value);
    final foreground = isDark ? Colors.white : const Color(0xFF171A21);
    final buttonBackground = isDark
        ? const Color(0xFF1E293B)
        : Colors.white.withValues(alpha: 0.72);
    final buttonBorder = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);

    return Container(
      width: double.infinity,
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      padding: EdgeInsets.fromLTRB(20.w, 42.h, 20.w, 14.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(BaseRoute.profileSettings),
            child: CircleAvatar(
              radius: 25.r,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFD4EFE3),
              backgroundImage: image.isEmpty ? null : NetworkImage(image),
              child: image.isEmpty
                  ? Icon(
                      Icons.person_outline_rounded,
                      color: foreground,
                      size: 25.sp,
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $firstName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 19.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.45,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  greeting,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF16A36A),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          const WhatsAppSupportButton(),
          GestureDetector(
            onTap: () => Get.toNamed(BaseRoute.allNotification),
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: buttonBackground,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: buttonBorder),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: foreground,
                    size: 23.sp,
                  ),
                  if (controller.totalNotifications.value > 0)
                    Positioned(
                      top: 9.r,
                      right: 9.r,
                      child: Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: buttonBackground,
                            width: 1.5.w,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget legacyHeader(BuildContext context) {
    final image = controller.userInfo.value?.image ?? '';
    final level = controller.ranking.value?.level;
    final levelName = controller.ranking.value?.name;
    final today = MaterialLocalizations.of(
      context,
    ).formatMediumDate(DateTime.now());

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 46.h, 20.w, 20.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1739), Color(0xFF132B5E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF315A9F).withValues(alpha: 0.45),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1739).withValues(alpha: 0.16),
            blurRadius: 18.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar with Ring
              GestureDetector(
                onTap: () => Get.toNamed(BaseRoute.profileSettings),
                child: Container(
                  width: 46.r,
                  height: 46.r,
                  padding: EdgeInsets.all(2.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF203B70),
                    backgroundImage: image.isEmpty ? null : NetworkImage(image),
                    child: image.isEmpty
                        ? Icon(
                            Icons.person_outline_rounded,
                            color: Colors.white,
                            size: 22.sp,
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // User Greeting Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.25,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      today,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.58),
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification Action
              GestureDetector(
                onTap: () => Get.toNamed(BaseRoute.allNotification),
                child: Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(13.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.notifications_none_rounded,
                        size: 21.sp,
                        color: Colors.white,
                      ),
                      if (controller.totalNotifications.value > 0)
                        Positioned(
                          top: 10.r,
                          right: 11.r,
                          child: Container(
                            width: 8.r,
                            height: 8.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5.w,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (level != null) ...[
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_outlined,
                    color: const Color(0xFF93C5FD),
                    size: 14.sp,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '$level • ${levelName ?? ''}',
                    style: TextStyle(
                      color: const Color(0xFFD8E6FA),
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Theme-Adaptive Portfolio Balance Card
  Widget _balanceCard(BuildContext context) {
    final liquidAmount = _number(controller.mainWallet.value);
    final activeInvestment =
        controller.dataCount['active_investment_balance'] ?? 0;
    final amount = liquidAmount + activeInvestment;
    final profit = _number(controller.profitWallet.value);
    const titleColor = Colors.white;
    const subtitleColor = Color(0xFFC7D7FF);
    const borderColor = Color(0xFF6689F7);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2452F9), Color(0xFF173DBB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderColor.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF173DBB).withValues(alpha: 0.28),
            blurRadius: 20.r,
            spreadRadius: 0,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with 'Portfolio Balance' and Single Visibility Eye Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Portfolio Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => visible = !visible),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        visible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 15.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        visible ? 'Hide' : 'Show',
                        style: TextStyle(
                          color: Colors.white,
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
          SizedBox(height: 5.h),

          // Available Balance Block
          Text(
            'Available Balance',
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            visible
                ? CurrencyFormatter.naira(amount.toStringAsFixed(2))
                : '₦••••••••',
            style: TextStyle(
              color: titleColor,
              fontSize: 21.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          Obx(() {
            final claim = controller.pendingCapitalClaim.value;
            if (claim == null) return const SizedBox.shrink();
            final left = controller.capitalClaimRemaining.value;
            final text = left == Duration.zero
                ? 'Capital is ready for your Earning Balance'
                : 'Capital redemption: ${left.inHours}h ${(left.inMinutes % 60).toString().padLeft(2, '0')}m remaining';
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .85),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),

          SizedBox(height: 5.h),
          Container(height: 1.h, color: borderColor.withValues(alpha: 0.6)),
          SizedBox(height: 5.h),

          // Earning Balance Block (Below Available Balance)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Earning Balance',
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    visible
                        ? CurrencyFormatter.naira(profit.toStringAsFixed(2))
                        : '₦••••••••',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showReinvestAmountDialog(context),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.autorenew_rounded,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Reinvest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 7.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 34.h,
                  child: ElevatedButton.icon(
                    onPressed: () => _showFundAccountSheet(context),
                    icon: Icon(
                      Icons.add_circle_outline_rounded,
                      size: 16.sp,
                      color: _blue,
                    ),
                    label: Text(
                      'Fund',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: _blue,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: SizedBox(
                  height: 34.h,
                  child: OutlinedButton.icon(
                    onPressed: () => _showWithdrawFundsSheet(context),
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Withdraw',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.10),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.45),
                        width: 1.w,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showReinvestAmountDialog(BuildContext context) async {
    if (!controller.canReinvest()) return;
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final balance = controller.earningBalanceAmount;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.autorenew_rounded,
              size: 30.sp,
              color: const Color(0xFF2457F5),
            ),
            SizedBox(width: 10.w),
            Text(
              'Reinvest Earnings',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        content: SizedBox(
          width: 360.w,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add earnings directly to your current running investment.',
                  style: TextStyle(
                    fontSize: 15.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F6FF),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    'Available: ${CurrencyFormatter.naira(balance.toStringAsFixed(2))}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF2457F5),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: amountController,
                  autofocus: true,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: const [CurrencyAmountFormatter()],
                  decoration: InputDecoration(
                    labelText: 'Amount to reinvest',
                    prefixText: '₦ ',
                    hintText: '0.00',
                    labelStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 18.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  validator: (value) {
                    final amount = CurrencyAmountFormatter.parse(value ?? '');
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount.';
                    }
                    if (amount > balance) {
                      return 'Amount exceeds your Earning Balance.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          Obx(
            () => SizedBox(
              height: 52.h,
              child: TextButton(
                onPressed: controller.isReinvesting.value
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => SizedBox(
              height: 52.h,
              child: FilledButton.icon(
                onPressed: controller.isReinvesting.value
                    ? null
                    : () async {
                        if (formKey.currentState?.validate() != true) return;
                        final amount = CurrencyAmountFormatter.parse(
                          amountController.text,
                        )!;
                        FocusManager.instance.primaryFocus?.unfocus();
                        final success = await controller.reinvestEarnings(
                          amount,
                        );
                        if (success && dialogContext.mounted) {
                          Navigator.of(dialogContext).pop();
                        }
                      },
                icon: controller.isReinvesting.value
                    ? SizedBox(
                        width: 20.sp,
                        height: 20.sp,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.autorenew_rounded, size: 22.sp),
                label: Text(
                  controller.isReinvesting.value
                      ? 'Reinvesting...'
                      : 'Reinvest',
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    await WidgetsBinding.instance.endOfFrame;
    amountController.dispose();
  }

  Future<void> _showFundAccountSheet(BuildContext context) async {
    final plan = await controller.getFundingPlan();
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _fundAccountSheet(sheetContext, plan),
    );
  }

  Widget _fundAccountSheet(BuildContext context, schema_model.Schema? plan) {
    final minimum = plan?.amountRange == 'fixed'
        ? plan?.fixedAmount
        : plan?.minAmount;
    return _actionSheetShell(
      context: context,
      icon: Icons.add_card_rounded,
      title: plan == null ? 'Funding unavailable' : 'Fund your account',
      helpText: plan == null
          ? 'No investment plan is currently available. Please try again later.'
          : 'Review the investment details below. You will then receive the verified payment account and upload your proof of payment.',
      content: plan == null
          ? null
          : Builder(
              builder: (context) {
                final isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF172554)
                        : const Color(0xFFF8FAFF),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFFD8E5FF),
                      width: isDark ? 1.2 : 1,
                    ),
                    boxShadow: isDark
                        ? [
                            BoxShadow(
                              color: _blue.withValues(alpha: .16),
                              blurRadius: 24.r,
                              offset: Offset(0, 10.h),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      _sheetDetail(
                        'Investment',
                        plan.name ?? 'Investment Plan',
                      ),
                      _sheetDetail(
                        'Minimum deposit',
                        CurrencyFormatter.nairaText(minimum),
                      ),
                      _sheetDetail(
                        'Expected return',
                        plan.returnInterest ?? plan.interest ?? 'Flexible',
                      ),
                      _sheetDetail('Return schedule', 'Daily'),
                      _sheetDetail(
                        'Capital return',
                        plan.capitalBack == true ? 'Included' : 'Not included',
                        isLast: true,
                      ),
                    ],
                  ),
                );
              },
            ),
      primaryLabel: plan == null ? null : 'Make Deposit',
      onPrimary: plan == null
          ? null
          : () async {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.back();
              await Future<void>.delayed(const Duration(milliseconds: 320));
              final rootContext = Get.context;
              if (rootContext != null && rootContext.mounted) {
                await _showDepositFormSheet(rootContext, plan);
              }
            },
    );
  }

  Future<void> _showDepositFormSheet(
    BuildContext context,
    schema_model.Schema plan,
  ) async {
    final methods = await controller.getDepositMethods();
    final manualMethods = methods.where((method) => method.type == 'manual');
    final method = manualMethods.isNotEmpty
        ? manualMethods.first
        : methods.firstOrNull;
    if (!context.mounted) return;
    if (method == null) {
      ToastService.showInfo(
        'No verified payment account is currently available.',
        title: 'Deposit unavailable',
      );
      return;
    }

    final amountController = TextEditingController();
    File? proof;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final isDark =
              Get.isDarkMode || Theme.of(context).brightness == Brightness.dark;
          final titleColor = isDark
              ? const Color(0xFFF8FAFC)
              : const Color(0xFF0F172A);
          final mutedColor = isDark
              ? const Color(0xFF94A3B8)
              : const Color(0xFF64748B);
          final cardColor = isDark
              ? const Color(0xFF162033)
              : const Color(0xFFF8FAFC);
          final fieldColor = isDark ? const Color(0xFF111C2F) : Colors.white;
          final borderColor = isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0);
          final uploadColor = isDark
              ? const Color(0xFF172554)
              : const Color(0xFFEFF6FF);
          final uploadBorder = isDark
              ? const Color(0xFF31549A)
              : const Color(0xFFBFDBFE);
          return _actionSheetShell(
            context: context,
            icon: Icons.account_balance_rounded,
            title: 'Make deposit',
            helpText:
                'Transfer to the account below and upload your receipt for payment verification.',
            content: Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F1A2C) : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: amountController,
                    inputFormatters: const [_NairaAmountFormatter()],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: TextStyle(color: titleColor),
                    decoration: InputDecoration(
                      labelText: 'Deposit amount',
                      labelStyle: TextStyle(color: mutedColor),
                      prefixText: '₦ ',
                      prefixStyle: TextStyle(color: titleColor),
                      hintText: '0.00',
                      hintStyle: TextStyle(color: mutedColor),
                      filled: true,
                      fillColor: fieldColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: const BorderSide(color: _blue, width: 1.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15.w),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pay into this bank account',
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        _sheetDetail(
                          'Bank Name',
                          _depositValue(method.bankName),
                        ),
                        _sheetDetail(
                          'Account Name',
                          _depositValue(method.accountName),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 11.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Account Number',
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Text(
                                _depositValue(method.accountNumber),
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                tooltip: 'Copy account number',
                                onPressed: () {
                                  final number = (method.accountNumber ?? '')
                                      .trim();
                                  if (number.isEmpty) return;
                                  Clipboard.setData(
                                    ClipboardData(text: number),
                                  );
                                  ToastService.showInfo(
                                    'Account number copied to clipboard.',
                                    title: 'Copied',
                                  );
                                },
                                icon: Icon(
                                  Icons.copy_rounded,
                                  color: _blue,
                                  size: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Proof of payment',
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
                      );
                      final path = result?.files.single.path;
                      if (path != null && context.mounted) {
                        setSheetState(() => proof = File(path));
                      }
                    },
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      decoration: BoxDecoration(
                        color: uploadColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: uploadBorder),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            proof == null
                                ? Icons.upload_file_rounded
                                : Icons.check_circle_rounded,
                            color: _blue,
                            size: 27.sp,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            proof == null
                                ? 'Upload transfer receipt'
                                : proof!.path
                                      .split(Platform.pathSeparator)
                                      .last,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _blue,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'JPG, PNG or PDF',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            primaryLabel: 'Submit Deposit',
            isPrimaryLoading: controller.isSubmittingDeposit.value,
            onPrimary: () async {
              final amount = double.tryParse(
                amountController.text.replaceAll(',', '').trim(),
              );
              if (amount == null || amount <= 0) {
                ToastService.showError('Enter a valid amount.');
                return;
              }
              final minimum = method.minimumDeposit?.toDouble() ?? 0;
              final maximum = method.maximumDeposit?.toDouble() ?? 0;
              if (amount < minimum) {
                ToastService.showError(
                  'Minimum deposit is ${CurrencyFormatter.nairaText(minimum)}.',
                );
                return;
              }
              if (maximum > 0 && amount > maximum) {
                ToastService.showError(
                  'Maximum deposit is ${CurrencyFormatter.nairaText(maximum)}.',
                );
                return;
              }
              if (proof == null) {
                ToastService.showError(
                  'Upload your payment receipt before submitting.',
                );
                return;
              }
              final success = await controller.submitDepositFromHome(
                method: method,
                amount: amountController.text.replaceAll(',', '').trim(),
                proof: proof!,
              );
              if (success) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (context.mounted) Navigator.of(context).pop();
                await Future<void>.delayed(const Duration(milliseconds: 320));
                await controller.refreshData();
              }
            },
          );
        },
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 700));
    amountController.dispose();
  }

  String _depositValue(String? value) {
    final text = (value ?? '').trim();
    return text.isEmpty ? 'Not provided' : text;
  }

  Future<void> _showWithdrawFundsSheet(BuildContext context) async {
    final accounts = await controller.getWithdrawalAccounts();
    if (!context.mounted) return;
    if (accounts.isEmpty) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => _actionSheetShell(
          context: sheetContext,
          icon: Icons.account_balance_rounded,
          title: 'Add a bank account',
          helpText:
              'You need a verified bank account before you can withdraw funds. Add and verify your account details to continue.',
          primaryLabel: 'Add Bank Account',
          onPrimary: () async {
            FocusManager.instance.primaryFocus?.unfocus();
            Get.back();
            await Future<void>.delayed(const Duration(milliseconds: 320));
            final rootContext = Get.context;
            if (rootContext != null && rootContext.mounted) {
              await BankAccountDialog.show(rootContext);
            }
          },
        ),
      );
      return;
    }

    final amountController = TextEditingController();
    WithdrawAccount selected = accounts.first;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          final isDark =
              Get.isDarkMode || Theme.of(context).brightness == Brightness.dark;
          final titleColor = isDark
              ? const Color(0xFFF8FAFC)
              : const Color(0xFF0F172A);
          final mutedColor = isDark
              ? const Color(0xFF94A3B8)
              : const Color(0xFF64748B);
          final fieldColor = isDark
              ? const Color(0xFF111C2F)
              : const Color(0xFFF8FAFC);
          final borderColor = isDark
              ? const Color(0xFF334155)
              : const Color(0xFFE2E8F0);
          final earningBalance = _number(controller.profitWallet.value);
          InputDecoration fieldDecoration(String label) => InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: mutedColor),
            filled: true,
            fillColor: fieldColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: _blue, width: 1.5),
            ),
          );
          return _actionSheetShell(
            context: context,
            icon: Icons.arrow_circle_up_rounded,
            title: 'Withdraw funds',
            helpText:
                'Withdraw securely from your Earning Balance to a verified bank account.',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(17.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2452F9), Color(0xFF173DBB)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42.r,
                        height: 42.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EARNING BALANCE',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .72),
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: .8,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              CurrencyFormatter.naira(
                                earningBalance.toStringAsFixed(2),
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Available',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<WithdrawAccount>(
                  initialValue: selected,
                  isExpanded: true,
                  dropdownColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  style: TextStyle(color: titleColor, fontSize: 13.sp),
                  decoration: fieldDecoration('Receiving bank account'),
                  items: accounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account,
                          child: Text(
                            account.methodName ?? 'Bank account',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setSheetState(() => selected = value);
                  },
                ),
                SizedBox(height: 14.h),
                TextField(
                  controller: amountController,
                  inputFormatters: const [_NairaAmountFormatter()],
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(color: titleColor),
                  decoration: fieldDecoration('Withdrawal amount').copyWith(
                    labelText: 'Withdrawal amount',
                    prefixText: '₦ ',
                    prefixStyle: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w700,
                    ),
                    hintText: '0.00',
                    hintStyle: TextStyle(color: mutedColor),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 13.w,
                    vertical: 11.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: .10),
                    borderRadius: BorderRadius.circular(13.r),
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: .28),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.bolt_rounded, color: Color(0xFF10B981)),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: Text(
                          'Processing time',
                          style: TextStyle(color: mutedColor, fontSize: 11.sp),
                        ),
                      ),
                      Text(
                        'Instant',
                        style: TextStyle(
                          color: const Color(0xFF10B981),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            primaryLabel: 'Withdraw Funds',
            isPrimaryLoading: controller.isWithdrawingFunds.value,
            onPrimary: () async {
              final amountValue = double.tryParse(
                amountController.text.replaceAll(',', '').trim(),
              );
              if (amountValue == null || amountValue <= 0) {
                ToastService.showError('Enter a valid amount.');
                return;
              }
              final amount = amountValue.round();
              if (amountValue > earningBalance) {
                ToastService.showError(
                  'Amount exceeds your available Earning Balance.',
                );
                return;
              }
              final minimum = selected.method?.minWithdraw ?? 0;
              final maximum = selected.method?.maxWithdraw ?? 0;
              if (amount < minimum) {
                ToastService.showError('Minimum is ₦$minimum.');
                return;
              }
              if (maximum > 0 && amount > maximum) {
                ToastService.showError('Maximum is ₦$maximum.');
                return;
              }
              final success = await controller.withdrawFunds(
                amount: amount,
                accountId: selected.id!,
              );
              if (success) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (context.mounted) Navigator.of(context).pop();
                await Future<void>.delayed(const Duration(milliseconds: 320));
                await controller.refreshData();
              }
            },
          );
        },
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 700));
    amountController.dispose();
  }

  Widget _actionSheetShell({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String helpText,
    Widget? content,
    String? primaryLabel,
    VoidCallback? onPrimary,
    bool isPrimaryLoading = false,
  }) {
    final isDark =
        Get.isDarkMode || Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0B1220) : Colors.white,
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF172554), Color(0xFF0B1220)],
                  stops: [0, .34],
                )
              : null,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: isDark
              ? const Border(top: BorderSide(color: Color(0xFF3B82F6)))
              : null,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 28.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 38.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: mutedColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              Container(
                width: 54.r,
                height: 54.r,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2563EB)
                      : _blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF60A5FA,
                            ).withValues(alpha: .35),
                            blurRadius: 22.r,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: isDark ? Colors.white : _blue,
                  size: 27.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                helpText,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 13.sp,
                  height: 1.5,
                  fontWeight: isDark ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
              if (content != null) ...[SizedBox(height: 20.h), content],
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isPrimaryLoading
                          ? null
                          : () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.back();
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark
                            ? const Color(0xFFE2E8F0)
                            : const Color(0xFF334155),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF64748B)
                              : const Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                        minimumSize: Size.fromHeight(50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  if (primaryLabel != null && onPrimary != null) ...[
                    SizedBox(width: 10.w),
                    Expanded(
                      child: FilledButton(
                        onPressed: isPrimaryLoading ? null : onPrimary,
                        style: FilledButton.styleFrom(
                          backgroundColor: isDark
                              ? const Color(0xFF3B82F6)
                              : _blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size.fromHeight(50.h),
                          elevation: isDark ? 8 : 2,
                          shadowColor: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: .45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: isPrimaryLoading
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                primaryLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetDetail(String label, String value, {bool isLast = false}) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                      color: isDark
                          ? const Color(0xFF334E7D)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFBFDBFE)
                        : const Color(0xFF64748B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCapitalRedemption(BuildContext context) async {
    final investment = await controller.getRedeemableInvestment();
    if (!context.mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) =>
          _capitalRedemptionSheet(sheetContext, investment),
    );
  }

  Widget _capitalRedemptionSheet(
    BuildContext context,
    history_model.Invest? investment,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? const Color(0xFF1E293B) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(22.w, 12.h, 22.w, 28.h),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: mutedColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(99.r),
                  ),
                ),
              ),
              Container(
                width: 54.r,
                height: 54.r,
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.update_rounded,
                  color: const Color(0xFF059669),
                  size: 27.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                investment == null
                    ? 'No capital available to redeem'
                    : 'Confirm capital redemption',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                investment == null
                    ? 'You do not currently have an eligible ongoing investment. Capital redemption is available only during the redemption window set for an active plan.'
                    : 'Once you confirm this request, your investment will stop earning profit and your capital will be returned to your Earning Balance within 72 hours.',
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 13.sp,
                  height: 1.55,
                ),
              ),
              if (investment != null) ...[
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF0F172A)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _redemptionSummaryValue(
                          'Investment',
                          investment.schema?.name ?? 'Investment',
                          titleColor,
                          mutedColor,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      _redemptionSummaryValue(
                        'Capital',
                        CurrencyFormatter.naira(investment.investAmount),
                        titleColor,
                        mutedColor,
                        alignEnd: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.all(13.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: const Color(0xFFB45309),
                        size: 19.sp,
                      ),
                      SizedBox(width: 9.w),
                      Expanded(
                        child: Text(
                          'This action stops future earnings immediately. The 72-hour processing period cannot be skipped once confirmed.',
                          style: TextStyle(
                            color: const Color(0xFF7C4A03),
                            fontSize: 11.5.sp,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 22.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.fromHeight(48.h),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        investment == null ? 'Close' : 'Keep Investment',
                        style: TextStyle(color: titleColor),
                      ),
                    ),
                  ),
                  if (investment?.id != null) ...[
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Obx(
                        () => FilledButton(
                          onPressed: controller.isRedeemingCapital.value
                              ? null
                              : () async {
                                  final success = await controller
                                      .redeemCapital(investment!.id!);
                                  if (success && context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                          style: FilledButton.styleFrom(
                            minimumSize: Size.fromHeight(48.h),
                            backgroundColor: const Color(0xFF059669),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.r),
                            ),
                          ),
                          child: controller.isRedeemingCapital.value
                              ? SizedBox(
                                  width: 20.r,
                                  height: 20.r,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Confirm Redemption'),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _redemptionSummaryValue(
    String label,
    String value,
    Color titleColor,
    Color mutedColor, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: mutedColor,
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: TextStyle(
            color: titleColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// Compact icon-first quick actions.
  Widget _quickActionsGrid(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final actions = [
      _QuickActionData(
        title: 'Redeem Data',
        subtitle: '',
        icon: Icons.wifi_rounded,
        bgColor: Colors.transparent,
        iconColor: const Color(0xFF2452F9),
        onTap: _openDataAction,
      ),
      _QuickActionData(
        title: 'Referral',
        subtitle: '',
        icon: Icons.group_add_rounded,
        bgColor: Colors.transparent,
        iconColor: const Color(0xFF8B5CF6),
        onTap: controller.onReferral,
      ),
      _QuickActionData(
        title: 'Bank',
        subtitle: '',
        icon: Icons.account_balance_rounded,
        bgColor: Colors.transparent,
        iconColor: const Color(0xFF1EB89A),
        onTap: () => BankAccountDialog.show(context),
      ),
      _QuickActionData(
        title: 'Redeem Capital',
        subtitle: '',
        icon: Icons.lock_reset_rounded,
        bgColor: Colors.transparent,
        iconColor: const Color(0xFFF59E0B),
        onTap: () => _showCapitalRedemption(context),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            color: titleColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: actions.map((item) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.circular(18.r),
                  child: Container(
                    constraints: BoxConstraints(minHeight: 88.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: item.iconColor.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item.icon,
                            size: 20.sp,
                            color: item.iconColor,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 10.5.sp,
                            height: 1.15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  double _number(Object? v) =>
      double.tryParse(
        v.toString().replaceAll(',', '').replaceAll(RegExp(r'[^0-9.\-]'), ''),
      ) ??
      0;
}

class _QuickActionData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickActionData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
}

class _NairaAmountFormatter extends TextInputFormatter {
  const _NairaAmountFormatter();

  static final NumberFormat _wholeNumber = NumberFormat('#,##0', 'en_NG');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cleaned = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return const TextEditingValue();

    final parts = cleaned.split('.');
    final whole = parts.first.isEmpty ? '0' : parts.first;
    final parsed = int.tryParse(whole) ?? 0;
    var formatted = _wholeNumber.format(parsed);
    if (cleaned.contains('.')) {
      final decimals = parts.length > 1 ? parts[1] : '';
      formatted += '.${decimals.substring(0, decimals.length.clamp(0, 2))}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
