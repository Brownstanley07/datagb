import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/auth_text_field/auth_text_field.dart';
import '../../../../common/widgets/common_button/app_button.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../common/widgets/file_picker/document_picker.dart';
import '../controller/my_ticket_controller.dart';
import '../../../../utils/validators/form_validation.dart';

class AddNewTicket extends GetView<MyTicketController> {
  const AddNewTicket({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonHeader(title: 'myTicket.addNewTicket.title'.trns()),
              Padding(
                padding: EdgeInsets.all(18.0.sp),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'myTicket.addNewTicket.ticketTitleLabel'.trns(),
                        hintText: 'myTicket.addNewTicket.ticketTitleHint'
                            .trns(),
                        controller: controller.titleController,
                        showIcon: false,
                        validator: (value) =>
                            FormValidation.validateCustomField(
                              value,
                              'myTicket.addNewTicket.ticketTitleLabel'.trns(),
                            ),
                      ),
                      SizedBox(height: 20.h),
                      AuthTextField(
                        label: 'myTicket.addNewTicket.descriptionLabel'.trns(),
                        hintText: 'myTicket.addNewTicket.descriptionHint'
                            .trns(),
                        controller: controller.descriptionController,
                        showIcon: false,
                        validator: (value) =>
                            FormValidation.validateCustomField(
                              value,
                              'myTicket.addNewTicket.descriptionLabel'.trns(),
                            ),
                        maxLines: 4,
                      ),
                      SizedBox(height: 20.h),
                      Obx(
                        () => FilePickerField(
                          label: 'myTicket.addNewTicket.attachmentsLabel'
                              .trns(),
                          onFilePicked: () => controller.pickFile('attach'),
                          selectedFile: controller.pickedFiles['attach'],
                        ),
                      ),
                      SizedBox(height: 80.h),
                      Obx(
                        () => AppButton(
                          text: 'myTicket.addNewTicket.submitButton'.trns(),
                          onPressed: controller.submitTicket,
                          isLoading: controller.isSubmitting.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
