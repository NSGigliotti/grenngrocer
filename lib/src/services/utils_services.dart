import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class UtilsServices {
  final sotage = const FlutterSecureStorage();

  //* Salvar dado localmente em seguraça
  Future<void> saveLocalData(
      {required String key, required String data}) async {
    await sotage.write(key: key, value: data);
  }

  //* Recuperar dado salvo locamente em segurança
  Future<String?> getlocalData({required String key}) async {
    return await sotage.read(key: key);
  }

  //* Remove dadp salvo localmente
  Future<void> removeLocalData({required String key}) async {
    await sotage.delete(key: key);
  }

  String priceToCurremcy(double price) {
    NumberFormat numberFormat = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return numberFormat.format(price);
  }

  String formatDateTime(DateTime dateTime) {
    initializeDateFormatting();

    DateFormat dateFormat = DateFormat.yMd('pt_Br').add_Hm();
    return dateFormat.format(dateTime);
  }

  Uint8List decodeQrCodeImage(String value) {
    String base64String = value.split(',').last;
    return base64.decode(base64String);
  }

  void showToast({required message, bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: isError ? Colors.red : Colors.white,
      textColor: isError ? Colors.white : Colors.black,
      fontSize: 14.0,
    );
  }
}
