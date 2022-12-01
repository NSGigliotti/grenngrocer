import 'package:get/get.dart';
import 'package:grenngrocer/src/constansts/storage_keys.dart';
import 'package:grenngrocer/src/models/user_model.dart';
import 'package:grenngrocer/src/pages/auth/respository/auth_respository.dart';
import 'package:grenngrocer/src/pages/auth/result/auth_result.dart';
import 'package:grenngrocer/src/pages_routes/app_pages.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final authRepository = AuthRepository();
  final utilsServices = UtilsServices();

  UserModel user = UserModel();

  @override
  void onInit() {
    super.onInit();

    validateToken();
  }

  Future<void> validateToken() async {
    String? token = await utilsServices.getlocalData(key: StorageKeys.token);
    if (token == null) {
      Get.offAllNamed(PageRoutes.songInRoutes);
      return;
    }
    AuthResult result = await authRepository.validateToken(token);
    result.when(
      success: (user) {
        this.user = user;
        Get.offAllNamed(PageRoutes.songInRoutes);
        saveTokenAndProcedToBase();
      },
      error: (message) {
        signOut();
      },
    );
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    isLoading.value = true;

    final result = await authRepository.changePassworld(
      email: user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
      token: user.token!,
    );

    isLoading.value = false;

    if (result) {
      utilsServices.showToast(message: 'A senha atualizada com sucesso');

      signOut();
    } else {
      utilsServices.showToast(
          message: 'Senha atual esta incorreta', isError: true);
    }
  }

  Future<void> signOut() async {
    //*zerar o user
    user = UserModel();

    //* remover o token locamlmente
    await utilsServices.removeLocalData(key: StorageKeys.token);

    //* ir para o login
    Get.offAndToNamed(PageRoutes.songInRoutes);
  }

  void saveTokenAndProcedToBase() {
    utilsServices.saveLocalData(key: StorageKeys.token, data: user.token!);

    Get.offAllNamed(PageRoutes.baseRoute);
  }

  Future<void> signUp() async {
    isLoading.value = true;

    AuthResult result = await authRepository.singnIUp(user);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProcedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    AuthResult result = await authRepository.singnIn(
      email: email,
      password: password,
    );

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;
        saveTokenAndProcedToBase();
      },
      error: (message) {
        utilsServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}
