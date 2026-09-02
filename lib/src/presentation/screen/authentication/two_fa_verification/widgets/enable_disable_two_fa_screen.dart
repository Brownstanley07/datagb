import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../../common/widgets/common_button/app_button.dart';
import '../../../../../common/widgets/extension/translation_extension.dart';
import '../controller/two_fa_verification_controller.dart';
import '../../../../../utils/constants/app_colors.dart';
import '../../../../../utils/validators/form_validation.dart';

class TwoFactorSecurityScreen extends StatelessWidget {
  const TwoFactorSecurityScreen({super.key, required this.controller});
  final TwoFaVerificationController controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16.h),

          /// Description
          Text(
            "twoFaVerificationPage.twoFactorSecurity.description".trns(),
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 0,
              fontSize: 13.sp,
              color: AppColors.subText.withValues(alpha: 0.6),
              height: 1.6,
            ),
          ),

          SizedBox(height: 24.h),

          /// Yellow info box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFFFFD54F),
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            child: Text(
              "twoFaVerificationPage.twoFactorSecurity.scanQrCode".trns(),
              style: TextStyle(
                letterSpacing: 0,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          SizedBox(height: 24.h),

          /// QR Code Container
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: RepaintBoundary(
                child: _buildQrWidget(controller.user.value?.the2FaQrCode),
              ),
            ),
          ),

          SizedBox(height: 24.h),

          /// PIN Label
          AuthTextField(
            label: 'twoFaVerificationPage.twoFactorSecurity.authLabel'.trns(),
            hintText: "twoFaVerificationPage.twoFactorSecurity.authHint".trns(),
            icon: Icons.password,
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            validator: (value) =>
                FormValidation.validateCustomField(value, 'PIN'),
          ),

          const SizedBox(height: 50),

          /// Enable Button
          AppButton(
            text: controller.user.value?.twoFa == true
                ? 'twoFaVerificationPage.twoFactorSecurity.disable2fa'.trns()
                : 'twoFaVerificationPage.twoFactorSecurity.enable2fa'.trns(),
            onPressed: () {
              if (controller.user.value?.twoFa == true) {
                controller.submitDisable2Fa();
              } else {
                controller.submitEnable2Fa();
              }
            },
            isLoading:
                controller.is2faEnabled.value || controller.is2faDisabled.value,
          ),

          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildQrWidget(String? qrData) {
    if (qrData == null || qrData.isEmpty) {
      return const SizedBox.shrink();
    }

    const double qrSize = 256;

    try {
      /// BASE64 IMAGE (PNG / SVG)
      if (qrData.startsWith('data:image')) {
        final uri = Uri.parse(qrData);
        final data = uri.data;
        if (data == null) {
          return Text('twoFaVerificationPage.invalidQrCode'.trns());
        }

        final bytes = data.contentAsBytes();
        final mime = data.mimeType.toLowerCase();

        /// SVG BASE64
        if (mime == 'image/svg+xml') {
          return SvgPicture.memory(
            bytes,
            width: qrSize.w,
            height: qrSize.w,
            fit: BoxFit.contain,
            allowDrawingOutsideViewBox: true,
          );
        }

        /// PNG / JPG BASE64
        return Image.memory(
          bytes,
          width: qrSize.w,
          height: qrSize.w,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
          gaplessPlayback: true,
        );
      }

      /// RAW SVG STRING
      return SvgPicture.string(
        qrData,
        width: qrSize.w,
        height: qrSize.w,
        fit: BoxFit.contain,
        allowDrawingOutsideViewBox: true,
      );
    } catch (_) {
      return Text('twoFaVerificationPage.invalidQrCode'.trns());
    }
  }
}
