import 'package:grenngrocer/src/models/item_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {

  @JsonKey(name: 'product')
  ItemModel item;

  String id;
  int quantity;

  CartItemModel({
    required this.id,
    required this.item,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);

  Map<String, dynamic> tojason() => _$CartItemModelToJson(this);

  double totalPrice() => item.price * quantity;
}