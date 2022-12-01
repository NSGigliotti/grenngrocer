import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grenngrocer/src/config/custom_colors.dart';
import 'package:grenngrocer/src/models/cart_item_model.dart';
import 'package:grenngrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:grenngrocer/src/pages/widget/quantity_widget.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

class CartTitle extends StatefulWidget {
  final CartItemModel cartItem;

  const CartTitle({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  @override
  State<CartTitle> createState() => _CartTitleState();
}

class _CartTitleState extends State<CartTitle> {
  final UtilsServices util = UtilsServices();

  final controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        //* imagem
        leading: Image.network(
          widget.cartItem.item.imgUrl,
          height: 60,
          width: 60,
        ),

        //* titulo
        title: Text(
          widget.cartItem.item.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        //*total
        subtitle: Text(
          util.priceToCurremcy(widget.cartItem.totalPrice()),
          style: TextStyle(
            color: CustomColors.customSwatchColor,
            fontWeight: FontWeight.bold,
          ),
        ),

        //*quantitdade
        trailing: QuantityWidget(
          isRemoveble: true,
          sufixText: widget.cartItem.item.unit,
          value: widget.cartItem.quantity,
          result: (quantity) {
            controller.changeItemQuantity(item: widget.cartItem, quantity: quantity);
          },
        ),
      ),
    );
  }
}
