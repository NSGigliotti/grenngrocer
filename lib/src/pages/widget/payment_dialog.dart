import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:grenngrocer/src/models/order_model.dart';
import 'package:grenngrocer/src/services/utils_services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentDialog extends StatelessWidget {
  final OrderModel order;
  PaymentDialog({Key? key, required this.order}) : super(key: key);

  final UtilsServices util = UtilsServices();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          //*conteudo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //* Titulo
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Pagamento Com Pix',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),

                //* QR code

                Image.memory(
                  util.decodeQrCodeImage(order.qrCodeImage),
                  height: 200,
                  width: 200,
                ),

                //* Vencimento

                Text(
                  'Vencimento : ${util.formatDateTime(order.overdueDateTime)}  ',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),

                //*total

                Text(
                  'Total: ${util.priceToCurremcy(order.total)}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //* Botao copia e cola
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(
                        width: 2,
                        color: Colors.green,
                      )),
                  icon: const Icon(Icons.copy, size: 15),
                  label: const Text(
                    'Copiar codigo Pix',
                    style: TextStyle(fontSize: 13),
                  ),
                  onPressed: () {
                    FlutterClipboard.copy(order.copyAndPaste);
                    util.showToast(message: 'Codigo copiado');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ],
      ),
    );
  }
}
