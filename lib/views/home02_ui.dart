import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/services/money_api.dart';

class Home02UI extends StatefulWidget {
  final int userId;
  const Home02UI({super.key, required this.userId});

  @override
  State<Home02UI> createState() => _Home02UIState();
}

class _Home02UIState extends State<Home02UI> {
  late Future<List<Money>> moneyAllData;
  Future<List<Money>> getMoneyByUserId() async {
    return await MoneyApi().getMoneyByUserId(widget.userId);
  }

  void refreshData() {
    setState(() {
      moneyAllData = getMoneyByUserId(); // Trigger a refresh of the data
    });
  }

  @override
  void initState() {
    refreshData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "เงินเข้า/เงินออก",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: moneyAllData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    ); // แสดง loading
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: snapshot.data![index].moneyType == 1
                              ? Icon(
                                  CupertinoIcons.arrow_down,
                                  color: Colors.green,
                                  size: 36,
                                )
                              : Icon(
                                  CupertinoIcons.arrow_up,
                                  color: Colors.red,
                                  size: 36,
                                ),
                          title: Text(
                            '${snapshot.data![index].moneyDetail}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${snapshot.data![index].moneyDate}',
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: snapshot.data![index].moneyType == 1
                              ? Text(
                                  "+ ${snapshot.data![index].moneyInOut} บาท",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                  ),
                                )
                              : Text(
                                  "- ${snapshot.data![index].moneyInOut} บาท",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                ),
                        );
                      },
                    );
                  }
                  return Text('ไม่มีข้อมูล');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
