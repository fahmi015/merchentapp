import 'dart:convert';

TransactionData transactionDataFromJson(String str) =>
    TransactionData.fromJson(json.decode(str));

String transactionDataToJson(TransactionData data) =>
    json.encode(data.toJson());

class TransactionData {
  List<Datum> data;
  Links links;
  Meta meta;

  TransactionData({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
        "meta": meta.toJson(),
      };
}

class Datum {
  int id;
  String operationId;
  String amount;
  String fee;
  String total;
  String currency;
  String status;
  String paymentMethod;
  String createdAt;
  String flow;

  Datum({
    required this.id,
    required this.operationId,
    required this.amount,
    required this.fee,
    required this.total,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.flow,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        operationId: json["operation_id"],
        amount: json["amount"],
        fee: json["fee"],
        total: json["total"],
        currency: json["currency"],
        status: json["status"],
        paymentMethod: json["payment_method"],
        createdAt: json["created_at"],
        flow: json["flow"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "operation_id": operationId,
        "amount": amount,
        "fee": fee,
        "total": total,
        "currency": currency,
        "status": status,
        "payment_method": paymentMethod,
        "created_at": createdAt,
        "flow": flow,
      };
}

class Links {
  String first;
  String last;
  dynamic prev;
  dynamic next;

  Links({
    required this.first,
    required this.last,
    required this.prev,
    required this.next,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  List<Link> links;
  String path;
  int perPage;
  int to;
  int total;

  Meta({
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.links,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"] ?? 0,
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"] ?? 0,
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Link {
  String? url;
  String label;
  bool active;

  Link({
    required this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
