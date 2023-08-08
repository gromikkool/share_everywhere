import 'package:flutter/material.dart';

class PopupItem<T> extends PopupMenuItem {
  const PopupItem({
    required Widget child,
    required T value,
    required VoidCallback onTap,
    Key? key,
  }) : super(key: key, child: child, value: value, onTap: onTap);

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {
    widget.onTap?.call();
  }
}
