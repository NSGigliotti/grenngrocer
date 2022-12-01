import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grenngrocer/src/models/cart_item_model.dart';
import 'package:grenngrocer/src/models/order_model.dart';
import 'package:grenngrocer/src/pages/orders/components/order_status_widget.dart';
import 'package:grenngrocer/src/pages/orders/controller/order_controller.dart';
import 'package:grenngrocer/src/pages/widget/payment_dialog.dart';
import 'package:grenngrocer/src/services/utils_services.dart';

class OrderTitle extends StatelessWidget {
  final OrderModel order;
  OrderTitle({Key? key, required this.order}) : super(key: key);

  final UtilsServices util = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: GetBuilder<OrderController>(
            init: OrderController(order),
            global: false,
            builder: (controller) {
              return ExpansionTile(
                onExpansionChanged: (value) {
                  if (value && order.items.isEmpty) {
                    controller.getOdersItems();
                  }
                },
                expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                //initiallyExpanded: order.status == 'pending_payment',
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.isLoading
                      ? [
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        ]
                      : [
                          Text('Pedido ${order.id}'),
                          Text(
                            util.formatDateTime(order.createdDateTime!),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                ),
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        //* Lista de produtos
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 150,
                            child: ListView(
                              children: order.items.map((ordemItem) {
                                return _OrderItemWifget(
                                  util: util,
                                  ordemItem: ordemItem,
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        //* Diviçao
                        VerticalDivider(
                          color: Colors.grey.shade300,
                          thickness: 2,
                          width: 8,
                        ),

                        //* Status do produto
                        Expanded(
                          flex: 2,
                          child: OrderStatusWidget(
                            status: order.status,
                            isOVerdue:
                                order.overdueDateTime.isBefore(DateTime.now()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //* Total
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Total ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: util.priceToCurremcy(order.total),
                        )
                      ],
                    ),
                  ),

                  //* Botao Pagamento
                  Visibility(
                    visible:
                        order.status == 'pending_payment' && !order.isOverDue,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/images/pix.png',
                        height: 18,
                      ),
                      label: const Text('Ver QR code Pix'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return PaymentDialog(
                              order: order,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}

class _OrderItemWifget extends StatelessWidget {
  const _OrderItemWifget({
    Key? key,
    required this.util,
    required this.ordemItem,
  }) : super(key: key);

  final UtilsServices util;
  final CartItemModel ordemItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${ordemItem.quantity} ${ordemItem.item.unit} ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(child: Text(ordemItem.item.itemName)),
          Text(util.priceToCurremcy(ordemItem.totalPrice()))
        ],
      ),
    );
  }
}
