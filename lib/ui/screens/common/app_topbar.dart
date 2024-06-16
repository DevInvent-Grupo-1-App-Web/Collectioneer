import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.allowBack = false,
    this.onBack,
    this.actions,
  });

  final String title;
  final bool allowBack;
  final void Function(BuildContext)? onBack;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: allowBack,
      leading: allowBack
          ? BackButton(
              onPressed: () {
                if (onBack != null) {
                  onBack!(context);
                } else {
                  Navigator.pop(context);
                }
              },
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}