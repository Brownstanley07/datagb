class ReinvestResponseModel {
  final bool status;
  final String? message;
  final ReinvestData? data;

  const ReinvestResponseModel({required this.status, this.message, this.data});

  factory ReinvestResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return ReinvestResponseModel(
      status: _asBool(json['status']),
      message: json['message']?.toString(),
      data: rawData is Map
          ? ReinvestData.fromJson(Map<String, dynamic>.from(rawData))
          : null,
    );
  }

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value?.toString().toLowerCase() == 'true' || value == '1';
  }
}

class ReinvestData {
  final ReinvestWallets? wallets;
  final double? totalInvestment;
  final double? activeInvestmentBalance;
  final int? freeDataBalance;

  const ReinvestData({
    this.wallets,
    this.totalInvestment,
    this.activeInvestmentBalance,
    this.freeDataBalance,
  });

  factory ReinvestData.fromJson(Map<String, dynamic> json) {
    final rawWallets = json['wallets'];
    return ReinvestData(
      wallets: rawWallets is Map
          ? ReinvestWallets.fromJson(Map<String, dynamic>.from(rawWallets))
          : null,
      totalInvestment: _asDouble(json['total_investment']),
      activeInvestmentBalance: _asDouble(json['active_investment_balance']),
      freeDataBalance: _asDouble(json['free_data_balance'])?.round(),
    );
  }

  static double? _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value == null) return null;
    return double.tryParse(value.toString().replaceAll(',', '').trim());
  }
}

class ReinvestWallets {
  final String? mainWallet;
  final String? profitWallet;

  const ReinvestWallets({this.mainWallet, this.profitWallet});

  factory ReinvestWallets.fromJson(Map<String, dynamic> json) {
    return ReinvestWallets(
      mainWallet: json['main_wallet']?.toString(),
      profitWallet: json['profit_wallet']?.toString(),
    );
  }
}
