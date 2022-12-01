import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:grenngrocer/src/config/custom_colors.dart';
import 'package:grenngrocer/src/pages/base/controller/navigation_controller.dart';
import 'package:grenngrocer/src/pages/cart/controller/cart_controller.dart';
import 'package:grenngrocer/src/pages/home/controller/home_controller.dart';
import 'package:grenngrocer/src/pages/home/view/components/category_title.dart';
import 'package:grenngrocer/src/pages/widget/app_name_widget.dart';
import 'package:grenngrocer/src/pages/widget/custom_shimmer.dart';
import 'package:grenngrocer/src/services/utils_services.dart';
import 'package:get/get.dart';

import 'components/item_title.dart';

class HomeTab extends StatefulWidget {
  HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  GlobalKey<CartIconKey> globalKeyCartItems = GlobalKey<CartIconKey>();

  final searchController = TextEditingController();

  late Function(GlobalKey) runAddToCardAnimation;

  final UtilsServices util = UtilsServices();

  final navigatorController = Get.find<NavigationController>();

  void itemSelectedCartAnimation(GlobalKey gkImagem) {
    return runAddToCardAnimation(gkImagem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //*app Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppNameWidget(),
        actions: [
          Padding(
              padding: const EdgeInsets.only(top: 15, right: 15),
              child: GetBuilder<CartController>(
                builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      navigatorController.navigatePageVie(NavigationTabs.cart);
                    },
                    child: Badge(
                      badgeColor: CustomColors.customConstrastColor,
                      badgeContent: Text(
                        controller.cartItems.length.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      child: AddToCartIcon(
                        key: globalKeyCartItems,
                        icon: Icon(
                          Icons.shopping_cart,
                          color: CustomColors.customSwatchColor,
                        ),
                      ),
                    ),
                  );
                },
              )),
        ],
      ),

      body: AddToCartAnimation(
        gkCart: globalKeyCartItems,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCartAnimationMehod) {
          runAddToCardAnimation = addToCartAnimationMehod;
        },
        child: Column(
          children: [
            //* Campo de pesquisa
            GetBuilder<HomeController>(
              builder: (controller) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {
                      controller.searchTitle.value = value;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true,
                      hintText: 'Pesquise Aki ...',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: CustomColors.customConstrastColor,
                        size: 21,
                      ),
                      suffixIcon: controller.searchTitle.value.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                controller.searchTitle.value = '';
                                FocusScope.of(context).unfocus();
                              },
                              icon: Icon(
                                Icons.close,
                                size: 21,
                                color: CustomColors.customConstrastColor,
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide:
                            const BorderSide(width: 0, style: BorderStyle.none),
                      ),
                    ),
                  ),
                );
              },
            ),
            //* Categorias
            GetBuilder<HomeController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.only(left: 25),
                  height: 40,
                  child: !controller.isCategoryLoading
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.allCategories.length,
                          separatorBuilder: (_, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, index) {
                            return CategoryTitle(
                              category: controller.allCategories[index].title,
                              isSelected: controller.allCategories[index] ==
                                  controller.currentCategory,
                              onPressed: () {
                                controller.selectedCategory(
                                    controller.allCategories[index]);
                              },
                            );
                          },
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            10,
                            (index) => Container(
                              margin: EdgeInsets.only(right: 12),
                              alignment: Alignment.center,
                              child: CustomShimmer(
                                height: 20,
                                width: 80,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
            //* Grid
            GetBuilder<HomeController>(
              builder: (controller) {
                return Expanded(
                  child: !controller.isProductLoading
                      ? Visibility(
                          visible: (controller.currentCategory?.items ?? [])
                              .isNotEmpty,
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 9 / 11.5,
                            ),
                            itemCount: controller.allProducts.length,
                            itemBuilder: (_, index) {
                              if (((index + 1) ==
                                      controller.allProducts.length) &&
                                  !controller.isLastPage) {
                                controller.loadMoreProducts();
                              }
                              return ItemTitle(
                                item: controller.allProducts[index],
                                cartAnimationMethod: itemSelectedCartAnimation,
                              );
                            },
                          ),
                          replacement: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: CustomColors.customSwatchColor,
                              ),
                              const Text('Nao ha itens para apresentar')
                            ],
                          ),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 9 / 11.5,
                          children: List.generate(
                            10,
                            (index) => CustomShimmer(
                              height: double.infinity,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
