import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:my_gpt_client/view/widgets/macos_activity_indicator.dart';

Future<void> showMacosActivitySheet(BuildContext context) =>
    showMacosAlertDialog(
      context: context,
      builder: (context) => const MacosActivitySheet(),
    );

class MacosActivitySheet extends StatelessWidget {
  static const Size _size = Size(48, 48);

  const MacosActivitySheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _size.width,
        height: _size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: MacosTheme.of(context).canvasColor,
        ),
        child: const MacosActivityIndicator(),
      ),
    );
  }
}
