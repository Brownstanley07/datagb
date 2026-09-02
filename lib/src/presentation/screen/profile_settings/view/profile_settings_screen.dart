import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/string_extension.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/validators/form_validation.dart';
import '../controller/profile_settings_controller.dart';

const Color _blue = Color(0xFF2452F9);

class ProfileSettingsScreen extends GetView<ProfileSettingsController> {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
    final Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final Color borderColor = isDark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final Color subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            const CommonHeader(title: "Edit Profile"),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return SpinLoader.loader();
                }

                // Synchronize Full Name text controller from first & last name
                final fn = controller.firstNameController.text.trim();
                final ln = controller.lastNameController.text.trim();
                final combined = [fn, ln].where((e) => e.isNotEmpty).join(' ');

                final fullNameController = TextEditingController(
                  text: combined,
                );

                return Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 36.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _avatarSection(
                          isDark: isDark,
                          subtitleColor: subtitleColor,
                        ),
                        SizedBox(height: 22.h),

                        _sectionCard(
                          title: 'Profile Information',
                          icon: Icons.person_outline_rounded,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          titleColor: titleColor,
                          isDark: isDark,
                          children: [
                            // Full Name Field (Replacing First & Last Name)
                            AuthTextField(
                              label: "Full Name",
                              hintText: "Enter your full name",
                              controller: fullNameController,
                              icon: Icons.person_outline_rounded,
                              keyboardType: TextInputType.name,
                              onChanged: (val) {
                                final parts = val.trim().split(' ');
                                controller.firstNameController.text =
                                    parts.first;
                                controller.lastNameController.text =
                                    parts.length > 1
                                    ? parts.sublist(1).join(' ')
                                    : '';
                              },
                              validator: (value) =>
                                  FormValidation.validateName(value),
                            ),
                            SizedBox(height: 16.h),

                            // Email Address Field (Replacing username)
                            AuthTextField(
                              label: "Email Address",
                              hintText: "Your email address",
                              controller: controller.emailController,
                              icon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                            ),
                          ],
                        ),

                        if (controller.registrationFields.isNotEmpty) ...[
                          SizedBox(height: 20.h),
                          _sectionCard(
                            title: 'Additional Details',
                            icon: Icons.article_outlined,
                            cardBg: cardBg,
                            borderColor: borderColor,
                            titleColor: titleColor,
                            isDark: isDark,
                            children: _buildDynamicFields(),
                          ),
                        ],
                        SizedBox(height: 28.h),
                        SizedBox(
                          height: 50.h,
                          child: Obx(() {
                            return AppButton(
                              text: "Save Changes",
                              isLoading: controller.isSubmitting.value,
                              onPressed: () {
                                final parts = fullNameController.text
                                    .trim()
                                    .split(' ');
                                controller.firstNameController.text =
                                    parts.first;
                                controller.lastNameController.text =
                                    parts.length > 1
                                    ? parts.sublist(1).join(' ')
                                    : '';
                                controller.saveChanges();
                              },
                              backgroundColor: _blue,
                              borderRadius: 16.r,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Avatar Upload Section
  Widget _avatarSection({required bool isDark, required Color subtitleColor}) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Obx(() {
                final url = controller.avatarUrl.value;
                final pickedImage = controller.pickedImage.value;

                return Container(
                  height: 110.r,
                  width: 110.r,
                  padding: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _blue.withValues(alpha: 0.4),
                      width: 2.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.08),
                        blurRadius: 16.r,
                        offset: Offset(0, 6.h),
                      ),
                    ],
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: pickedImage != null
                        ? Image.file(pickedImage, fit: BoxFit.cover)
                        : url.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: AppColors.shimmerBase,
                              highlightColor: AppColors.shimmerHighlight,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              AppImages.avatar,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(AppImages.avatar, fit: BoxFit.cover),
                  ),
                );
              }),
              GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: _blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5.w),
                    boxShadow: [
                      BoxShadow(
                        color: _blue.withValues(alpha: 0.3),
                        blurRadius: 8.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 17.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'Tap camera icon to update profile picture',
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    required Color cardBg,
    required Color borderColor,
    required Color titleColor,
    required bool isDark,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _blue, size: 18.sp),
              SizedBox(width: 8.w),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }

  List<Widget> _buildDynamicFields() {
    if (controller.registrationFields.isEmpty) return [];
    return controller.registrationFields.map((field) {
      final fieldName = field.name ?? 'common.unnamedField'.trns();
      final isRequired = field.validation == 'required';
      final fieldController =
          controller.dynamicTextControllers[fieldName] ??
          TextEditingController();

      Widget fieldWidget;

      if (field.type == 'text' || field.type == 'textarea') {
        fieldWidget = AuthTextField(
          label: fieldName.toReadableText(),
          hintText: fieldName,
          controller: fieldController,
          showIcon: false,
          isRequired: isRequired,
          maxLines: field.type == 'textarea' ? 3 : 1,
          validator: (value) {
            if (isRequired) {
              return FormValidation.validateCustomField(value, fieldName);
            }
            return null;
          },
        );
      } else if (field.type == 'file') {
        fieldWidget = Obx(() {
          final pickedFile = controller.pickedFiles[fieldName];
          final existingFileUrl = controller.existingFiles[fieldName];

          File? displayFile;
          if (pickedFile != null) {
            displayFile = pickedFile;
          }

          return FilePickerField(
            label: fieldName.toReadableText(),
            isRequired: isRequired,
            onFilePicked: () => controller.pickFile(fieldName),
            selectedFile: displayFile,
            existingFileUrl: existingFileUrl,
          );
        });
      } else if (field.type == "camera") {
        fieldWidget = Obx(() {
          final pickedFile = controller.pickedImages[fieldName];
          final existingFileUrl = controller.existingImages[fieldName];

          File? displayFile;
          if (pickedFile != null) {
            displayFile = pickedFile;
          }

          return FilePickerField(
            label: fieldName.toReadableText(),
            isRequired: isRequired,
            onFilePicked: () => controller.pickFileFromCamera(fieldName),
            selectedFile: displayFile,
            existingFileUrl: existingFileUrl,
          );
        });
      } else {
        fieldWidget = const SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: fieldWidget,
      );
    }).toList();
  }
}
