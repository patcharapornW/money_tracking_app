import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/baseurl_constants.dart';
import 'package:money_tracking_app/models/money.dart';

class MoneyApi {
  final dio = Dio();

  Future<List<Money>> getMoneyByUserId(int userId) async {
    try {
      final responseData = await dio.get('$baseUrl/money/$userId');
      if (responseData.statusCode == 200) {
        return (responseData.data['info'] as List)
            .map((money) => Money.fromJson(money))
            .toList();
      } else {
        return <Money>[];
      }
    } catch (err) {
      debugPrint('ERRORS: ${err.toString()}');
      return <Money>[];
    }
  }

  Future<bool> inOutMoney(Money money) async {
    try {
      final Map<String, dynamic> requestBody = {
        'moneyDetail': money.moneyDetail,
        'moneyDate': money.moneyDate,
        'moneyInOut': money.moneyInOut,
        'moneyType': money.moneyType,
        'userId': money.userId,
      };

      final responseData = await dio.post(
        '$baseUrl/money/',
        data: requestBody,
        options: Options(headers: {'content-type': 'application/json'}),
      );

      if (responseData.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      debugPrint('ERROR: ${err.toString()}');
      return false;
    }
  }
}
