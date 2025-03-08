import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tk/About_page.dart';
import 'login_page.dart';
import 'bottom_nav_bar.dart';

class LogoutPage extends StatelessWidget {
  // ฟังก์ชันสำหรับออกจากระบบ
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully logged out')),
      );

      // หลังจากออกจากระบบแล้วให้กลับไปที่หน้า LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "คุณต้องการออกจากระบบหรือไม่?",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => logout(context),
                child: Text("ยืนยันออกจากระบบ"),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // หากผู้ใช้ไม่ต้องการออกจากระบบ จะกลับไปหน้าเดิม
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()),
                  );
                },
                child: Text("ยกเลิก"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
