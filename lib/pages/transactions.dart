import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../Models/TransactionData.dart';
import '../Services/Service.dart';
import '../shared/cached_helper.dart';

class Transaction extends StatefulWidget {
  const Transaction({Key? key}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

String token = Cachehelper.getData(key: "token");

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: Services().getAllTransactions(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  TransactionData transaction = snapshot.data;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: MediaQuery.of(context).size.height * 0.788,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      itemCount: transaction.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('رقم المعاملة'),
                                  Text(
                                      '${transaction.data[index].operationId}'),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('المجموع'),
                                  Text(
                                      '${transaction.data[index].amount} ${transaction.data[index].currency}'),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('التاريخ'),
                                  Text('${transaction.data[index].createdAt}'),
                                ],
                              ),
                            ],
                          ),
                        );
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
