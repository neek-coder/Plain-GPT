import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

import '/chat/presentation/logic/chat_content_bloc/chat_content_bloc.dart';
import '../models/chat_system_object_view_model.dart';
import '../logic/chat_system_bloc/chat_system_bloc.dart';
import 'context_menu.dart';
import 'drag_region.dart';
import '/injector.dart';

const _selectedColor = MacosColors.systemBlueColor;

class ChatTile extends StatefulWidget {
  final ChatViewModel chat;

  const ChatTile({required this.chat, super.key});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  bool _renaming = false;

  @override
  Widget build(BuildContext context) {
    final selected = g<ChatSystemBloc>().getSelectedChat() == widget.chat;

    return GestureDetector(
      onTap: () {
        g<ChatSystemBloc>().selectChat(widget.chat);
      },
      onLongPress: () {
        setState(() {
          _renaming = true;
        });
      },
      child: DragRegion<ChatSystemObjectViewModel>(
        acceptor: DragRegionAcceptor(
          onAbove: (obj) => g<ChatSystemBloc>().insertAbove(obj, widget.chat),
          onBelow: (obj) => g<ChatSystemBloc>().insertBelow(obj, widget.chat),
        ),
        builder: (context, candidates, rejeced) => Draggable<ChatViewModel>(
          data: widget.chat,
          feedback: _ChatTileDraggingContent(
            chat: widget.chat,
            selected: selected,
          ),
          childWhenDragging: _ChatTileStaticContent(
            chat: widget.chat,
            selected: selected,
          ),
          dragAnchorStrategy: pointerDragAnchorStrategy,
          child: ChatSystemObjectContextMenu(
            object: widget.chat,
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
                ? _ChatTileEditingContent(
                    chat: widget.chat,
                    selected: selected,
                    onEditingFinished: (data) {
                      setState(() {
                        _renaming = false;
                        widget.chat.name = data.trim();

                        g<ChatContentBloc>()
                            .rename(widget.chat.id, widget.chat.name);
                        g<ChatSystemBloc>().storeSystem();
                      });
                    },
                    onEditingExited: () {
                      setState(() {
                        _renaming = false;
                      });
                    },
                  )
                : _ChatTileStaticContent(
                    chat: widget.chat,
                    selected: selected,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ChatTileStaticContent extends StatelessWidget {
  final ChatViewModel chat;
  final bool selected;
  const _ChatTileStaticContent({required this.chat, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SidebarItemSize.large.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: selected ? _selectedColor : MacosColors.transparent,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          chat.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: MacosTheme.of(context).typography.body.copyWith(
                color: (MacosTheme.of(context).brightness == Brightness.light &&
                        selected)
                    ? MacosColors.white
                    : null,
              ),
        ),
      ),
    );
  }
}

class _ChatTileEditingContent extends StatefulWidget {
  final ChatViewModel chat;
  final void Function(String data) onEditingFinished;
  final void Function()? onEditingExited;
  final bool selected;

  const _ChatTileEditingContent({
    required this.chat,
    required this.onEditingFinished,
    this.onEditingExited,
    this.selected = false,
  });

  @override
  State<_ChatTileEditingContent> createState() =>
      _ChatTileEditingContentState();
}

class _ChatTileEditingContentState extends State<_ChatTileEditingContent> {
  late final TextEditingController controller;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.chat.name);

    focusNode.addListener(() {
      if (!focusNode.hasFocus) widget.onEditingExited?.call();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SidebarItemSize.large.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: widget.selected ? _selectedColor : MacosColors.transparent,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: MacosTextField.borderless(
          focusNode: focusNode,
          autofocus: true,
          padding: EdgeInsets.zero,
          controller: controller,
          autocorrect: false,
          enableSuggestions: false,
          cursorColor: (widget.selected) ? MacosColors.white : null,
          style: MacosTheme.of(context).typography.body.copyWith(
                color: (widget.selected) ? MacosColors.white : null,
              ),
          onSubmitted: (data) {
            widget.onEditingFinished(data);
          },
          // onTapOutside: (_) {
          //   onEditingExited?.call();
          // },
        ),
      ),
    );
  }
}

class _ChatTileDraggingContent extends StatelessWidget {
  final ChatViewModel chat;
  final bool selected;
  const _ChatTileDraggingContent({required this.chat, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SidebarItemSize.large.height,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: selected ? _selectedColor : MacosColors.transparent,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        chat.name,
        style: MacosTheme.of(context).typography.body.copyWith(
              color: selected ? MacosColors.white : null,
            ),
      ),
    );
  }
}
