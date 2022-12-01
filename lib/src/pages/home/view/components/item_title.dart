import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grenngrocer/src/config/custom_colors.dart';
import 'package:grenngrocer/src/models/item_model.dart';
import 'package:grenngrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:grenngrocer/src/pages/product/product_screen.dart';
import 'package:grenngrocer/src/pages_routes/app_pages.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

class ItemTitle extends StatefulWidget {
  const ItemTitle({
    Key? key,
    required this.item,
    required this.cartAnimationMethod,
  }) : super(key: key);

  final ItemModel item;
  final void Function(GlobalKey) cartAnimationMethod;

  @override
  State<ItemTitle> createState() => _ItemTitleState();
}

class _ItemTitleState extends State<ItemTitle> {
  final GlobalKey imageGK = GlobalKey();

  UtilsServices utilsServices = UtilsServices();

  final cartController = Get.find<CartController>();

  IconData titleIcon = Icons.add_shopping_cart_outlined;

  Future<void> switchIcon() async {
    setState(() => titleIcon = Icons.check);

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() => Icons.add_shopping_cart_outlined);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(PageRoutes.productRoute , arguments: widget.item);
          },
          child: Card(
            elevation: 1,
            shadowColor: Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //*Imagem
                  Expanded(
                    child: Hero(
                      tag: widget.item.imgUrl,
                      child: Image.network(
                        widget.item.imgUrl,
                        key: imageGK,
                      ),
                    ),
                  ),
                  //*Nome
                  Text(
                    widget.item.itemName,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  //*Preço - Unidade
                  Row(
                    children: [
                      Text(
                        utilsServices.priceToCurremcy(widget.item.price),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                      Text(
                        '/${widget.item.unit}',
                        style: TextStyle(
                          color: Colors.green.shade500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        //* botao de adicionar ao carrinho
        Positioned(
          top: 4,
          right: 4,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topRight: Radius.circular(20),
            ),
            child: Material(
              child: InkWell(
                onTap: () {
                  switchIcon();
                  cartController.addItemToCart(item: widget.item);
                  widget.cartAnimationMethod(imageGK);
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: CustomColors.customSwatchColor,
                  ),
                  height: 40,
                  width: 35,
                  child: Icon(
                    titleIcon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
