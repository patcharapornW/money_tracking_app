import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_tracking_app/constants/baseurl_constants.dart';
import 'package:money_tracking_app/constants/color_constants.dart';
import 'package:money_tracking_app/models/money.dart';
import 'package:money_tracking_app/services/money_api.dart';
import 'package:money_tracking_app/views/home01_ui.dart';
import 'package:money_tracking_app/views/home02_ui.dart';
import 'package:money_tracking_app/views/home03_ui.dart';

class HomeUI extends StatefulWidget {
  final String? userName;
  final String? userImage;
  final int userId;

  const HomeUI(
      {super.key, this.userName, this.userImage, required this.userId});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  int _selectedIndex = 1;
  late Future<List<Money>> moneyAllData;
  List showUI = [];
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
    showUI = [
      Home01UI(userId: widget.userId, refreshData: refreshData),
      Home02UI(userId: widget.userId),
      Home03UI(userId: widget.userId, refreshData: refreshData),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double totalMoney = 0.0;
    double totalIncome = 0.0;
    double totalExpanse = 0.0;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              widget.userName.toString(),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          widget.userImage == null
              ? Image.asset(
                  'assets/images/user_camera.png',
                  width: 50,
                  height: 50,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    '$baseUrl/images/users/${widget.userImage}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
          SizedBox(width: 25),
        ],
        backgroundColor: Color(mainColor),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Color(mainColor)),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[350],
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_down, size: 45),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, size: 45),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_up, size: 45),
              label: '',
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            FutureBuilder(
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
                  // ตัวแปรนี้จะทำการคำนวณยอดเงินคงเหลือ
                  snapshot.data!.forEach((x) {
                    if (x.moneyType == 1) {
                      totalMoney += x.moneyInOut!;
                      totalIncome += x.moneyInOut!;
                    } else {
                      totalExpanse += x.moneyInOut!;
                      totalMoney -= x.moneyInOut!;
                    }
                  });
                  return Container(
                    width: double.infinity,
                    height: 200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 25,
                    ),
                    decoration: BoxDecoration(
                      color: Color(mainColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "ยอดเงินคงเหลือ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "$totalMoney บาท",
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.arrow_up,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "ยอดเงินเข้าร่วม",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "$totalIncome บาท",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "ยอดเงินออกร่วม",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      CupertinoIcons.arrow_up,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Text(
                                  "$totalExpanse บาท",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return Center(child: Text('ไม่มีข้อมูล'));
              },
              // childre:
            ),
            Expanded(child: showUI[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
