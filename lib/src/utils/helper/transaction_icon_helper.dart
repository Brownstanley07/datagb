import '../../common/widgets/extension/translation_extension.dart';
import '../constants/image_string.dart';

class TransactionIconHelper {
  static final Map<String, dynamic> transactionIcons = {
    "deposit": AppImages.depositIcon,
    "subtract": AppImages.subtractIcon,
    "manual_deposit": AppImages.manualDepositIcon,
    "send_money": AppImages.sendMoneyIcon,
    "exchange": AppImages.exchangeIcon,
    "referral": AppImages.referralIcon,
    "signup_bonus": AppImages.signupBonusIcon,
    "bonus": AppImages.bonusIcon,
    "withdraw": AppImages.withdrawIcon,
    "withdraw_auto": AppImages.withdrawAutoIcon,
    "receive_money": AppImages.receiveMoneyIcon,
    "investment": AppImages.investIcon,
    "interest": AppImages.interestIcon,
    "refund": AppImages.refundIcon,
    "reward_redeem": AppImages.rewardRedeemIcon,
    "portfolio_bonus": AppImages.portfolioBonusIcon,
  };

  static String getIcon(String type) {
    return transactionIcons[type] ?? AppImages.withdrawAutoIcon;
  }
}

class GetDayTimeNow {
  static final Map<String, dynamic> timeNow = {
    "morning": "home.dayTime.morning".trns(),
    "noon": "home.dayTime.noon".trns(),
    "night": "home.dayTime.night".trns(),
    "afternoon": "home.dayTime.afternoon".trns(),
    "evening": "home.dayTime.evening".trns(),
  };

  static String getTimeNow(String time) {
    return timeNow[time] ?? "Welcome";
  }
}
