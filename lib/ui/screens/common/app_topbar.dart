import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.allowBack = false,
    this.onBack,
  });

  final String title;
  final bool allowBack;
  final void Function(BuildContext)? onBack;

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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}