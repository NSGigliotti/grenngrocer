import 'package:grenngrocer/src/constansts/endpoints.dart';
import 'package:grenngrocer/src/models/user_model.dart';
import 'package:grenngrocer/src/pages/auth/respository/auth_errors.dart'
    as authErrors;
import 'package:grenngrocer/src/pages/auth/result/auth_result.dart';
import 'package:grenngrocer/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrors.authErrorsString(result['error']));
    }
  }

  Future<bool> changePassworld(
      {required String email,
      required String currentPassword,
      required String newPassword,
      required String token}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.changePassword,
      method: HttpMetod.post,
      body: {
        'email': email,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
      headers: {'X-Parse-Session-Token': token},
    );

    return result['error'] == null ;
  }

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.validateToken,
        method: HttpMetod.post,
        headers: {'X-Parse-Session-Token': token});

    return handleUserOrError(result);
  }

  Future<AuthResult> singnIn(
      {required String email, required String password}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signin,
      method: HttpMetod.post,
      body: {
        'email': email,
        'password': password,
      },
    );

    return handleUserOrError(result);
  }

  Future<AuthResult> singnIUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signup, method: HttpMetod.post,
      //Enviad dados
      body: user.toJson(),
    );
    return handleUserOrError(result);
  }

  Future<void> resetPassword(String email) async {
    // ignore: unused_local_variable
    final result = await _httpManager.restRequest(
      url: Endpoints.resetPassword,
      method: HttpMetod.post,
      body: {'email': email},
    );
  }
}
