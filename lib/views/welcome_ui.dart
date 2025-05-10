import 'package:flutter/material.dart';
import 'package:money_tracking_app/views/login_ui.dart';
import 'package:money_tracking_app/views/register_ui.dart';
import 'package:money_tracking_app/widgets/custom_button.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/man.png', width: 400),
                  SizedBox(height: 20),
                  Text(
                    'บันทึก\nรายรับรายจ่าย',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      CustomButton(
                        text: "เริ่มใช้งานแอปพลิเคชัน",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginUI(),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ยังไม่ได้ลงทะเบียน? '),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterUI(),
                              ),
                            ),
                            child: Text(
                              'ลงทะเบียน ',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
