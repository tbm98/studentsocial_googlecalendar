import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'circular_indicator.dart';

import '../main_controller.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MainController, bool>(
        selector: (_, control) => control.loading,
        builder: (_, value, child) {
          if (value) {
            return CircularIndicator();
          }
          return child;
        },
        child: _signInButton(context));
  }

  Widget _signInButton(BuildContext context) {
    return RaisedButton(
      elevation: 0,
      color: const Color(0xff1A73E9),
      onPressed: () {
        Provider.of<MainController>(context, listen: false).clicked();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Selector<MainController, StateAction>(
        selector: (_, control) => control.stateAction,
        builder: (_, value, __) {
          if (value == StateAction.notLogin) {
            return notLogin();
          }
          if (value == StateAction.logined) {
            return logined();
          }
          if (value == StateAction.imported) {
            return imported();
          }
          if (value == StateAction.uploaded) {
            return uploaded();
          }
          return null;
        },
      ),
    );
  }

  Widget notLogin() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget logined() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.add,
          color: Colors.white,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          'Inport',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget imported() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.file_upload,
          color: Colors.white,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          'Upload',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget uploaded() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.sentiment_satisfied,
          color: Colors.white,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          'Done!',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
