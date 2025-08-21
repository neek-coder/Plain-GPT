import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

enum _Hover {
  none,
  top,
  center,
  bottom;
}

final class DragRegionAcceptor<T> {
  final void Function(T)? onAbove;
  final void Function(T)? onCenter;
  final void Function(T)? onBelow;

  const DragRegionAcceptor({
    this.onAbove,
    this.onCenter,
    this.onBelow,
  });
}

class DragRegion<T extends Object> extends StatefulWidget {
  final bool Function(T?)? onWillAccept;
  final DragRegionAcceptor<T>? acceptor;
  final void Function(T?)? onLeave;
  final bool highlightOnHover;
  final Widget Function(
      BuildContext context, List<T?> candidates, List<Object?> rejeced) builder;

  const DragRegion({
    super.key,
    this.acceptor,
    this.onLeave,
    this.onWillAccept,
    this.highlightOnHover = true,
    required this.builder,
  });

  @override
  State<DragRegion<T>> createState() => _DragRegionState<T>();
}

class _DragRegionState<T extends Object> extends State<DragRegion<T>> {
  static const _maxThreshold = 16.0;

  var _hover = _Hover.none;

  @override
  Widget build(BuildContext context) {
    return DragTarget<T>(
      onWillAcceptWithDetails: (details) {
        setState(() {
          _hover = _getHover(details.offset);
        });

        return widget.onWillAccept?.call(details.data) ?? true;
      },
      onMove: (details) {
        setState(() {
          _hover = _getHover(details.offset);
        });
      },
      onLeave: (obj) {
        setState(() {
          _hover = _Hover.none;

          widget.onLeave?.call(obj);
        });
      },
      onAcceptWithDetails: (details) {
        setState(() {
          _acceptorCallback(details.data);

          _hover = _Hover.none;
        });
      },
      builder: (context, candidates, rejected) => Container(
        decoration: _getDecoration(),
        child: widget.builder(context, candidates, rejected),
      ),
    );
  }

  _Hover _getHover(Offset point) {
    final renderBox = context.findRenderObject()! as RenderBox;

    final height = renderBox.size.height;

    final y = renderBox.globalToLocal(point).dy;

    final threshold = min(height / 3, _maxThreshold);

    if (y < 0 || y > height) return _Hover.none;

    if (y < threshold) return _Hover.top;

    if (y > height - threshold) return _Hover.bottom;

    return _Hover.center;
  }

  void _acceptorCallback(T data) {
    switch (_hover) {
      case _Hover.top:
        widget.acceptor?.onAbove?.call(data);
      case _Hover.center:
        widget.acceptor?.onCenter?.call(data);
      case _Hover.bottom:
        widget.acceptor?.onBelow?.call(data);
      case _Hover.none:
        null;
    }
  }

  BoxDecoration? _getDecoration() => switch (_hover) {
        _Hover.top => BoxDecoration(
            border: Border(
              top: const BorderSide(
                color: CupertinoColors.systemBlue,
                width: 2.0,
              ),
              bottom: BorderSide(
                color: CupertinoColors.black.withOpacity(0),
                width: 2.0,
              ),
            ),
          ),
        _Hover.bottom => BoxDecoration(
            border: Border(
              bottom: const BorderSide(
                color: CupertinoColors.systemBlue,
                width: 2.0,
              ),
              top: BorderSide(
                color: CupertinoColors.black.withOpacity(0),
                width: 2.0,
              ),
            ),
          ),
        _Hover.center => BoxDecoration(
            color: (MacosTheme.of(context).brightness == Brightness.light)
                ? CupertinoColors.tertiarySystemBackground
                : MacosColors.unemphasizedSelectedContentBackgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.black.withOpacity(0),
                width: 2.0,
              ),
              top: BorderSide(
                color: CupertinoColors.black.withOpacity(0),
                width: 2.0,
              ),
            ),
          ),
        _Hover.none => BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.black.withOpacity(0),
                width: 2.0,
              ),
              top: BorderSide(
                color: CupertinoColors.black.withOpacity(0),
                width: 2.0,
              ),
            ),
          ),
      };
}
