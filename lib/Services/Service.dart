import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/MenuItems.dart';
import '../Models/OrderData.dart';
import '../Models/TransactionData.dart';
import '../shared/cached_helper.dart';

class Services {
  String token = Cachehelper.getData(key: "token");
  //GET APIs
  //get all Orders
  Future getAllOrders() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri = Uri.parse('https://api.canariapp.com/v1/partner/merchant/orders');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      return orderDataFromJson(response.body);
    }
  }

  //get Orders index
  Future getOrdersIndex() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var client = http.Client();
    var uri =
        Uri.parse('https://api.canariapp.com/v1/partner/merchant/orders/oms');
    final response = await client.get(uri, headers: headers);
    //{status: "confirmation on process"}
    if (response.statusCode == 200) {
      return orderDataFromJson(response.body);
    }
  }

  Future getOrdersPrepared() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var client = http.Client();
    var uri =
        Uri.parse('https://api.canariapp.com/v1/partner/merchant/orders/oms');
    final response = await client.get(uri, headers: headers);
    //{status: "confirmation on process"}
    if (response.statusCode == 200) {
      return orderDataFromJson(response.body);
    }
  }

  Future getOrdersAccepted() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var client = http.Client();
    var uri =
        Uri.parse('https://api.canariapp.com/v1/partner/merchant/orders/oms');
    final response = await client.get(uri, headers: headers);
    //{status: "confirmation on process"}
    if (response.statusCode == 200) {
      return orderDataFromJson(response.body);
    }
  }

  //get Trnsactions
  Future getAllTransactions() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri =
        Uri.parse('https://api.canariapp.com/v1/partner/merchant/transactions');
    final response = await client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return transactionDataFromJson(response.body);
    }
  }

  //get Menu
  Future getMenu() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri = Uri.parse(
        'https://api.canariapp.com/v1/partner/merchant/menus?include=products');
    final response = await client.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = response.body;

      return menuDataFromJson(data);
    }
  }

  // PUT APIs
  //Update Orders Status
  Future putOrdersStatus(
      int orderId, bool isAccpeted, String preparationTime) async {
    final headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri = Uri.parse(
        'https://api.canariapp.com/v1/partner/merchant/orders/$orderId/status');

    final response = await client.put(
      uri,
      headers: headers,
      body: isAccpeted
          ? {
              "status": "accepted",
              "preparation_time": preparationTime,
            }
          : {"status": "non-accepted"},
    );
    // return print('${response.statusCode} ------ ${response.body}');
    return print('${response.statusCode} ------');
  }

  //Update menus status
  Future putMenusStatus(int id, {data}) async {
    final headers = {
      // 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri = Uri.parse(
      'https://api.canariapp.com/v1/partner/merchant/menus/update-status/$id',
    );

    final response = await client.put(uri, headers: headers, body: data);
    return print('${response.statusCode}');
  }

  //Update menus status
  // Future putProductStatus(int id, , {data}) async {
  //   final headers = {
  //     // 'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${token}',
  //   };
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       'https://api.canariapp.com/v1/partner/merchant/products/{$id}/status');

  //   final response = await client.put(uri, headers: headers, body: data);
  //   return print('${response.statusCode}');
  // }
  // Future UpdateProductStatus(id, token, {data}) async {
  //   print(data);
  //   final response = await http.put(
  //       Uri.parse(
  //           'https://api.canariapp.com/v1/partner/merchant/products/{$id}/status'),
  //       headers: {
  //         'Authorization': 'Bearer ${token}',
  //         'Accept': 'application/json',
  //       },
  //       body: {
  //         "is_active": "${data}",
  //       }).then((value) {
  //     var data = json.decode(value.body);
  //     print(data);
  //   }).onError((error, stackTrace) {
  //     print(error);
  //   });
  //   return response;
  // }
  Future<dynamic> UpdateProductStatus(id, {data}) async {
    final response = await http.put(
        Uri.parse(
            'https://api.canariapp.com/v1/partner/merchant/products/update-status/$id'),
        headers: {
          'Authorization': 'Bearer ${token}',
          'Accept': 'application/json',
        },
        body: {
          'is_active': data.toString(),
        }).then((value) {
      // var data = json.decode(value.body);
      // print(data);
      print('${value.statusCode}');
    }).onError((error, stackTrace) {
      print(error);
    });
    return response;
  }
}
