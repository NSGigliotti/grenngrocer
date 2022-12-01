import 'package:get/get.dart';
import 'package:grenngrocer/src/models/cart_item_model.dart';
import 'package:grenngrocer/src/models/order_model.dart';
import 'package:grenngrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:grenngrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

import '../orders_result/orders_result.dart';

class OrderController extends GetxController {
  OrderModel order;

  OrderController(this.order);

  final ordersRepository = OrdersRepository();
  final utilsServices = UtilsServices();
  final authController = Get.find<AuthController>();

  bool isLoading = false;

  void setLoadding(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getOdersItems() async {
    setLoadding(true);

    final OrdersResult<List<CartItemModel>> result =
        await ordersRepository.getOrdersItems(
      orderId: order.id,
      token: authController.user.token!,
    );

    setLoadding(false);

    result.when(success: (items) {
      order.items = items;
      update();
    }, error: (message) {
      utilsServices.showToast(message: message, isError: true);
    });
  }
}
