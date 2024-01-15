import 'package:flutter/material.dart';

import '../Services/Service.dart';
import '../pages/orders.dart';

class OrderCard extends StatefulWidget {
  int items, orderproducts, orderproductquantity, ordersubTotal, orderid;
  String orderRef, orderproductname, orderproductsprice;
  OrderCard({
    Key? key,
    required this.items,
    required this.orderRef,
    required this.orderid,
    required this.orderproductname,
    required this.orderproductquantity,
    required this.orderproducts,
    required this.orderproductsprice,
    required this.ordersubTotal,
  }) : super(key: key);

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: MediaQuery.of(context).size.height * 0.665,
      child: ListView.separated(
        itemCount: widget.items,
        separatorBuilder: (context, index) => SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                orderRef(Ref: widget.orderRef),
                Container(
                  height: MediaQuery.of(context).size.height *
                      0.03 *
                      // order.data[index].products.length,
                      widget.orderproducts,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          // order.data[index].products.length,
                          widget.orderproducts,
                      itemBuilder: (BuildContext context, int ind) {
                        return orderItems(
                          // itemName: order.data[index].products[ind].name,
                          itemName: widget.orderproductname,
                          // itemPrice: order.data[index].products[ind].price,
                          itemPrice: widget.orderproductsprice,
                          // itemquantity: order.data[index].products[ind].quantity,
                          itemquantity: widget.orderproductquantity,
                        );
                      }),
                ),
                total(subTotal: widget.ordersubTotal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // button(
                    //     putOrdersStatus:
                    //         Services().putOrdersStatus(widget.orderid, true),
                    //     isAccepted: true),
                    // button(
                    //     putOrdersStatus:
                    //         Services().putOrdersStatus(widget.orderid, false),
                    //
                    //

                    //those was enabled     isAccepted: false),

                    // button(
                    //   isAccepted: true,
                    //   onPressed: () {
                    //     Services().putOrdersStatus(widget.orderid, true);
                    //     setState(() {
                    //       Services().getOrdersIndex();
                    //     });
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    // button(
                    //     onPressed: () {
                    //       Services().putOrdersStatus(widget.orderid, false);
                    //       setState(() {
                    //         Services().getOrdersIndex();
                    //       });
                    //       Navigator.pop(context);
                    //     },
                    //     isAccepted: false),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
