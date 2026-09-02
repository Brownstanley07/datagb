import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../dashboard/controller/dashboard_controller.dart';
import '../controller/send_money_controller.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../../../../utils/validators/form_validation.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  late final SendMoneyController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put<SendMoneyController>(
      SendMoneyController(
        secureApiController: Get.find(),
        settingsController: Get.find(),
        homeController: Get.find(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const SizedBox.expand(),
        title: Text(
          "sendMoney.title".trns(),
          style: TextStyle(
            letterSpacing: 0,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.find<DashboardController>().selectedIndex.value = 0;
        },
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return SpinLoader.loader();
            }

            if (controller.settingsController.isSendMoneyActive.value ==
                    false ||
                controller.user.value?.transferStatus == 0) {
              return Center(
                child: Text(
                  "sendMoney.notActive".trns(),
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              );
            }

            return Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0).w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthTextField(
                            label: "sendMoney.userEmailLabel".trns(),
                            hintText: 'sendMoney.userEmailHint'.trns(),
                            keyboardType: TextInputType.emailAddress,
                            controller: controller.emailController,
                            icon: Icons.alternate_email,
                            validator: (value) =>
                                FormValidation.validateEmail(value),
                          ),
                          SizedBox(height: 16.h),
                          AuthTextField(
                            label: "sendMoney.amountLabel".trns(),
                            hintText: 'sendMoney.amountHint'.trns(),
                            keyboardType: TextInputType.number,
                            controller: controller.amountController,
                            icon: Icons.attach_money,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "sendMoney.amountRequired".trns();
                              }

                              final amount = double.tryParse(value.trim());
                              if (amount == null) {
                                return "sendMoney.enterValidNumber".trns();
                              }

                              if (amount < controller.minimumAmount.value) {
                                return "${'sendMoney.minimumAmount'.trns()} ${controller.minimumAmount.value} ${controller.currency.value}";
                              }

                              if (amount > controller.maximumAmount.value) {
                                return "${'sendMoney.maximumAmount'.trns()} ${controller.maximumAmount.value} ${controller.currency.value}";
                              }

                              return null;
                            },
                          ),
                          Text(
                            controller.minimumMaximumText.value,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              letterSpacing: 0,
                              color: AppColors.error,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          AuthTextField(
                            label: "sendMoney.noteLabel".trns(),
                            hintText: 'sendMoney.noteHint'.trns(),
                            controller: controller.noteController,
                            showIcon: false,
                            isRequired: false,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 45.h),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 18,
                        right: 18,
                      ).r,
                      child: AppButton(
                        text: "sendMoney.submitButton".trns(),
                        onPressed: controller.goToReview,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
