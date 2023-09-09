import 'dart:developer';

import 'package:backofficeapp/shared/cached_helper.dart';
import 'package:flutter/material.dart';

import '../Models/MenuItems.dart';
import '../Services/Service.dart';

class Menus extends StatefulWidget {
  const Menus({Key? key}) : super(key: key);

  @override
  State<Menus> createState() => _MenusState();
}

bool switchValue = true;
String token = Cachehelper.getData(key: "token");
bool SwitchVal = true;

class _MenusState extends State<Menus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.81,
            child: FutureBuilder(
                future: Services().getMenu(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    MenuData menu = snapshot.data;

                    return ListView.separated(
                        itemCount: menu.data.length,
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              foodCategory(
                                  categoryName: menu.data[index].name,
                                  categoryId: menu.data[index].id,
                                  SwitchVal: menu.data[index].isActive != 1
                                      ? SwitchVal = false
                                      : SwitchVal = true),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                ),
                                height: MediaQuery.of(context).size.height *
                                    0.08 *
                                    menu.data[index].products.length,
                                child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: menu.data[index].products.length,
                                  separatorBuilder: (context, ind) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  itemBuilder: (context, ind) {
                                    return Column(
                                      children: [
                                        // Text('${menu.data[index].products[ind].id}, ${menu.data[index].products[ind].isActive}'),
                                        FoodItem(
                                            idMenuItem: menu
                                                .data[index].products[ind].id,
                                            isActive: menu.data[index]
                                                .products[ind].isActive,
                                            ImgPic: menu.data[index]
                                                .products[ind].image,
                                            FoodName: menu.data[index]
                                                .products[ind].name),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        });
                  }
                  return Center(child: Text('No Data'));
                }),
          ),
        ],
      ),
    );
  }
}

class foodCategory extends StatefulWidget {
  String categoryName;
  int categoryId;
  bool SwitchVal;
  foodCategory(
      {Key? key,
      required this.categoryName,
      required this.categoryId,
      required this.SwitchVal})
      : super(key: key);

  @override
  State<foodCategory> createState() => _foodCategoryState();
}

class _foodCategoryState extends State<foodCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.categoryName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Switch(
            activeColor: Colors.green.shade400,
            value: widget.SwitchVal,
            onChanged: (bool value) {
              setState(() {
                widget.SwitchVal = value;
                Services().putMenusStatus(widget.categoryId,
                    data: {"is_active": widget.SwitchVal == false ? "0" : "1"});
              });
            },
          ),
        ],
      ),
    );
  }
}

class FoodItem extends StatefulWidget {
  String FoodName, ImgPic;
  int idMenuItem;
  bool isActive;
  FoodItem({
    Key? key,
    required this.FoodName,
    required this.ImgPic,
    required this.isActive,
    required this.idMenuItem,
  }) : super(key: key);

  @override
  State<FoodItem> createState() => _FoodItemState();
}

class _FoodItemState extends State<FoodItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: NetworkImage(widget.ImgPic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                widget.FoodName,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Switch(
          activeColor: Colors.blue.shade400,
          value: widget.isActive,
          onChanged: (bool value) {
            setState(() {
              widget.isActive = value;
              Services().UpdateProductStatus(widget.idMenuItem, token,
                  data: widget.isActive);
            });
            // Services().putProductStatus(widget.idMenuItem, widget.access_token,data: {"is_active": '${widget.isActive}'});
          },
        ),
      ],
    );
  }
}
