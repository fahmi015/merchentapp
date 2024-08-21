import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              future: Services().getAllTransactions(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                if (snapshot.hasData) {
                  final data = snapshot.data as Map<String, dynamic>;
                  final transactions = data['data'] as List<dynamic>;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: MediaQuery.of(context).size.height * 0.855,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      itemCount: transactions.length,
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
                                      '${transactions[index]['operation_id']}'),
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
                                      '${transactions[index]['amount']} ${transactions[index]['currency']}'),
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
                                  Text('طريقة الدفع'),
                                  Text(
                                      '${transactions[index]['payment_method']}'),
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
                                  Text('${transactions[index]['created_at']}'),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final Uri url = Uri.parse(
                                        'https://scripts.canzitech.com/merchant/facture.html?id=${transactions[index]['id']}&token=${token}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(
                                        url,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      print('Could not launch $url');
                                    }
                                  },
                                  child: Text("تفاصيل الفاتورة")),
                            ],
                          ),
                        );
                      },
                    ),
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
                        'No Data Available',
                        style: TextStyle(
                            color: Colors.grey.shade300, fontSize: 24),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
