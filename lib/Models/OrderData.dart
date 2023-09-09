import 'dart:convert';

OrderData orderDataFromJson(String str) => OrderData.fromJson(json.decode(str));

String orderDataToJson(OrderData data) => json.encode(data.toJson());

class OrderData {
  List<Datum> data;

  OrderData({
    required this.data,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String orderRef;
  int storeId;
  dynamic driverId;
  int clientId;
  String status;
  dynamic deliveryStatus;
  dynamic fulfillmentStatus;
  dynamic preparationTime;
  dynamic pickupTime;
  dynamic deliveryTime;
  DateTime prospectiveFulfillmentTime;
  DateTime prospectivePickupTime;
  DateTime prospectiveDeliveryTime;
  Note note;
  DeliveryAddress deliveryAddress;
  String type;
  int subTotal;
  int total;
  String orderFee;
  double commission;
  double netPayout;
  String createdAt;
  DateTime confirmedAt;
  dynamic driver;
  Client client;
  List<DatumProduct> products;

  Datum({
    required this.id,
    required this.orderRef,
    required this.storeId,
    required this.driverId,
    required this.clientId,
    required this.status,
    required this.deliveryStatus,
    required this.fulfillmentStatus,
    required this.preparationTime,
    required this.pickupTime,
    required this.deliveryTime,
    required this.prospectiveFulfillmentTime,
    required this.prospectivePickupTime,
    required this.prospectiveDeliveryTime,
    required this.note,
    required this.deliveryAddress,
    required this.type,
    required this.subTotal,
    required this.total,
    required this.orderFee,
    required this.commission,
    required this.netPayout,
    required this.createdAt,
    required this.confirmedAt,
    required this.driver,
    required this.client,
    required this.products,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        orderRef: json["order_ref"],
        storeId: json["store_id"],
        driverId: json["driver_id"],
        clientId: json["client_id"],
        status: json["status"],
        deliveryStatus: json["delivery_status"],
        fulfillmentStatus: json["fulfillment_status"],
        preparationTime: json["preparation_time"],
        pickupTime: json["pickup_time"],
        deliveryTime: json["delivery_time"],
        prospectiveFulfillmentTime:
            DateTime.parse(json["prospective_fulfillment_time"]),
        prospectivePickupTime: DateTime.parse(json["prospective_pickup_time"]),
        prospectiveDeliveryTime:
            DateTime.parse(json["prospective_delivery_time"]),
        note: Note.fromJson(json["note"]),
        deliveryAddress: DeliveryAddress.fromJson(json["delivery_address"]),
        type: json["type"],
        subTotal: json["sub_total"],
        total: json["total"],
        orderFee: json["order_fee"],
        commission: json["commission"]?.toDouble(),
        netPayout: json["net_payout"]?.toDouble(),
        createdAt: json["created_at"],
        confirmedAt: DateTime.parse(json["confirmed_at"]),
        driver: json["driver"],
        client: Client.fromJson(json["client"]),
        products: List<DatumProduct>.from(
            json["products"].map((x) => DatumProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_ref": orderRef,
        "store_id": storeId,
        "driver_id": driverId,
        "client_id": clientId,
        "status": status,
        "delivery_status": deliveryStatus,
        "fulfillment_status": fulfillmentStatus,
        "preparation_time": preparationTime,
        "pickup_time": pickupTime,
        "delivery_time": deliveryTime,
        "prospective_fulfillment_time":
            prospectiveFulfillmentTime.toIso8601String(),
        "prospective_pickup_time": prospectivePickupTime.toIso8601String(),
        "prospective_delivery_time": prospectiveDeliveryTime.toIso8601String(),
        "note": note.toJson(),
        "delivery_address": deliveryAddress.toJson(),
        "type": type,
        "sub_total": subTotal,
        "total": total,
        "order_fee": orderFee,
        "commission": commission,
        "net_payout": netPayout,
        "created_at": createdAt,
        "confirmed_at": confirmedAt.toIso8601String(),
        "driver": driver,
        "client": client.toJson(),
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Client {
  String name;
  String phone;

  Client({
    required this.name,
    required this.phone,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        name: json["name"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
      };
}

class DeliveryAddress {
  String label;
  double latitude;
  double longitude;

  DeliveryAddress({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        label: json["label"] ?? "",
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Note {
  dynamic allergyInfo;
  dynamic specialRequirements;

  Note({
    required this.allergyInfo,
    required this.specialRequirements,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        allergyInfo: json["allergy_info"],
        specialRequirements: json["special_requirements"],
      );

  Map<String, dynamic> toJson() => {
        "allergy_info": allergyInfo,
        "special_requirements": specialRequirements,
      };
}

class DatumProduct {
  int id;
  int purchaseId;
  String name;
  int quantity;
  String price;
  String originalPrice;
  Pivot pivot;
  List<Attribute> attributes;

  DatumProduct({
    required this.id,
    required this.purchaseId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    required this.pivot,
    required this.attributes,
  });

  factory DatumProduct.fromJson(Map<String, dynamic> json) => DatumProduct(
        id: json["id"],
        purchaseId: json["purchase_id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        originalPrice: json["original_price"],
        pivot: Pivot.fromJson(json["pivot"]),
        attributes: List<Attribute>.from(
            json["attributes"].map((x) => Attribute.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "purchase_id": purchaseId,
        "name": name,
        "quantity": quantity,
        "price": price,
        "original_price": originalPrice,
        "pivot": pivot.toJson(),
        "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
      };
}

class Attribute {
  int id;
  String name;
  int quantity;
  String price;

  Attribute({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "quantity": quantity,
        "price": price,
      };
}

class Pivot {
  int orderId;
  int productId;
  int id;
  int quantity;
  String price;
  String originalPrice;
  dynamic parentId;
  List<PivotProduct> products;

  Pivot({
    required this.orderId,
    required this.productId,
    required this.id,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    required this.parentId,
    required this.products,
  });

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        orderId: json["order_id"],
        productId: json["product_id"],
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"],
        originalPrice: json["original_price"],
        parentId: json["parent_id"],
        products: List<PivotProduct>.from(
            json["products"].map((x) => PivotProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "product_id": productId,
        "id": id,
        "quantity": quantity,
        "price": price,
        "original_price": originalPrice,
        "parent_id": parentId,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class PivotProduct {
  int id;
  int orderId;
  int productId;
  dynamic offerId;
  int parentId;
  int quantity;
  String price;
  String originalPrice;
  dynamic offer;
  DateTime createdAt;
  DateTime updatedAt;
  ProductProduct product;

  PivotProduct({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.offerId,
    required this.parentId,
    required this.quantity,
    required this.price,
    required this.originalPrice,
    required this.offer,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory PivotProduct.fromJson(Map<String, dynamic> json) => PivotProduct(
        id: json["id"],
        orderId: json["order_id"],
        productId: json["product_id"],
        offerId: json["offer_id"],
        parentId: json["parent_id"],
        quantity: json["quantity"],
        price: json["price"],
        originalPrice: json["original_price"],
        offer: json["offer"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductProduct.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "product_id": productId,
        "offer_id": offerId,
        "parent_id": parentId,
        "quantity": quantity,
        "price": price,
        "original_price": originalPrice,
        "offer": offer,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product": product.toJson(),
      };
}

class ProductProduct {
  int id;
  int storeId;
  String name;
  dynamic description;
  bool isActive;
  String price;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  int subTotal;

  ProductProduct({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.isActive,
    required this.price,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.subTotal,
  });

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        id: json["id"],
        storeId: json["store_id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        price: json["price"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        subTotal: json["sub_total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "name": name,
        "description": description,
        "is_active": isActive,
        "price": price,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sub_total": subTotal,
      };
}
