import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import '../Models/OrderData.dart';
import '../Services/Service.dart';
import '../shared/cached_helper.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

bool switchValue = true;
List<bool> isSelected = [true, false, false];
List<String> optionsList = [
  'انتظار',
  'تم الموافقة',
  'جاهز',
];
int _selectedButtonIndex = 0;
String? token = Cachehelper.getData(key: "token");

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    String token = Cachehelper.getData(key: "token");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'طلبات اليوم',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Ink(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.count(
                primary: true,
                crossAxisCount: 3,
                childAspectRatio: 3,
                children: List.generate(isSelected.length, (index) {
                  return InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        setState(() {
                          _selectedButtonIndex = index;
                          for (int indexBtn = 0;
                              indexBtn < isSelected.length;
                              indexBtn++) {
                            if (indexBtn == index) {
                              isSelected[indexBtn] = true;
                            } else {
                              isSelected[indexBtn] = false;
                            }
                          }
                        });
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          color: isSelected[index]
                              ? Colors.red.shade400
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            optionsList[index],
                            style: TextStyle(
                                fontSize: 14,
                                color: isSelected[index]
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ),
                      ));
                }),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _selectedButtonIndex == 0
              ? FutureBuilder(
                  future: Services().getOrdersIndex(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      OrderData order = snapshot.data;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height: MediaQuery.of(context).size.height * 0.675,
                        child: ListView.separated(
                          itemCount: order.data.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.shade400, width: 1.5),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  orderRef(Ref: order.data[index].orderRef),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.03 *
                                        order.data[index].products.length,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            order.data[index].products.length,
                                        itemBuilder:
                                            (BuildContext context, int ind) {
                                          return orderItems(
                                              itemName: order.data[index]
                                                  .products[ind].name,
                                              itemPrice: order.data[index]
                                                  .products[ind].price,
                                              itemquantity: order.data[index]
                                                  .products[ind].quantity);
                                        }),
                                  ),
                                  total(subTotal: order.data[index].subTotal),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      button(
                                          putOrdersStatus: Services()
                                              .putOrdersStatus(
                                                  order.data[index].id, true),
                                          isAccepted: true),
                                      button(
                                          putOrdersStatus: Services()
                                              .putOrdersStatus(
                                                  order.data[index].id, false),
                                          isAccepted: false),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return Text('No Data');
                  })
              : _selectedButtonIndex == 1
                  ? FutureBuilder(
                      future: Services().getAllOrders(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          OrderData order = snapshot.data;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: MediaQuery.of(context).size.height * 0.675,
                            child: ListView.separated(
                              itemCount: order.data.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1.5),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      orderRef(Ref: order.data[index].orderRef),
                                      Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.03 *
                                            order.data[index].products.length,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: order
                                                .data[index].products.length,
                                            itemBuilder: (BuildContext context,
                                                int ind) {
                                              return orderItems(
                                                  itemName: order.data[index]
                                                      .products[ind].name,
                                                  itemPrice: order.data[index]
                                                      .products[ind].price,
                                                  itemquantity: order
                                                      .data[index]
                                                      .products[ind]
                                                      .quantity);
                                            }),
                                      ),
                                      total(
                                          subTotal: order.data[index].subTotal),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          button(
                                              putOrdersStatus: Services()
                                                  .putOrdersStatus(
                                                      order.data[index].id,
                                                      true),
                                              isAccepted: true),
                                          button(
                                              putOrdersStatus: Services()
                                                  .putOrdersStatus(
                                                      order.data[index].id,
                                                      false),
                                              isAccepted: false),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Text('No Data');
                      })
                  : FutureBuilder(
                      future: Services().getOrdersIndex(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          OrderData order = snapshot.data;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: MediaQuery.of(context).size.height * 0.675,
                            child: ListView.separated(
                              itemCount: order.data.length,
                              separatorBuilder: (context, index) => SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1.5),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      orderRef(Ref: order.data[index].orderRef),
                                      Container(
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.03 *
                                            order.data[index].products.length,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: order
                                                .data[index].products.length,
                                            itemBuilder: (BuildContext context,
                                                int ind) {
                                              return orderItems(
                                                  itemName: order.data[index]
                                                      .products[ind].name,
                                                  itemPrice: order.data[index]
                                                      .products[ind].price,
                                                  itemquantity: order
                                                      .data[index]
                                                      .products[ind]
                                                      .quantity);
                                            }),
                                      ),
                                      total(
                                          subTotal: order.data[index].subTotal),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          button(
                                              putOrdersStatus: Services()
                                                  .putOrdersStatus(
                                                      order.data[index].id,
                                                      true),
                                              isAccepted: true),
                                          button(
                                              putOrdersStatus: Services()
                                                  .putOrdersStatus(
                                                      order.data[index].id,
                                                      false),
                                              isAccepted: false),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Text('No Data');
                      }),
        ],
      )),
    );
  }
}

class button extends StatelessWidget {
  Future putOrdersStatus;
  bool isAccepted;
  button({Key? key, required this.putOrdersStatus, required this.isAccepted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(isAccepted ? 'تأكيد' : 'رفض')),
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(isAccepted
                      ? 'هل أنت متأكد من رغبتك في قبول هذا الطلب؟'
                      : ' هل أنت متأكد من رغبتك في هذا رفض الطلب؟ '),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Directionality(
                        textDirection: TextDirection.rtl, child: Text('إلغاء')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStatePropertyAll(
                          isAccepted ? Colors.blue.shade300 : null),
                    ),
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          isAccepted ? 'قبول' : 'نعم',
                        )),
                    onPressed: () {
                      putOrdersStatus;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(0),
        backgroundColor:
            MaterialStatePropertyAll(isAccepted ? Colors.blue.shade300 : null),
        padding: MaterialStatePropertyAll(
          const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        ),
      ),
      child: Text(
        isAccepted ? 'قبول' : 'رفض',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class total extends StatelessWidget {
  int subTotal;
  total({Key? key, required this.subTotal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        DottedLine(
          alignment: WrapAlignment.center,
          dashColor: Colors.grey.shade400,
          direction: Axis.horizontal,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('مجموع'),
            Text('${subTotal} DH'),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ],
    );
  }
}

class orderItems extends StatelessWidget {
  String itemName, itemPrice;
  int itemquantity;
  orderItems(
      {Key? key,
      required this.itemName,
      required this.itemPrice,
      required this.itemquantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  '${itemName}',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Text(
                  'x${itemquantity}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Text(
              '${itemPrice} dh',
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
      ],
    );
  }
}

class orderRef extends StatelessWidget {
  String Ref;
  orderRef({Key? key, required this.Ref}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'طلب',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text('${Ref}',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.005,
        ),
      ],
    );
  }
}
