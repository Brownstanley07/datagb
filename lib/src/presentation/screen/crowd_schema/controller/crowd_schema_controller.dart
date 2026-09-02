import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../backend/secure_api_controller.dart';
import '../model/all_crowd_schema_model.dart';
import '../../home/controller/home_controller.dart';

class CrowdSchemaController extends GetxController {
  SecureApiController secureApiController;

  CrowdSchemaController({required this.secureApiController});

  RxBool isLoading = false.obs;
  RxList<CrowdSchema> schemas = <CrowdSchema>[].obs;
  Rxn<CrowdSchema> selectedSchema = Rxn<CrowdSchema>();
  HomeController homeController = Get.find();

  @override
  void onInit() {
    super.onInit();
    loadCrowdSchemas();
  }

  Future<void> loadCrowdSchemas() async {
    isLoading.value = true;
    await _fetchSchemas();
    isLoading.value = false;
  }

  Future<void> refreshCrowdSchemas() async {
    isLoading.value = true;
    await _fetchSchemas();
    isLoading.value = false;
  }

  Future<void> _fetchSchemas() async {
    await secureApiController.ensureInitialized();
    try {
      final response = await secureApiController.api!.getCrowdSchemas();
      if (response.status == true) {
        schemas.value = response.data?.crowdSchemas ?? [];

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

  void selectCrowdSchema(CrowdSchema schema) {
    selectedSchema.value = schema;
  }
}
