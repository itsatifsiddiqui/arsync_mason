import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const kBorderRadius = {{{borderRadius}}};


Future<void> kLaunchUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    try {
      final result = await launchUrl(uri);
      debugPrint(result.toString());
      if (!result) {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  } else {
    await launchUrl(uri);
  }
}

Widget kImagePlaceHolder(_, _) {
  return const Padding(
    padding: EdgeInsets.all(50.0),
    child: Center(child: CupertinoActivityIndicator()),
  );
}

Widget kErrorWidget(_, _, _) => const Padding(
  padding: EdgeInsets.all(50),
  child: Center(child: Icon(Icons.error_outline, color: Colors.red)),
);

Widget kImagePlaceHolderSmall(_, _) {
  return const Center(child: CupertinoActivityIndicator());
}

Widget kErrorWidgetSmall(_, _, _) =>
    const Center(child: Icon(Icons.error_outline, color: Colors.red));

Map<String, bool> generateBigram(String value) {
  final map = <String, bool>{};
  final s1 = value.toLowerCase();
  const n = 2;
  for (int k = 0; k <= s1.length - n; k++) {
    map.addAll({s1.substring(k, k + n): true});
  }
  return map;
}