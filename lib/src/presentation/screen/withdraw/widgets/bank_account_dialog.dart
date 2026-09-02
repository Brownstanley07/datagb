import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData;

import '../../../../backend/secure_api_controller.dart';
import '../../../../utils/snackbar/snackbar_helper.dart';
import '../controller/withdraw_controller.dart';
import '../model/paystack_bank_response_model.dart';
import '../model/withdraw_account_response_model.dart';
import '../model/withdraw_method_response_model.dart';

const _blue = Color(0xFF2452F9);

class BankAccountDialog extends StatefulWidget {
  const BankAccountDialog({super.key});

  static Future<void> show(BuildContext context) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const BankAccountDialog(),
  );

  @override
  State<BankAccountDialog> createState() => _BankAccountDialogState();
}

class _BankAccountDialogState extends State<BankAccountDialog> {
  final _api = Get.find<SecureApiController>();
  final _formKey = GlobalKey<FormState>();
  final _accountNumber = TextEditingController();
  List<PaystackBank> _banks = const [];
  List<WithdrawAccount> _accounts = const [];
  List<WithdrawMethod> _methods = const [];
  PaystackBank? _bank;
  PaystackAccount? _match;
  Timer? _debounce;
  int _attempt = 0;
  int _formVersion = 0;
  bool _loading = true;
  bool _adding = false;
  bool _verifying = false;
  bool _saving = false;
  String? _verifyError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool keepView = false}) async {
    await _api.ensureInitialized();
    try {
      final result = await Future.wait([
        _api.api!.getPaystackBanks(),
        _api.api!.getWithdrawAccount(),
        _api.api!.withdrawMethods(),
      ]);
      if (!mounted) return;
      final accounts =
          (result[1] as WithdrawAccountsResponseModel).data?.withdrawAccounts ??
          const <WithdrawAccount>[];
      setState(() {
        _banks = (result[0] as PaystackBanksResponse).banks;
        _accounts = accounts;
        _methods =
            (result[2] as WithdrawAccountListResponseModel)
                .data
                ?.withdrawMethods ??
            const [];
        if (!keepView) _adding = accounts.isEmpty;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      ToastService.showError('Unable to load bank account details.');
    }
  }

  String? _field(WithdrawAccount account, String name) {
    for (final field in account.fields ?? const []) {
      if ((field.name ?? '').trim().toLowerCase() == name.toLowerCase()) {
        return field.value?.toString().trim();
      }
    }
    return null;
  }

  String _bankName(WithdrawAccount account) {
    final name = _field(account, 'Bank Name');
    if (name?.isNotEmpty == true) return name!;
    final fallback = (account.methodName ?? 'Bank account').split(' - ').first;
    return fallback.isEmpty ? 'Bank account' : fallback;
  }

  String _number(WithdrawAccount account) {
    final number = _field(account, 'Account Number');
    if (number?.isNotEmpty == true) return number!;
    return RegExp(r'\d{10}').firstMatch(account.methodName ?? '')?.group(0) ??
        'Account number unavailable';
  }

  void _openForm() {
    _debounce?.cancel();
    setState(() {
      _adding = true;
      _bank = null;
      _match = null;
      _verifyError = null;
      _accountNumber.clear();
      _formVersion++;
    });
  }

  void _closeForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    _debounce?.cancel();
    setState(() {
      _adding = false;
      _bank = null;
      _match = null;
      _verifyError = null;
      _accountNumber.clear();
    });
  }

  void _queueVerification() {
    _debounce?.cancel();
    _attempt++;
    if (_bank == null || _accountNumber.text.length != 10) return;
    _debounce = Timer(const Duration(milliseconds: 550), _verify);
  }

  Future<void> _verify() async {
    final bank = _bank;
    final number = _accountNumber.text.trim();
    if (bank == null || number.length != 10 || _verifying) return;
    final attempt = ++_attempt;
    setState(() {
      _verifying = true;
      _match = null;
      _verifyError = null;
    });
    try {
      final response = await _api.api!.resolvePaystackAccount(
        accountNumber: number,
        bankCode: bank.code,
      );
      if (!mounted || attempt != _attempt) return;
      setState(() {
        _match = response.status == true ? response.account : null;
        _verifyError = _match == null
            ? response.message ?? 'No matching account was found.'
            : null;
      });
    } catch (_) {
      if (mounted && attempt == _attempt) {
        setState(() {
          _verifyError = 'Check the selected bank and account number.';
        });
      }
    } finally {
      if (mounted && attempt == _attempt) {
        setState(() => _verifying = false);
      }
    }
  }

  WithdrawMethod? get _method {
    for (final method in _methods) {
      if ((method.currency ?? '').toUpperCase() == 'NGN') return method;
    }
    return _methods.firstOrNull;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_match == null) {
      ToastService.showError('Wait for Paystack to match the account name.');
      return;
    }
    final method = _method;
    if (method?.id == null) {
      ToastService.showError('No bank withdrawal method is available.');
      return;
    }
    setState(() => _saving = true);
    try {
      final values = <String, String>{
        'Bank Name': _bank!.name,
        'Bank Code': _bank!.code,
        'Account Number': _accountNumber.text.trim(),
        'Account Name': _match!.accountName,
      };
      final data = FormData.fromMap({
        'method_name': '${_bank!.name} - ${_accountNumber.text.trim()}',
        'withdraw_method_id': method!.id,
        'paystack_bank_code': _bank!.code,
        'paystack_account_number': _accountNumber.text.trim(),
        'paystack_account_name': _match!.accountName,
      });
      final fields = method.fields ?? const <dynamic>[];
      for (final entry
          in fields.isEmpty
              ? values.entries
              : fields.map((field) {
                  final name = field.name?.toString() ?? '';
                  return MapEntry(
                    name,
                    values.entries
                            .where(
                              (value) =>
                                  value.key.toLowerCase() == name.toLowerCase(),
                            )
                            .map((value) => value.value)
                            .firstOrNull ??
                        '',
                  );
                })) {
        data.fields.addAll([
          MapEntry('credentials[${entry.key}][type]', 'text'),
          MapEntry('credentials[${entry.key}][validation]', 'required'),
          MapEntry('credentials[${entry.key}][value]', entry.value),
        ]);
      }
      final response = await _api.api!.addWithdrawAccount(data);
      if (response.status != true) {
        ToastService.showError(
          response.message ?? 'Unable to save bank account.',
        );
        return;
      }
      if (Get.isRegistered<WithdrawController>()) {
        await Get.find<WithdrawController>().fetchWithdrawAccounts();
      }
      ToastService.showSuccess('Bank account saved securely.');
      _closeForm();
      await _load(keepView: true);
    } catch (_) {
      ToastService.showError('Unable to save bank account.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .9,
        ),
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        ),
        child: _loading
            ? SizedBox(
                height: 320.h,
                child: const Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  12.h,
                  20.w,
                  MediaQuery.viewInsetsOf(context).bottom + 28.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: colors.outlineVariant,
                          borderRadius: BorderRadius.circular(99.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _header(theme, colors),
                    SizedBox(height: 22.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      child: _adding
                          ? _form(theme, colors)
                          : _overview(theme, colors),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _header(ThemeData theme, ColorScheme colors) => Row(
    children: [
      Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: _blue.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Icon(Icons.account_balance_rounded, color: _blue),
      ),
      SizedBox(width: 13.w),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _adding ? 'Add new account' : 'Bank accounts',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              _adding
                  ? 'Enter your withdrawal account details'
                  : 'Manage your withdrawal accounts',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      IconButton.filledTonal(
        onPressed: _saving ? null : () => Navigator.pop(context),
        icon: const Icon(Icons.close_rounded),
      ),
    ],
  );

  Widget _overview(ThemeData theme, ColorScheme colors) => Column(
    key: const ValueKey('overview'),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (_accounts.isNotEmpty) ...[
        Text(
          'EXISTING ACCOUNTS',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        SizedBox(height: 10.h),
        ..._accounts.map(
          (account) => Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colors.outlineVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  decoration: BoxDecoration(
                    color: _blue.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: _blue,
                  ),
                ),
                SizedBox(width: 13.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bankName(account),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _number(account),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.verified_rounded, color: Color(0xFF16A34A)),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
      ],
      SizedBox(
        width: double.infinity,
        height: 58.h,
        child: FilledButton.icon(
          onPressed: _openForm,
          style: FilledButton.styleFrom(
            backgroundColor: _blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.r),
            ),
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add new account',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    ],
  );

  Widget _form(ThemeData theme, ColorScheme colors) => Form(
    key: _formKey,
    child: Column(
      key: const ValueKey('form'),
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bank details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Search your bank and enter the 10-digit account number.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 18.h),
              _bankSearch(colors),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _accountNumber,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Account number',
                  hintText: 'Enter 10 digits',
                  prefixIcon: const Icon(Icons.pin_outlined),
                  counterText: '',
                  suffixIcon: _verifying
                      ? Padding(
                          padding: EdgeInsets.all(14.r),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : _match == null
                      ? null
                      : const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFF16A34A),
                        ),
                ),
                validator: (value) => value?.length == 10
                    ? null
                    : 'Enter a valid 10-digit account number.',
                onChanged: (_) {
                  setState(() {
                    _match = null;
                    _verifyError = null;
                  });
                  _queueVerification();
                },
              ),
              SizedBox(height: 13.h),
              _accountNameField(colors),
            ],
          ),
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            if (_accounts.isNotEmpty) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : _closeForm,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(54.h),
                  ),
                  child: const Text('Back'),
                ),
              ),
              SizedBox(width: 11.w),
            ],
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _saving || _verifying || _match == null
                    ? null
                    : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: _blue,
                  minimumSize: Size.fromHeight(54.h),
                ),
                child: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save account'),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _bankSearch(ColorScheme colors) => Autocomplete<PaystackBank>(
    key: ValueKey(_formVersion),
    displayStringForOption: (bank) => bank.name,
    optionsBuilder: (value) {
      final query = value.text.trim().toLowerCase();
      return query.isEmpty
          ? _banks.take(10)
          : _banks.where((bank) => bank.name.toLowerCase().contains(query));
    },
    optionsViewBuilder: (context, onSelected, options) => Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: colors.surfaceContainerHighest,
        elevation: 18,
        borderRadius: BorderRadius.circular(18.r),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 280.h, maxWidth: 336.w),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final bank = options.elementAt(index);
              return ListTile(
                onTap: () => onSelected(bank),
                leading: const Icon(
                  Icons.account_balance_rounded,
                  color: _blue,
                ),
                title: Text(
                  bank.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            },
          ),
        ),
      ),
    ),
    onSelected: (bank) {
      setState(() {
        _bank = bank;
        _match = null;
        _verifyError = null;
      });
      _queueVerification();
    },
    fieldViewBuilder: (context, controller, focus, submit) => TextFormField(
      controller: controller,
      focusNode: focus,
      decoration: InputDecoration(
        labelText: 'Search and select bank',
        hintText: 'Start typing a bank name',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _bank == null
            ? const Icon(Icons.expand_more_rounded)
            : const Icon(Icons.check_circle_rounded, color: _blue),
      ),
      validator: (_) =>
          _bank == null ? 'Select a bank from the results.' : null,
      onChanged: (value) {
        if (_bank != null && _bank!.name != value) {
          setState(() {
            _bank = null;
            _match = null;
            _verifyError = null;
          });
        }
      },
    ),
  );

  Widget _accountNameField(ColorScheme colors) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InputDecorator(
        decoration: InputDecoration(
          labelText: 'Account name',
          prefixIcon: const Icon(Icons.person_outline_rounded),
          suffixIcon: _verifying
              ? Padding(
                  padding: EdgeInsets.all(14.r),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : _match == null
              ? null
              : const Icon(Icons.verified_rounded, color: Color(0xFF16A34A)),
          errorText: _verifyError,
        ),
        child: Text(
          _verifying
              ? 'Checking account…'
              : _match?.accountName ?? 'Linked account name will appear here',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: _match == null ? colors.onSurfaceVariant : colors.onSurface,
            fontSize: 14.sp,
            fontWeight: _match == null ? FontWeight.w500 : FontWeight.w600,
          ),
        ),
      ),
      if (_verifyError != null) ...[
        SizedBox(height: 4.h),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _verifying ? null : _verify,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Check again'),
          ),
        ),
      ],
    ],
  );

  @override
  void dispose() {
    _debounce?.cancel();
    _accountNumber.dispose();
    super.dispose();
  }
}
