import 'package:grenngrocer/src/constansts/endpoints.dart';
import 'package:grenngrocer/src/models/cart_item_model.dart';
import 'package:grenngrocer/src/models/order_model.dart';
import 'package:grenngrocer/src/pages/cart/cart_result/cart_result.dart';
import 'package:grenngrocer/src/services/http_manager.dart';

class CartRepository {
  final _httpManeger = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems(
      {required String token, required String userId}) async {
    final result = await _httpManeger.restRequest(
      url: Endpoints.getCartItems,
      method: HttpMetod.post,
      headers: {
        'X-Parse-Session-Token': token,
      },
      body: {
        'user': userId,
      },
    );

    if (result['result'] != null) {
      List<CartItemModel> data =
          List<Map<String, dynamic>>.from(result['result'])
              .map(CartItemModel.fromJson)
              .toList();

      return CartResult<List<CartItemModel>>.success(data);
    } else {
      return CartResult.error(
          'OCorreu um erro ao recuperar os item do carinho');
    }
  }

  Future<CartResult<OrderModel>> checkoutCart(
      {required String token, required double total}) async {
    final result = await _httpManeger.restRequest(
      url: Endpoints.checkout,
      method: HttpMetod.post,
      body: {'total': total},
      headers: {'X-Parse-Session-Token': token},
    );

    if (result['result'] != null) {
      final order = OrderModel.fromJson(result['result']);
      return CartResult.success(order);
    } else {
      return CartResult.error('Nao e possivel realizar o pedido');
    }
  }

  Future<bool> changeItemQuantity(
      {required String token,
      required String cartItemId,
      required int quantity}) async {
    final result = await _httpManeger.restRequest(
      url: Endpoints.changeItemQuantity,
      method: HttpMetod.post,
      body: {
        'cartItemId': cartItemId,
        'quantity': quantity,
      },
      headers: {'X-Parse-Session-Token': token},
    );

    return result.isEmpty;
  }

  Future<CartResult<String>> addItemToCart({
    required String userId,
    required String token,
    required String productId,
    required int quantity,
  }) async {
    final result = await _httpManeger.restRequest(
      url: Endpoints.addItemToCart,
      method: HttpMetod.post,
      body: {'user': userId, 'quantity': quantity, 'productId': productId},
      headers: {'X-Parse-Session-Token': token},
    );

    if (result['result'] != null) {
      return CartResult.success(result['result']['id']);
    } else {
      return CartResult.error('Nao foi possivel adiconar o item no carrinho');
    }
  }
}
