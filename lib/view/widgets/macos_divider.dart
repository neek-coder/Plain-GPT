import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

class MacosDivider extends StatelessWidget {
  const MacosDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MacosTheme.of(context).brightness.resolve(
            MacosColors.disabledControlTextColor,
            MacosColors.disabledControlTextColor.darkColor,
          ),
      height: 0.5,
    );
  }
}
