import 'package:get/get.dart';
import 'package:grenngrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:grenngrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

import '../../../models/order_model.dart';
import '../orders_result/orders_result.dart';

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = [];

  final ordersRepository = OrdersRepository();

  final authController = Get.find<AuthController>();

  final utilsServices = UtilsServices();

  @override
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      userId: authController.user.id!,
      token: authController.user.token!,
    );

    result.when(success: (orders) {
      allOrders = orders
        ..sort((a, b) => b.createdDateTime!.compareTo(a.createdDateTime!));
      update();
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }
}
