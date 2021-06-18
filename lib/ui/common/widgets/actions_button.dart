import 'package:flutter/material.dart';
import 'package:guardspot/util/extensions/language_extensions.dart';

class ActionsButton extends StatelessWidget {
  final Icon icon;
  final List<ActionsButtonItem> items;

  ActionsButton({
    required this.items,
    this.icon = const Icon(Icons.more_vert),
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: icon,
      onSelected: (int value) => items[value].onPressed(),
      itemBuilder: (_) => items
          .mapIndexed((int index, ActionsButtonItem item) =>
              PopupMenuItem(child: item.child, value: index))
          .toList(),
    );
  }
}

class ActionsButtonItem {
  final Text child;
  final VoidCallback onPressed;

  ActionsButtonItem({
    required this.child,
    required this.onPressed,
  });
}
