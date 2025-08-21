import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosActivityIndicator extends StatelessWidget {
  final double? radius;
  const MacosActivityIndicator({this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(brightness: MacosTheme.of(context).brightness),
      child: (radius != null)
          ? CupertinoActivityIndicator(
              radius: radius!,
            )
          : const CupertinoActivityIndicator(),
    );
  }
}
