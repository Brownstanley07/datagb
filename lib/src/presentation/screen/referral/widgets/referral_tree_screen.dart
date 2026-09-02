import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../controller/referral_controller.dart';
import 'referral_tile.dart';
import '../../../../utils/constants/app_colors.dart';

class ReferralTreeScreen extends StatelessWidget {
  final ReferralController controller;
  const ReferralTreeScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.tree.isEmpty) {
          return Column(
            children: [
              CommonHeader(title: "referral.treeScreenTitle".trns()),
              SizedBox(height: 12.h),
              Center(child: Text("referral.noReferralTree".trns())),
            ],
          );
        }
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CommonHeader(title: "referral.treeScreenTitle".trns()),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.all(18.0.w),
                  child: Column(children: [..._buildTree(controller.tree, 0)]),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildTree(List list, int level) {
    List<Widget> widgets = [];

    for (var i = 0; i < list.length; i++) {
      final node = list[i];
      final index = node.hashCode;

      widgets.add(
        ReferralTile(
          node: node,
          isExpanded: controller.expanded.contains(index),
          indent: level * 20.w,
          onTap: node.children.isNotEmpty
              ? () => controller.toggle(index)
              : null,
        ),
      );

      if (controller.expanded.contains(index) && node.children.isNotEmpty) {
        widgets.addAll(_buildTree(node.children, level + 1));
      }
    }

    return widgets;
  }
}
