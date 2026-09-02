class PaystackBanksResponse {
  final bool? status;
  final List<PaystackBank> banks;

  const PaystackBanksResponse({this.status, this.banks = const []});

  factory PaystackBanksResponse.fromJson(Map<String, dynamic> json) {
    final values = json['data']?['banks'] as List<dynamic>? ?? const [];
    return PaystackBanksResponse(
      status: json['status'] as bool?,
      banks: values
          .map((item) => PaystackBank.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PaystackBank {
  final String name;
  final String code;

  const PaystackBank({required this.name, required this.code});

  factory PaystackBank.fromJson(Map<String, dynamic> json) => PaystackBank(
    name: json['name']?.toString() ?? '',
    code: json['code']?.toString() ?? '',
  );
}

class PaystackAccountResponse {
  final bool? status;
  final String? message;
  final PaystackAccount? account;

  const PaystackAccountResponse({this.status, this.message, this.account});

  factory PaystackAccountResponse.fromJson(Map<String, dynamic> json) =>
      PaystackAccountResponse(
        status: json['status'] as bool?,
        message: json['message']?.toString(),
        account: json['data']?['bank_account'] == null
            ? null
            : PaystackAccount.fromJson(
                json['data']['bank_account'] as Map<String, dynamic>,
              ),
      );
}

class PaystackAccount {
  final String accountName;
  final String accountNumber;
  final String bankCode;
  final String bankName;

  const PaystackAccount({
    required this.accountName,
    required this.accountNumber,
    required this.bankCode,
    required this.bankName,
  });

  factory PaystackAccount.fromJson(Map<String, dynamic> json) =>
      PaystackAccount(
        accountName: json['account_name']?.toString() ?? '',
        accountNumber: json['account_number']?.toString() ?? '',
        bankCode: json['bank_code']?.toString() ?? '',
        bankName: json['bank_name']?.toString() ?? '',
      );
}
