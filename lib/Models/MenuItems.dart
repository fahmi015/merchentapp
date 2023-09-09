import 'dart:convert';

MenuData menuDataFromJson(String str) => MenuData.fromJson(json.decode(str));

String menuDataToJson(MenuData data) => json.encode(data.toJson());

class MenuData {
  List<Datum> data;
  Links links;
  Meta meta;

  MenuData({
    required this.data,
    required this.links,
    required this.meta,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) => MenuData(
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
  int storeId;
  String name;
  dynamic description;
  int isActive;
  int sort;
  List<Product> products;

  Datum({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.isActive,
    required this.sort,
    required this.products,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        storeId: json["store_id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        sort: json["sort"],
        products: List<Product>.from(
            json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "name": name,
        "description": description,
        "is_active": isActive,
        "sort": sort,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  int id;
  int sort;
  int storeId;
  String name;
  dynamic description;
  String image;
  List<dynamic> images;
  bool isActive;
  String price;
  Type type;
  dynamic qtyMax;

  Product({
    required this.id,
    required this.sort,
    required this.storeId,
    required this.name,
    required this.description,
    required this.image,
    required this.images,
    required this.isActive,
    required this.price,
    required this.type,
    required this.qtyMax,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        sort: json["sort"],
        storeId: json["store_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        isActive: json["is_active"],
        price: json["price"],
        type: typeValues.map[json["type"]]!,
        qtyMax: json["qty_max"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sort": sort,
        "store_id": storeId,
        "name": name,
        "description": description,
        "image": image,
        "images": List<dynamic>.from(images.map((x) => x)),
        "is_active": isActive,
        "price": price,
        "type": typeValues.reverse[type],
        "qty_max": qtyMax,
      };
}

enum Type { PRODUCT }

final typeValues = EnumValues({"product": Type.PRODUCT});

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
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
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
  dynamic label;
  bool? active;
  bool? linkActive;

  Link({
    required this.url,
    required this.label,
    this.active,
    this.linkActive,
  });

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
        linkActive: json["active "],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
        "active ": linkActive,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
