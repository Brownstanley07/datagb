import 'package:get/get.dart';
import '../../../backend/public_api.dart';
import '../../model/country_model.dart';

class CountryListController extends GetxController {
  final PublicApi publicApi;

  CountryListController({required this.publicApi});

  RxBool isLoading = false.obs;
  RxList<Country> countries = <Country>[].obs;

  Future<void> fetchCountries() async {
    isLoading.value = true;
    try {
      final response = await publicApi.getCountry();
      if (response.status == true) {
        countries.value = response.data?.countries ?? [];
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
