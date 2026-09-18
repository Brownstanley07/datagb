import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/settings_controller/settings_controller.dart';
import '../../utils/snackbar/snackbar_helper.dart';
import 'whatsapp_support/whatsapp_support_button.dart';

class CommunityLinksCard extends StatelessWidget {
  const CommunityLinksCard({super.key});

  Future<void> _openTelegram(SettingsController settings) async {
    await settings.fetchSettings(force: true);
    final url = Uri.tryParse(settings.telegramChannelUrl.value.trim());
    if (url == null ||
        url.scheme != 'https' ||
        !['t.me', 'telegram.me'].contains(url.host.toLowerCase()) ||
        url.pathSegments.where((part) => part.isNotEmpty).isEmpty) {
      ToastService.showInfo('Telegram community link is not available yet.');
      return;
    }

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        ToastService.showError('Telegram could not be opened.');
      }
    } catch (_) {
      ToastService.showError('Telegram could not be opened.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: dark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Join our community',
            style: TextStyle(
              color: dark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 15.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 10.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(
                () => OutlinedButton.icon(
                  onPressed: () => WhatsAppSupportButton.openSupport(settings),
                  icon: const Icon(Icons.chat_outlined),
                  label: Text(
                    settings.whatsAppSupportType.value == 'group'
                        ? 'WhatsApp group'
                        : 'WhatsApp chat',
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              OutlinedButton.icon(
                onPressed: () => _openTelegram(settings),
                icon: const Icon(Icons.send_outlined),
                label: const Text('Telegram group'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
