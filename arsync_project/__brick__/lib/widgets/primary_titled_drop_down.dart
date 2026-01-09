import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class PrimaryTitledDropDown<T> extends StatelessWidget {
  final String? title;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final List<String> titles;
  final List<T> items;
  final T? value;
  final Widget? icon;
  final Color? fillColor;

  final bool isLoading;
  const PrimaryTitledDropDown({
    super.key,
    required this.title,
    this.hint,
    this.onChanged,
    this.icon,
    this.fillColor,
    required this.titles,
    required this.items,
    required this.value,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final currentBorder = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: context.adaptive12),
      borderRadius: BorderRadius.circular(kBorderRadius),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: context.adaptive70,
            ),
          ).pOnly(left: 4),
          const SizedBox(height: 4),
        ],
        DropdownButtonFormField<T>(
          icon: () {
            if (isLoading) {
              return const SizedBox(
                width: 8,
                height: 8,
                child: CupertinoActivityIndicator(),
              );
            }
            return icon;
          }.call(),
          initialValue: value,
          dropdownColor: context.cardColor,
          menuMaxHeight: 0.6.sh(context),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            fillColor: fillColor ?? context.cardColor,
            filled: true,
            border: currentBorder,
            enabledBorder: currentBorder,
            focusedBorder: currentBorder,
          ),
          hint: Text(
            hint ?? (isLoading ? 'Loading ...' : 'Select $title'),
            style: TextStyle(color: context.adaptive54),
          ),
          items: items.asMap().entries.map((e) {
            final key = e.key;
            final title = titles[key];
            return DropdownMenuItem(value: e.value, child: Text(title));
          }).toList(),
          onChanged: onChanged,
          isExpanded: true,
          validator: (value) => Validators.dropDownValidator(
            value == null ? '' : value.toString(),
            title?.toLowerCase() ?? 'field',
          ),
        ),
      ],
    );
  }
}
