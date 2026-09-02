import 'package:get/get.dart';
import 'auth_persist_data.dart';
import 'dio_client.dart';
import 'links.dart';
import 'secure_api.dart';

class SecureApiController extends GetxController {
  SecureApi? api;
  bool isInitialized = false;
  Future<void>? _initialization;

  @override
  void onInit() {
    super.onInit();
    initApi();
  }

  Future<void> initApi() async {
    _initialization ??= _initialize();
    await _initialization;
  }

  Future<void> _initialize() async {
    try {
      final authData = await AuthPersistData().getAuthData();
      final client = DioClient(baseUrl: Links.baseUrl, clientName: 'SECURED');
      client.setToken(authData.token);
      api = SecureApi(client: client);
      isInitialized = true;
    } catch (e) {
      isInitialized = false;
      Get.log("Initialization error: $e");
    } finally {
      _initialization = null;
    }
  }

  Future<void> ensureInitialized() async {
    // Always re-read the persisted token. This covers the login -> dashboard
    // race where this controller was created before login saved the token.
    final authData = await AuthPersistData().getAuthData();
    if (api == null || !isInitialized) {
      await initApi();
    } else {
      api!.client.setToken(authData.token);
    }
  }
}
