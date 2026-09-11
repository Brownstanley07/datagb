import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'links.dart';
import '../common/model/country_model.dart';
import '../common/model/registration_field.dart';
import '../common/model/settings_model.dart';
import '../presentation/screen/authentication/change_password/model/change_password_response_model.dart';
import '../presentation/screen/authentication/forgot_password/model/forgot_password_model.dart';
import '../presentation/screen/authentication/login/model/login_request_model.dart';
import '../presentation/screen/authentication/login/model/login_response_model.dart';
import '../presentation/screen/authentication/onboarding/model/onboardig_response_model.dart';
import '../presentation/screen/language/model/change_language_response_model.dart';
import '../presentation/screen/language/model/language_list_response_model.dart';
import '../presentation/screen/authentication/sign_up/model/register_response_model.dart';
import 'method_types.dart';

class PublicApi {
  final DioClient client;

  PublicApi({required this.client});

  Future<RegisterResponseModel> register({required FormData request}) async {
    return await client.request(
      path: Links.register,
      method: MethodType.post,
      parse: RegisterResponseModel.fromJson,
      payload: request,
    );
  }

  Future<LoginResponseModel> login({required LoginRequestModel request}) {
    return client.request(
      path: Links.login,
      method: MethodType.post,
      parse: LoginResponseModel.fromJson,
      payload: request.toJson(),
    );
  }

  Future<ForgotPasswordResponseModel> forgotPassword({required String email}) {
    return client.request(
      path: Links.forgotPassword,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: {'email': email},
    );
  }

  Future<ForgotPasswordResponseModel> verifyOtp({
    required String email,
    required String otp,
  }) {
    return client.request(
      path: Links.verifyOtp,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: {'email': email, 'otp': otp},
    );
  }

  Future<ForgotPasswordResponseModel> changePassword({
    required ChangePasswordResponseModel request,
  }) {
    return client.request(
      path: Links.resetPassword,
      method: MethodType.post,
      parse: ForgotPasswordResponseModel.fromJson,
      payload: request.toJson(),
    );
  }

  Future<LanguageListResponseModel> getLanguage() {
    return client.request(
      path: Links.getLanguages,
      method: MethodType.get,
      parse: LanguageListResponseModel.fromJson,
    );
  }

  Future<ChangeLanguageListResponseModel> changeLanguage({
    required String locale,
  }) {
    return client.request(
      path: "${Links.changeLanguage}$locale",
      method: MethodType.get,
      parse: ChangeLanguageListResponseModel.fromJson,
    );
  }

  Future<CountryModelResponse> getCountry() {
    return client.request(
      path: Links.getCountries,
      method: MethodType.get,
      parse: CountryModelResponse.fromJson,
    );
  }

  Future<SettingResponseModel> getSettings() {
    return client.request(
      path: Links.getSettings,
      method: MethodType.get,
      parse: SettingResponseModel.fromJson,
    );
  }

  Future<RegistrationResponseModel> getRegistrationField() {
    return client.request(
      path: Links.registrationField,
      method: MethodType.get,
      parse: RegistrationResponseModel.fromJson,
    );
  }

  Future<OnboardingResponseModel> getOnboardingData() {
    return client.request(
      path: Links.getOnboardingImage,
      method: MethodType.get,
      parse: OnboardingResponseModel.fromJson,
    );
  }
}
