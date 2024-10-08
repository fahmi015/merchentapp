import 'package:backofficeapp/shared/cached_helper.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .88,
                // child: FutureBuilder(
                //     future: Services().getMenu(),
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       if (snapshot.connectionState == ConnectionState.waiting) {
                //         return Center(child: CircularProgressIndicator());
                //       } else if (snapshot.hasData) {
                //         MenuData menu = snapshot.data;
                //         print(menu.data.toString());
                //         return ListView.separated(
                //             itemCount: menu.data.length,
                //             separatorBuilder: (context, index) => SizedBox(
                //                   height: 10,
                //                 ),
                //             itemBuilder: (context, index) {
                //               return Column(
                //                 children: [
                //                   if (menu.data[index].products.isNotEmpty)
                //                     foodCategory(
                //                         categoryName: menu.data[index].name,
                //                         categoryId: menu.data[index].id,
                //                         SwitchVal: menu.data[index].isActive != 1
                //                             ? SwitchVal = false
                //                             : SwitchVal = true),
                //                   Container(
                //                     margin:
                //                         const EdgeInsets.symmetric(horizontal: 16),
                //                     padding: const EdgeInsets.symmetric(
                //                         horizontal: 16, vertical: 8),
                //                     decoration: BoxDecoration(
                //                       color: Colors.white,
                //                       borderRadius: BorderRadius.circular(5),
                //                       border: Border.all(
                //                           color: Colors.grey.shade300, width: 1),
                //                     ),
                //                     height: MediaQuery.of(context).size.height *
                //                         0.08 *
                //                         menu.data[index].products.length,
                //                     child: ListView.separated(
                //                       physics: NeverScrollableScrollPhysics(),
                //                       itemCount: menu.data[index].products.length,
                //                       separatorBuilder: (context, ind) => SizedBox(
                //                         height: MediaQuery.of(context).size.height *
                //                             0.02,
                //                       ),
                //                       itemBuilder: (context, ind) {
                //                         return Column(
                //                           children: [
                //                             // Text('${menu.data[index].products[ind].id}, ${menu.data[index].products[ind].isActive}'),
                //                             FoodItem(
                //                                 idMenuItem: menu
                //                                     .data[index].products[ind].id,
                //                                 isActive: menu.data[index]
                //                                     .products[ind].isActive,
                //                                 ImgPic: menu.data[index]
                //                                     .products[ind].image,
                //                                 FoodName: menu.data[index]
                //                                     .products[ind].name),
                //                           ],
                //                         );
                //                       },
                //                     ),
                //                   ),
                //                 ],
                //               );
                //             });
                //       }
                //       return Center(
                //         child: Column(
                //           children: [
                //             Icon(
                //               LucideIcons.archive,
                //               color: Colors.grey.shade300,
                //               size: 64,
                //             ),
                //             Text(
                //               'No Data',
                //               style: TextStyle(
                //                   color: Colors.grey.shade300, fontSize: 24),
                //             ),
                //           ],
                //         ),
                //       );
                //     }),

                child: FutureBuilder(
                  future: Services().getMenu(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('An error occurred: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data != null) {
                      final data = snapshot.data as Map<String, dynamic>;
                      final menu = data['data'] as List<dynamic>;

                      return ListView.separated(
                        itemCount: menu.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final category = menu[index];

                          bool switchVal = category['is_active'] == 1;

                          return Center(
                            child: Column(
                              children: [
                                if (category['products'].isNotEmpty)
                                  foodCategory(
                                    categoryName: category['name'],
                                    categoryId: category['id'],
                                    SwitchVal: switchVal,
                                  ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: Colors.grey.shade300, width: 1),
                                  ),
                                  height: MediaQuery.of(context).size.height *
                                      0.09 *
                                      category['products'].length,
                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: category['products'].length,
                                    separatorBuilder: (context, ind) =>
                                        SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                    itemBuilder: (context, ind) {
                                      final product = category['products'][ind];

                                      return FoodItem(
                                        idMenuItem: product['id'],
                                        isActive: product['is_active'],
                                        ImgPic: product['image'],
                                        FoodName: product['name'],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  },
                ),
              ),
            ],
          ),
        ),
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
              Services().UpdateProductStatus(widget.idMenuItem,
                  data: widget.isActive);
            });
            // Services().putProductStatus(widget.idMenuItem, widget.access_token,data: {"is_active": '${widget.isActive}'});
          },
        ),
      ],
    );
  }
}
