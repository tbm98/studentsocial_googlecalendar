import 'package:flutter/material.dart';
import '../helpers/method_channel.dart';
import 'avatar.dart';
import 'sign_in_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MethodChannelHelper methodChannelHelper = MethodChannelHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Avatar(),
              Text(
                'Chia sẻ lịch học của bạn lên Google Calendar'
                ' và xem chúng ở mọi nơi',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                'Sau khi hoàn thành, bạn có thể xem offline trên ứng dụng'
                ' Calendar hoặc xem online trên trang chủ Calendar'
                ' bằng trình duyệt.',
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              SignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}
