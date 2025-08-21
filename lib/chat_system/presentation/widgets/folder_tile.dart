import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

import 'package:my_gpt_client/injector.dart';
import 'package:my_gpt_client/chat_system/presentation/widgets/context_menu.dart';
import 'package:my_gpt_client/chat_system/presentation/widgets/drag_region.dart';

import '../models/chat_system_object_view_model.dart';
import '../logic/chat_system_bloc/chat_system_bloc.dart';

class FolderTile extends StatefulWidget {
  final ChatFolderViewModel folder;
  final List<Widget> children;

  const FolderTile({required this.folder, required this.children, super.key});

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  @override
  Widget build(BuildContext context) {
    return DragRegion<ChatSystemObjectViewModel>(
      acceptor: DragRegionAcceptor(
        onCenter: (obj) => g<ChatSystemBloc>().moveObject(obj,
            from: g<ChatSystemBloc>().getParentFolder(obj), to: widget.folder),
        onAbove: (obj) => g<ChatSystemBloc>().insertAbove(obj, widget.folder),
        onBelow: (obj) => g<ChatSystemBloc>().insertBelow(obj, widget.folder),
      ),
      builder: (context, accepted, rejected) => Column(
        key: Key('side-panel-folder-widget-${widget.folder.id}'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => setState(
                () => widget.folder.data.isOpen = !widget.folder.data.isOpen),
            child: _FolderCard(folder: widget.folder),
          ),
          AnimatedCrossFade(
            firstChild: Container(
              key: Key(
                  'side-panel-folder-widget-switcher-collapsed-${widget.folder.id}'),
            ),
            secondChild: Padding(
              key: Key(
                  'side-panel-folder-widget-switcher-expanded-${widget.folder.id}'),
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.children,
              ),
            ),
            firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
            secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
            sizeCurve: Curves.fastOutSlowIn,
            crossFadeState: widget.folder.data.isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _FolderCard extends StatefulWidget {
  final ChatFolderViewModel folder;

  const _FolderCard({required this.folder});

  @override
  State<_FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<_FolderCard> {
  bool _renaming = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _renaming = true;
        });
      },
      child: Draggable<ChatSystemObjectViewModel>(
        data: widget.folder,
        feedback: Material(
          type: MaterialType.transparency,
          child: _FolderTileDraggingContent(folder: widget.folder),
        ),
        dragAnchorStrategy: pointerDragAnchorStrategy,
        child: ChatSystemObjectContextMenu(
          object: widget.folder,
          enabled: !_renaming,
          additionalOptions: [
            MenuItem(
              title: 'Rename',
              onSelected: () {
                setState(() {
                  _renaming = true;
                });
              },
            )
          ],
          child: _renaming
              ? _FolderTileEditingContent(
                  folder: widget.folder,
                  onEditingFinished: (data) {
                    setState(() {
                      _renaming = false;
                      widget.folder.name = data;
                    });
                  },
                  onEditingExited: () {
                    setState(() {
                      _renaming = false;
                    });
                  },
                )
              : _FolderTileContent(folder: widget.folder),
        ),
      ),
    );
  }
}

class _FolderTileContent extends StatelessWidget {
  final ChatFolderViewModel folder;

  const _FolderTileContent({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SidebarItemSize.large.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (MacosTheme.of(context).brightness == Brightness.light)
            ? CupertinoColors.tertiarySystemBackground
            : MacosColors.unemphasizedSelectedContentBackgroundColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            size: SidebarItemSize.large.iconSize,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                folder.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: MacosTheme.of(context).typography.body,
              ),
            ),
          ),
          Icon(
            folder.data.isOpen
                ? Icons.expand_less_rounded
                : Icons.expand_more_rounded,
            size: SidebarItemSize.large.iconSize,
          ),
        ],
      ),
    );
  }
}

class _FolderTileEditingContent extends StatefulWidget {
  final ChatFolderViewModel folder;
  final void Function(String data) onEditingFinished;
  final void Function()? onEditingExited;

  const _FolderTileEditingContent({
    required this.folder,
    required this.onEditingFinished,
    this.onEditingExited,
  });

  @override
  State<_FolderTileEditingContent> createState() =>
      _FolderTileEditingContentState();
}

class _FolderTileEditingContentState extends State<_FolderTileEditingContent> {
  late final TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.folder.name);
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        widget.onEditingExited?.call();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    focusNode.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SidebarItemSize.large.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (MacosTheme.of(context).brightness == Brightness.light)
            ? CupertinoColors.tertiarySystemBackground
            : MacosColors.unemphasizedSelectedContentBackgroundColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: SidebarItemSize.large.iconSize,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: MacosTextField.borderless(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              padding: EdgeInsets.zero,
              autocorrect: false,
              enableSuggestions: false,
              style: MacosTheme.of(context).typography.body,
              onSubmitted: (data) {
                widget.onEditingFinished(data);
              },
            ),
          ),
          Icon(
            widget.folder.data.isOpen
                ? Icons.expand_less_rounded
                : Icons.expand_more_rounded,
            size: SidebarItemSize.large.iconSize,
          ),
        ],
      ),
    );
  }
}

class _FolderTileDraggingContent extends StatelessWidget {
  final ChatFolderViewModel folder;

  const _FolderTileDraggingContent({required this.folder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SidebarItemSize.large.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (MacosTheme.of(context).brightness == Brightness.light)
            ? CupertinoColors.tertiarySystemBackground
            : MacosColors.unemphasizedSelectedContentBackgroundColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: SidebarItemSize.large.iconSize,
          ),
          const SizedBox(width: 8.0),
          Text(
            folder.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: MacosTheme.of(context).typography.body,
          ),
          // const SizedBox(width: 6.0),
        ],
      ),
    );
  }
}
