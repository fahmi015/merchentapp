import 'dart:convert';

import 'package:backofficeapp/components/ordercard.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../Services/Service.dart';
import '../shared/cached_helper.dart';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  Orders({
    Key? key,
  }) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

String? token = Cachehelper.getData(key: "token");

class _OrdersState extends State<Orders> {
  String? storeStatus;
  bool isLoading = false;
  int id = Cachehelper.getData(key: "id");
  bool switchValue = true;

  Future getStoreData() async {
    isLoading = false;
    final response = await http.get(
      Uri.parse(
          // 'https://api.canariapp.com/v1/partner/merchant/stores'
          'https://ws.canzitech.com/v1/partner/merchant/stores'),
      headers: {
        'Authorization': 'Bearer ${token}',
        'Accept': 'application/json',
      },
    ).then((value) {
      var stores = json.decode(value.body);
      isLoading = true;
      print(stores['data'][0]['working_status']);
      storeStatus = stores['data'][0]['working_status'];
      Cachehelper.sharedPreferences!
          .setString("storeStatus", stores['data'][0]['working_status']);
      setState(() {});
    }).onError((error, stackTrace) {
      print(error);
    });
    return response;
  }

  Future UpdateStatus({working_status}) async {
    print(working_status);
    final response = await http.put(Uri.parse(
        // 'https://api.canariapp.com/v1/partner/merchant/stores/${id}'
        'https://ws.canzitech.com/v1/partner/merchant/stores/${id}'), headers: {
      'Authorization': 'Bearer ${token}',
      'Accept': 'application/json',
    }, body: {
      'working_status': '${working_status}'
    }).then((value) {
      var data = json.decode(value.body);
      print(data);
    }).onError((error, stackTrace) {
      print(error);
    });
    return response;
  }

  //
  @override
  void initState() {
    getStoreData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'طلبات اليوم',
          ),
          backgroundColor: isLoading
              ? storeStatus == 'close'
                  ? Colors.red
                  : Colors.green
              : Colors.grey[300],
          elevation: 1,
          bottom: const TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text('انتظار', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child:
                    Text('تم الموافقة', style: TextStyle(color: Colors.white)),
              ),
              Tab(
                child: Text('جاهز', style: TextStyle(color: Colors.white)),
              ),
            ],
            labelColor: Colors.white,
          ),
          actions: [
            isLoading
                ? Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: CupertinoSwitch(
                      value: storeStatus == 'close' ? false : true,
                      onChanged: (bool value) {
                        setState(() {
                          switchValue = value ?? false;
                          storeStatus = switchValue ? 'open' : 'close';
                          Cachehelper.sharedPreferences!
                              .setString("storeStatus", storeStatus!)
                              .then((value) {
                            print('status saved');
                          });
                          UpdateStatus(working_status: storeStatus);
                        });
                      },
                    ),
                  )
                : SizedBox(height: 0),
          ],
        ),
        body: const TabBarView(
          children: [
            WaitingOrders(),
            AcceptedOrders(),
            PreparedOrders(),
          ],
        ),
      ),
    );
  }
}

class WaitingOrders extends StatefulWidget {
  const WaitingOrders({Key? key}) : super(key: key);

  @override
  State<WaitingOrders> createState() => _WaitingOrdersState();
}

class _WaitingOrdersState extends State<WaitingOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          FutureBuilder(
              future: Services().getOrdersIndex(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  );
                } else if (snapshot.hasData) {
                  // OrderData order = snapshot.data;
                  final data = snapshot.data as Map<String, dynamic>;
                  final order = data['data'] as List<dynamic>;
                  String preprationTime = '15';

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    height: MediaQuery.of(context).size.height * 0.735,
                    child: ListView.separated(
                      // itemCount: order.data.length,
                      itemCount: order.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      itemBuilder: (context, index) {
                        if (
                            // order.data[index].status =="confirmation on process"
                            order[index]['status'] == "confirmed") {
                          return Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: Colors.grey.shade400, width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey.shade300,
                                    offset: Offset(10, 10),
                                    spreadRadius: 1,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                orderRef(
                                  // Ref: order.data[index].orderRef,
                                  Ref: order[index]['order_ref'],
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.085 *
                                      order[index]['products'].length,
                                  // order.data[index].products.length,
                                  child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      // itemCount:order.data[index].products.length,
                                      itemCount:
                                          order[index]['products'].length,
                                      itemBuilder:
                                          (BuildContext context, int subindex) {
                                        return orderItems(
                                          // itemName: order.data[index].products[subindex].name,
                                          itemName: order[index]['products']
                                              [subindex]['name'],
                                          // itemPrice: order.data[index].products[subindex].price,
                                          itemPrice: order[index]['products']
                                              [subindex]['price'],
                                          // itemquantity: order.data[index].products[subindex].quantity,
                                          itemquantity: order[index]['products']
                                              [subindex]['quantity'],
                                          // note: order.data[index].note
                                          //         .allergyInfo ??
                                          //     "",
                                          note: "",
                                        );
                                      }),
                                ),
                                total(
                                  // subTotal: order.data[index].storeTotal
                                  subTotal: order[index]['store_total'],
                                ),
                                PreparationTimeList(
                                  onTimeSelected: (String? chosenTime) {
                                    // print('Chosen Time: $chosenTime and ${chosenTime?.substring(0, 2)}');
                                    preprationTime =
                                        "${chosenTime?.substring(0, 2)}";
                                  },
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    button(
                                      isAccepted: true,
                                      onPressed: () {
                                        Services().postOrdersStatus(
                                          // order.data[index].id,
                                          order[index]['id'],
                                          true,
                                          preprationTime,
                                        );
                                        setState(() {
                                          Services().getOrdersIndex();
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    button(
                                        onPressed: () {
                                          Services().postOrdersStatus(
                                            // order.data[index].id,
                                            order[index]['id'],
                                            false,
                                            preprationTime,
                                          );
                                          setState(() {
                                            Services().getOrdersIndex();
                                          });
                                          Navigator.pop(context);
                                        },
                                        isAccepted: false),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center();
                        }
                      },
                    ),
                  );
                  // return Text(order.data[0].orderRef.toString());
                }
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.archive,
                        color: Colors.grey.shade300,
                        size: 64,
                      ),
                      Text(
                        'No Data',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 24),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class AcceptedOrders extends StatefulWidget {
  const AcceptedOrders({Key? key}) : super(key: key);

  @override
  State<AcceptedOrders> createState() => _AcceptedOrdersState();
}

class _AcceptedOrdersState extends State<AcceptedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          FutureBuilder(
              future: Services().getOrdersAccepted(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  // OrderData order = snapshot.data;
                  final data = snapshot.data as Map<String, dynamic>;
                  final order = data['data'] as List<dynamic>;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: MediaQuery.of(context).size.height * 0.735,
                    child: ListView.separated(
                      itemCount: order.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      itemBuilder: (context, index) {
                        if (order[index]['status'] == "accepted" ||
                            order[index]['status'] == "on process") {
                          return Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  color: Colors.grey.shade300,
                                  offset: Offset(10, 10),
                                  spreadRadius: 1,
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                orderRef(Ref: order[index]['order_ref']),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.085 *
                                      order[index]['products'].length,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          order[index]['products'].length,
                                      itemBuilder:
                                          (BuildContext context, int ind) {
                                        return orderItems(
                                          itemName: order[index]['products']
                                              [ind]['name'],
                                          itemPrice: order[index]['products']
                                              [ind]['price'],
                                          itemquantity: order[index]['products']
                                              [ind]['quantity'],
                                          // note: order.data[index].note
                                          //         .allergyInfo ??
                                          //     '',
                                          note: "",
                                        );
                                      }),
                                ),
                                total(subTotal: order[index]['store_total']),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .02),
                                ElevatedButton(
                                  onPressed: () {
                                    Services().postOrdersStatusDone(
                                      order[index]['id'],
                                    );
                                    Navigator.pop(context);
                                  },
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    elevation: MaterialStatePropertyAll(0),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.blue.shade300),
                                    padding: MaterialStatePropertyAll(
                                      const EdgeInsets.symmetric(
                                          horizontal: 62, vertical: 12),
                                    ),
                                  ),
                                  child: Text(
                                    'تم',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center();
                        }
                      },
                    ),
                  );
                }
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        LucideIcons.archive,
                        color: Colors.grey.shade300,
                        size: 64,
                      ),
                      Text(
                        'No Data',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 24),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class PreparedOrders extends StatefulWidget {
  const PreparedOrders({Key? key}) : super(key: key);

  @override
  State<PreparedOrders> createState() => _PreparedOrdersState();
}

class _PreparedOrdersState extends State<PreparedOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .01,
          ),
          FutureBuilder(
              future: Services().getOrdersPrepared(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  // OrderData order = snapshot.data;
                  final data = snapshot.data as Map<String, dynamic>;
                  final order = data['data'] as List<dynamic>;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: MediaQuery.of(context).size.height * 0.735,
                    child: ListView.separated(
                      itemCount: order.length,
                      separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      itemBuilder: (context, index) {
                        if (order[index]['status'] == "ready") {
                          return Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.grey.shade300,
                                    offset: Offset(10, 10),
                                    spreadRadius: 1,
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                orderRef(Ref: order[index]['order_ref']),
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.04 *
                                      order[index]['products'].length,
                                  child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          order[index]['products'].length,
                                      itemBuilder:
                                          (BuildContext context, int ind) {
                                        return orderItems(
                                          itemName: order[index]['products']
                                              [ind]['name'],
                                          itemPrice: order[index]['products']
                                              [ind]['price'],
                                          itemquantity: order[index]['products']
                                              [ind]['quantity'],
                                          // note: order
                                          //     .data[index].note.allergyInfo,
                                          note: "",
                                        );
                                      }),
                                ),
                                total(subTotal: order[index]['store_total']),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    // button(
                                    //     putOrdersStatus: Services()
                                    //         .putOrdersStatus(
                                    //             order.data[index].id, true),
                                    //     isAccepted: true),
                                    // button(
                                    //     putOrdersStatus: Services()
                                    //         .putOrdersStatus(
                                    //             order.data[index].id, false),
                                    //     isAccepted: false),

                                    //those was enabled
                                    // button(
                                    //   isAccepted: true,
                                    //   onPressed: () {
                                    //     Services().putOrdersStatus(
                                    //       order.data[index].id,
                                    //       true,
                                    //     );
                                    //     setState(() {
                                    //       Services().getOrdersIndex();
                                    //     });
                                    //     Navigator.pop(context);
                                    //   },
                                    // ),
                                    // button(
                                    //   onPressed: () {
                                    //     Services().putOrdersStatus(
                                    //       order.data[index].id,
                                    //       false,
                                    //     );
                                    //     setState(() {
                                    //       Services().getOrdersIndex();
                                    //     });
                                    //     Navigator.pop(context);
                                    //   },
                                    //   isAccepted: false,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center();
                        }
                      },
                    ),
                  );
                }
                return Center(
                  child: Column(
                    children: [
                      // CircularProgressIndicator()
                      Icon(
                        LucideIcons.archive,
                        color: Colors.grey.shade300,
                        size: 64,
                      ),
                      Text(
                        'No Data',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 24),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class button extends StatelessWidget {
  // Future putOrdersStatus;
  void Function()? onPressed;
  bool isAccepted;
  button({
    Key? key,
    // required this.putOrdersStatus,
    required this.onPressed,
    required this.isAccepted,
  }) : super(key: key);

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
                    onPressed: onPressed,
                  ),
                ],
              );
            });
      },
      style: ButtonStyle(
        side: MaterialStateProperty.all(
          BorderSide(
            color: isAccepted ? Colors.white : Colors.red,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        elevation: MaterialStatePropertyAll(0),
        // backgroundColor:MaterialStatePropertyAll(isAccepted ? Colors.blue.shade300 : null),

        backgroundColor: MaterialStatePropertyAll(
            isAccepted ? Colors.blue.shade300 : Colors.grey.shade50),
        padding: MaterialStatePropertyAll(
          const EdgeInsets.symmetric(horizontal: 62, vertical: 12),
        ),
      ),
      child: Text(
        isAccepted ? 'قبول' : 'رفض',
        style: TextStyle(
            color: isAccepted ? Colors.white : Colors.red, fontSize: 16),
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
            Text('${subTotal} درهم'),
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
  String itemName, itemPrice, note;
  int itemquantity;
  orderItems({
    Key? key,
    required this.itemName,
    required this.itemPrice,
    required this.itemquantity,
    this.note = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              '${itemPrice} درهم',
            ),
          ],
        ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.005,
        // ),
        // note.isNotEmpty
        //     ? Text(
        //         'ملاحظه : ${note}',
        //         style: TextStyle(color: Colors.red.shade200),
        //       )
        //     : Text(''),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.01,
        // ),
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
              'رقم طلب',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.shade500, width: .5),
              ),
              child: Text('${Ref}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        // Divider(
        //   color: Colors.grey.shade300,
        //   thickness: 1,
        // ),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.005,
        // ),
      ],
    );
  }
}

// class PreparationTime extends StatefulWidget {
//   String time;
//   PreparationTime({
//     required this.time,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<PreparationTime> createState() => _PreparationTimeState();
// }

// class _PreparationTimeState extends State<PreparationTime> {
//   bool isTaped = false;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isTaped = !isTaped;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: isTaped ? Colors.red.shade100 : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(4),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//         child: Text(
//           widget.time,
//           style: TextStyle(color: isTaped ? Colors.red : Colors.grey),
//         ),
//       ),
//     );
//   }
// }

class PreparationTime extends StatefulWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  PreparationTime({
    required this.time,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<PreparationTime> createState() => _PreparationTimeState();
}

class _PreparationTimeState extends State<PreparationTime> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.red.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Text(
          widget.time,
          style: TextStyle(color: widget.isSelected ? Colors.red : Colors.grey),
        ),
      ),
    );
  }
}

class PreparationTimeList extends StatefulWidget {
  final void Function(String? chosenTime) onTimeSelected;
  PreparationTimeList({required this.onTimeSelected});
  @override
  _PreparationTimeListState createState() => _PreparationTimeListState();
}

class _PreparationTimeListState extends State<PreparationTimeList> {
  int? selectedIndex;
  String? chosenTime;
  List<String> time = [
    "15 دقيقة",
    "25 دقيقة",
    "35 دقيقة",
  ];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: MediaQuery.of(context).size.width * .02,
      spacing: MediaQuery.of(context).size.width * .01,
      children: List.generate(
        time.length,
        (index) => PreparationTime(
          time: '${time[index]}',
          // isSelected: index == selectedIndex,
          // onTap: () {
          //   setState(() {
          //     selectedIndex = index;
          //   });
          // },
          isSelected: time[index] == chosenTime,
          onTap: () {
            setState(() {
              chosenTime = time[index];
              widget.onTimeSelected(chosenTime);
            });
          },
        ),
      ),
    );
  }
}
