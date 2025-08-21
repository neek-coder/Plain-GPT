import 'package:flutter/material.dart';

import 'package:my_gpt_client/injector.dart';
import 'package:native_context_menu/native_context_menu.dart';

import '../logic/chat_system_bloc/chat_system_bloc.dart';
import '../models/chat_system_object_view_model.dart';

export 'package:native_context_menu/native_context_menu.dart';

class ChatSystemObjectContextMenu extends StatelessWidget {
  final ChatSystemObjectViewModel object;
  final List<MenuItem>? additionalOptions;

  /// Whether context menu can be called or not
  final bool enabled;
  final Widget child;

  const ChatSystemObjectContextMenu({
    required this.child,
    required this.object,
    this.additionalOptions,
    this.enabled = true,
    super.key,
  });

  List<MenuItem> get _defaultItems => [
        MenuItem(
            title: 'New chat',
            onSelected: () => g<ChatSystemBloc>().newChat(
                (object is ChatFolderViewModel)
                    ? object as ChatFolderViewModel
                    : g<ChatSystemBloc>().getParentFolder(object))),
        MenuItem(
            title: 'New folder',
            onSelected: () => g<ChatSystemBloc>().newFolder(
                (object is ChatFolderViewModel)
                    ? object as ChatFolderViewModel
                    : g<ChatSystemBloc>().getParentFolder(object))),
        MenuItem(
          title: 'Delete',
          onSelected: () => g<ChatSystemBloc>().delete(object,
              from: g<ChatSystemBloc>().getParentFolder(object)),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return ContextMenuRegion(
        onItemSelected: (item) {
          item.onSelected?.call();
        },
        menuItems: [
          if (additionalOptions != null) ...additionalOptions!,
          ..._defaultItems,
        ],
        child: child,
      );
    } else {
      return child;
    }
  }
}
