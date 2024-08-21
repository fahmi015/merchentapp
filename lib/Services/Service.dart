import 'dart:convert';
import 'package:http/http.dart' as http;

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
    var uri = Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/orders'
        ' https://ws.canzitech.com/v1/partner/merchant/orders ');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // return orderDataFromJson(response.body);
      return json.decode(response.body);
    }
  }

  //get Orders index
  Future<Map<String, dynamic>> getOrdersIndex() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var client = http.Client();
    var uri = Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/orders/oms'
        'https://ws.canzitech.com/v1/partner/merchant/orders/oms');
    final response = await client.get(uri, headers: headers);
    //{status: "confirmation on process"}
    if (response.statusCode == 200) {
      print(response.body);

      // return orderDataFromJson(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getOrdersPrepared() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var client = http.Client();
    var uri = Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/orders/oms'
        'https://ws.canzitech.com/v1/partner/merchant/orders/oms');
    final response = await client.get(uri, headers: headers);
    //{status: "confirmation on process"}
    if (response.statusCode == 200) {
      // return orderDataFromJson(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getOrdersAccepted() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };

    var client = http.Client();
    var uri = Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/orders/oms'
        'https://ws.canzitech.com/v1/partner/merchant/orders/oms');
    final response = await client.get(uri, headers: headers);
    //{status: "confirmation on process"}
    if (response.statusCode == 200) {
      // return orderDataFromJson(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //get Trnsactions
  Future<Map<String, dynamic>> getAllTransactions() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri = Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/transactions'
        // 'https://ws.canzitech.com/v1/partner/merchant/transactions'
        'https://ws.canzitech.com/v1/partner/merchant/transactions?per_page=0');
    final response = await client.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // return transactionDataFromJson(response.body);
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //get Menu
  Future<Map<String, dynamic>> getMenu() async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token}',
    };
    var client = http.Client();
    var uri = Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/menus?include=products'
        // 'https://ws.canzitech.com/v1/partner/merchant/menus'
        'https://ws.canzitech.com/v1/partner/merchant/menus?include=products');
    final response = await client.get(
      uri,
      headers: headers,
    );
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  //Post api
  //Update Orders Status
  Future postOrdersStatus(
      int orderId, bool isAccepted, String preparationTime) async {
    // final headers = {
    //   // 'Content-Type': 'application/json',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ${token}',
    // };
    // var client = http.Client();
    // var uri = Uri.parse(

    //     // 'https://api.canariapp.com/v1/partner/merchant/orders/$orderId/status'
    //     // 'https://ws.canzitech.com/v1/partner/merchant/orders/$orderId/status'
    //     'https://ws.canzitech.com/v1/partner/merchant/orders/update-status');

    // final response = await client.post(
    //   uri,
    //   headers: headers,
    //   body: isAccpeted
    //       ? {
    //           "status": "accepted",
    //           "preparation_time": preparationTime,
    //         }
    //       : {"status": "non-accepted"},
    // );
    // // return print('${response.statusCode} ------ ${response.body}');
    // return print('${response.statusCode} ------');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var client = http.Client();
    var uri = Uri.parse(
        'https://ws.canzitech.com/v1/partner/merchant/orders/update-status');

    // Prepare the body
    final body = isAccepted
        ? {
            "status": "accepted",
            "preparation_time": preparationTime,
            "order_id": orderId.toString()
          }
        : {"status": "non-accepted", "order_id": orderId};

    try {
      final response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Order status updated successfully.');
      } else {
        print(
            'Failed to update order status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      client.close();
    }
  }

  Future postOrdersStatusDone(
    int orderId,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var client = http.Client();
    var uri = Uri.parse(
        'https://ws.canzitech.com/v1/partner/merchant/orders/update-status');
    final body = {"status": "ready", "order_id": orderId.toString()};
    try {
      final response = await client.post(
        uri,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Order status updated successfully.');
      } else {
        print(
            'Failed to update order status. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      client.close();
    }
  }

// PUT APIs
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
