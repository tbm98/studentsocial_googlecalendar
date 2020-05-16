import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsocialgooglecalendar/main_controller.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<MainController>()
        .setShowInforCallback(_showDialogBeforeImportFile);
  }

  void _showDialogBeforeImportFile() {
    showDialog(
        context: context,
        builder: (ct) {
          return AlertDialog(
            title: const Text('Lưu ý'),
            content: const Text(
                'Ứng dụng này sẽ đọc file excel được chọn từ điện thoại, '
                'sau đó phân tích thành lịch học và đẩy nó lên tài khoản '
                'Google Calendar của bạn. Có nghĩa rằng ứng dụng sẽ tạo '
                'mới một danh sách calendar Trên tài khoản Google Calendar '
                'của bạn hoặc xoá danh sách nếu nó đã tồn tại.'
                ' Ứng dụng đảm bảo sẽ không xoá nhưng thông tin về calendar'
                'trước đó của bạn mà chỉ xoá những thông tin do bản thân ứng'
                ' dụng tạo ra. Nếu bạn đồng ý với những điều trên thì hãy '
                'bấm đồng ý, nếu không hãy bấm huỷ.'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ct).pop();
                },
                child: const Text(
                  'Huỷ',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ct).pop();
                  context.read<MainController>().importAction();
                },
                child: const Text(
                  'Đồng ý',
                  style: TextStyle(color: Color(0xff1A73E9)),
                ),
              ),
            ],
          );
        });
  }

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
