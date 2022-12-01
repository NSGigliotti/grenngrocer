import 'package:grenngrocer/src/constansts/endpoints.dart';
import 'package:grenngrocer/src/models/cart_item_model.dart';
import 'package:grenngrocer/src/models/order_model.dart';
import 'package:grenngrocer/src/services/http_manager.dart';

import '../orders_result/orders_result.dart';

class OrdersRepository {
  final _httpManager = HttpManager();

  Future<OrdersResult<List<CartItemModel>>> getOrdersItems(
      {required String orderId, required String token}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getOrderItems,
      method: HttpMetod.post,
      body: {'orderId': orderId},
      headers: {'X-Parse-Session-Token': token},
    );

    if (result['result'] != null) {
      List<CartItemModel> items =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();

      return OrdersResult<List<CartItemModel>>.success(items);
    } else {
      return OrdersResult.error(
          'Nao foi possivel recuperar os items do pedido');
    }
  }

  Future<OrdersResult<List<OrderModel>>> getAllOrders(
      {required String userId, required String token}) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.getAllOrders,
      method: HttpMetod.post,
      body: {'user': userId},
      headers: {'X-Parse-Session-Token': token},
    );

    if (result['result'] != null) {
      List<OrderModel> orders =
          List<Map<String, dynamic>>.from(result['result'])
              .map(OrderModel.fromJson)
              .toList();

      return OrdersResult.success(orders);
    } else {
      return OrdersResult.error('Nao foi possivel recuperar os pedidos');
    }
  }
}
