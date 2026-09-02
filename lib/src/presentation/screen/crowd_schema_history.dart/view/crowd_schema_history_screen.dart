import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../app/routes/routes.dart';
import '../../../../common/widgets/common_hader/common_header.dart';
import '../../../../common/widgets/extension/translation_extension.dart';
import '../../../../utils/constants/app_colors.dart';
import '../../../../utils/helper/spin_loader.dart';
import '../controller/croed_schema_history_controller.dart';
import '../widgets/crowd_history_item.dart';

class CrowdSchemaHistoryScreen extends GetView<CrowdSchemaHistoryController> {
  const CrowdSchemaHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
          Get.offAllNamed(BaseRoute.dashboard);
        },
        child: SafeArea(
          child: Column(
            children: [
              CommonHeader(
                title: "crowdSchemaHistory.title".trns(),
                backToDashboard: controller.backToHome.value,
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.refreshHistory();
                  },
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return SpinLoader.loader();
                    }
                    if (controller.crowdInvest.isEmpty) {
                      return LayoutBuilder(
                        builder: (context, constraints) => ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: constraints.maxHeight,
                              child: Center(
                                child: Text(
                                  "crowdSchemaHistory.noCrowdSchemaHistory"
                                      .trns(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: controller.scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.crowdInvest.length,
                            padding: EdgeInsets.all(18.w),
                            itemBuilder: (BuildContext context, int index) {
                              final item = controller.crowdInvest[index];
                              return CrowdHistoryItem(item: item);
                            },
                          ),
                        ),
                        if (controller.isLoadMore.value)
                          Padding(
                            padding: EdgeInsets.all(10.0.w),
                            child: SpinLoader.loader(size: 30),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
