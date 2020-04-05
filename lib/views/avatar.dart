import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main_controller.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<MainController, String>(
      selector: (_, control) => control.avatarUrl,
      builder: (_, value, __) {
        if (value.isEmpty) {
          return Image.asset(
            'assets/images/logo.png',
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
          );
        } else {
          return ClipRRect(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.4),
            child: CachedNetworkImage(
              imageUrl: value,
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              placeholder: (_, __) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    child: const Center(child: CircularProgressIndicator()));
              },
              fit: BoxFit.cover,
            ),
          );
        }
      },
    );
  }
}
