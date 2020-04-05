import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_controller.dart';

class CircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MainController, double>(
      selector: (_, control) => control.loadingValue,
      builder: (_, value, __) {
        return CircularProgressIndicator(
          value: value,
        );
      },
    );
  }
}
