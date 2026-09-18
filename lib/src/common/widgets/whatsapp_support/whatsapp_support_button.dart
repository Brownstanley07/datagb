import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/settings_controller/settings_controller.dart';
import '../../../utils/snackbar/snackbar_helper.dart';

class WhatsAppSupportButton extends StatelessWidget {
  const WhatsAppSupportButton({super.key});

  static Future<void> openSupport(SettingsController settings) async {
    // Settings can be changed from the admin panel while the app is open.
    // Refresh before resolving the destination so phone/group changes apply
    // immediately without requiring a reinstall or process restart.
    await settings.fetchSettings(force: true);

    if (!settings.isWhatsAppSupportEnabled.value) {
      ToastService.showInfo(
        'WhatsApp support is currently unavailable.',
        title: 'Support unavailable',
      );
      return;
    }

    final Uri? destination;
    if (settings.whatsAppSupportType.value == 'group') {
      destination = Uri.tryParse(settings.whatsAppSupportGroup.value.trim());
    } else {
      final phone = settings.whatsAppSupportPhone.value.replaceAll(
        RegExp(r'[^0-9]'),
        '',
      );
      destination = phone.isEmpty ? null : Uri.parse('https://wa.me/$phone');
    }

    if (destination == null) {
      ToastService.showInfo(
        'WhatsApp support has not been configured yet.',
        title: 'Support unavailable',
      );
      return;
    }

    try {
      final opened = await launchUrl(
        destination,
        mode: LaunchMode.externalApplication,
      );
      if (!opened) {
        ToastService.showError('WhatsApp support could not be opened.');
      }
    } catch (_) {
      ToastService.showError('WhatsApp support could not be opened.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();
    return Obx(() {
      if (!settings.isWhatsAppSupportEnabled.value) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: EdgeInsets.only(right: 8.w),
        child: GestureDetector(
          onTap: () => openSupport(settings),
          child: Semantics(
            button: true,
            label: 'Open WhatsApp support',
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF3D7BFF), Color(0xFF1554DB)],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .85),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33164FD2),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
          ),
        ),
      );
    });
  }
}
