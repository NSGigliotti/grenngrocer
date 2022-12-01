import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grenngrocer/src/pages/orders/components/order_title.dart';
import 'package:grenngrocer/src/pages/orders/controller/all_orders_conroller.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      body: GetBuilder<AllOrdersController>(
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getAllOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, index) => const SizedBox(height: 10),
              itemCount: controller.allOrders.length,
              itemBuilder: (_, index) {
                return OrderTitle(
                  order: controller.allOrders[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
