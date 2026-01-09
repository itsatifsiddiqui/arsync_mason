import 'package:flutter/material.dart';

import '../utils/utils.dart';

class DraggablePrimarySheet extends StatelessWidget {
  final String? title;

  final double maxChildSize;
  final double minChildSize;
  final double initialChildSize;
  final bool expand;
  final bool snap;
  final Widget child;
  final List<double>? snapSizes;

  const DraggablePrimarySheet({
    super.key,
    this.title,
    required this.child,
    required this.maxChildSize,
    required this.minChildSize,
    required this.initialChildSize,
    required this.expand,
    required this.snap,
    this.snapSizes,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: maxChildSize,
      minChildSize: minChildSize,
      initialChildSize: initialChildSize,
      expand: expand,
      snap: snap,
      snapSizes: snapSizes ?? [minChildSize, initialChildSize, maxChildSize],
      builder: (context, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 0.1.sw(context),
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                    ),
                  ).centered(),
                  if (title != null) ...[
                    16.heightBox,
                    Text(
                      title!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ).p16(),
              Divider(height: 0, color: context.adaptive26),
              ListView(controller: controller, children: [child]).expand(),
            ],
          ).safeArea(),
        );
      },
    );
  }

  static Future<void> show(
    BuildContext context, {
    required Widget child,
    String? title,
    double maxChildSize = 0.9,
    double minChildSize = 0.3,
    double initialChildSize = 0.5,
    bool expand = false,
    bool snap = true,
    List<double>? snapSizes,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return DraggablePrimarySheet(
          expand: expand,
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          snap: snap,
          title: title,
          snapSizes: snapSizes,
          child: child,
        );
      },
    );
  }
}