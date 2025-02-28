import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/logging_extensions.dart';
import '../../../utils/utils.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_sheet.dart';

class Tab3 extends ConsumerWidget {
  static String get routeName => 'tab3';
  static String get routeLocation => '/$routeName';
  const Tab3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Alerts'),
      ),
      body: Column(
        children: [
          PrimaryButton(
            onTap: () {
              context.showSuccessSnackBar('Success Snackbar');
            },
            text: 'Success Snackbar',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showErrorSnackBar('Success Snackbar');
            },
            text: 'Error Snackbar',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showPrimarySnackbar(
                'Primary Snackbar',
                borderRadius: 0,
                borderWidth: 0,
                action: SnackBarAction(
                  label: 'Close',
                  onPressed: context.hideSnackBar,
                ),
              );
            },
            text: 'Primary Snackbar',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showCustomSnackbar(const SnackBar(content: Text('data')));
            },
            text: 'Primary Snackbar',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showMessageDialog('Dialog Title Message');
            },
            text: 'Message Dialog',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showMessageDialog(
                'Dialog Title Message',
                message: 'This is a description',
                buttonText: 'Close',
              );
            },
            text: 'Message + Description Dialog',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () async {
              final result = await context.showConfirmationDialog(
                'Logout?',
                message: 'Are you sure you want to logout?',
                actionText: 'Logout',
                actionTextNegative: 'Cancel',
              );
              result.toString().log();

              if (result != true) return;

              context.showSuccessSnackBar('Logged out');
            },
            text: 'Confirmation Dialog',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () async {
              final result = await context.showConfirmationDialog(
                'Logout?',
                message: 'Are you sure you want to logout?',
                actionText: 'Logout',
                actionTextNegative: 'Cancel',
                onActionPressed: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  return true;
                },
                onActionPressedNegative: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  return false;
                },
              );
              result.toString().log();
              if (result != true) return;
              context.showSuccessSnackBar('Returned true');
            },
            text: 'Confirmation Dialog Async',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () async {
              final result = await context.showPrimarySheet(
                title: 'Title',
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => context.pop('Option 1'),
                      title: const Text('Option 1'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                    ListTile(
                      onTap: () => context.pop('Option 2'),
                      trailing: const Icon(Icons.chevron_right),
                      title: const Text('Option 2'),
                    ),
                    ListTile(
                      onTap: () => context.pop('Option 3'),
                      trailing: const Icon(Icons.chevron_right),
                      title: const Text('Option 3'),
                    ),
                  ],
                ),
              );
              if (result == null) return;
              result.toString().log();
              context.showPrimarySnackbar(result);
            },
            text: 'Primary Sheet',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () async {
              PrimarySheet.show(
                context,
                child: ConfirmationSheet(
                  title: 'Hello',
                  message: 'World',
                  icon: Icons.check,
                  positiveButtonText: 'OK',
                  negativeButtonText: 'Cancel',
                  onPositiveAction: () {},
                  onNegativeAction: () {},
                ),
              );
            },
            text: 'Confirmation Sheet',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showSuccessSheet(
                icon: Icons.check,
                title: 'Activity Added',
                message: 'People can now see your activity',
              );
            },
            text: 'Success Sheet',
          ),
          12.heightBox,
          PrimaryButton(
            onTap: () {
              context.showErrorSheet(
                title: 'Oops!',
                message: 'Something went wrong',
              );
            },
            text: 'Error Sheet',
          ),
          100.heightBox,
        ],
      ).p16().safeArea().scrollVertical(),
    );
  }
}
