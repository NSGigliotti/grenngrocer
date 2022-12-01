import 'package:get/get.dart';
import 'package:grenngrocer/src/pages/orders/controller/all_orders_conroller.dart';

class OrdersBindind  extends Bindings {
  @override
  void dependencies() {
    Get.put(AllOrdersController());
  }

}