import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../model/all_schema_response_model.dart';
import '../../home/controller/home_controller.dart';
import '../../deposit/model/deposit_method_response.dart';

class AllSchemaController extends GetxController {
  final SecureApiController secureApiController;
  AllSchemaController({required this.secureApiController});

  final HomeController homeController = Get.find();
  RxBool isLoading = false.obs;
  RxList<Schema> schemas = <Schema>[].obs;
  Rxn<Schema> selectedSchema = Rxn<Schema>();
  RxBool isLoadingDepositMethods = false.obs;
  RxList<DepositMethod> depositMethods = <DepositMethod>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSchemas();
  }

  Future<void> loadSchemas() async {
    isLoading.value = true;
    await _fetchSchemas();

    isLoading.value = false;
  }

  Future<void> refreshSchemas() async {
    isLoading.value = true;
    await _fetchSchemas();
    isLoading.value = false;
  }

  Future<void> _fetchSchemas() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getSchemas();
      if (response.status == true) {
        schemas.value = response.data?.schemas ?? [];

        if (schemas.isNotEmpty) {
          selectedSchema.value = schemas.first;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void selectSchema(Schema schema) {
    selectedSchema.value = schema;
  }

  Future<void> loadDepositMethods() async {
    isLoadingDepositMethods.value = true;
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getDepositMethod();
      depositMethods.assignAll(
        (response.data?.depositMethods ?? [])
            .where((method) => method.type == 'manual')
            .toList(),
      );
    } catch (e) {
      if (kDebugMode) print(e);
      depositMethods.clear();
    } finally {
      isLoadingDepositMethods.value = false;
    }
  }
}
