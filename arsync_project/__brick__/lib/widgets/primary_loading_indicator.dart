// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import '../utils/utils.dart';

class PrimaryLoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final num? progress;
  const PrimaryLoadingIndicator({
    super.key,
    required this.isLoading,
    required this.child,
    this.progress,
  });
  @override
  Widget build(BuildContext context) {
    return LoadingOverlayPro(
      isLoading: isLoading,
      backgroundColor: Colors.black.withOpacity(0.65),
      progressIndicator: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: context.theme.canvasColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.adaptive12),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: 1.24,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              if (progress != null)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '${progress!.toStringAsFixed(0)}%',
                    style: TextStyle(color: context.primaryColor),
                  ),
                ),
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}
