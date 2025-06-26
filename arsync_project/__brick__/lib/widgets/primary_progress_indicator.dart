import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PrimaryProgressIndicator extends StatelessWidget {
  final String? message;
  const PrimaryProgressIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (Platform.isIOS) ...[const CupertinoActivityIndicator(radius: 20)],
          if (Platform.isAndroid) ...[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            message ?? 'Please Wait',
            style: TextStyle(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.60),
              fontSize: 16,
            ),
          ).px16(),
        ],
      ),
    );
  }
}
