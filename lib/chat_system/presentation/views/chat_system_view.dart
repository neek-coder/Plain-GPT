import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:my_gpt_client/chat/presentation/logic/chat_content_bloc/chat_content_bloc.dart';
import 'package:my_gpt_client/injector.dart';
import 'package:my_gpt_client/chat_system/presentation/widgets/drag_region.dart';
import 'package:my_gpt_client/view/widgets/macos_activity_indicator.dart';

import '../models/chat_system_object_view_model.dart';
import '../logic/chat_system_bloc/chat_system_bloc.dart';
import '../widgets/chat_tile.dart';
import '../widgets/folder_tile.dart';

class ChatSystemView extends StatefulWidget {
  final ScrollController? scrollController;

  const ChatSystemView({
    this.scrollController,
    super.key,
  });

  @override
  State<ChatSystemView> createState() => _ChatSystemViewState();
}

class _ChatSystemViewState extends State<ChatSystemView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSystemBloc, ChatSystemState>(
      builder: (context, state) {
        if (state is! ChatSystemLoaded) {
          return const Center(
            child: MacosActivityIndicator(),
          );
        }

        return DragRegion<ChatSystemObjectViewModel>(
          acceptor: DragRegionAcceptor(
            onCenter: (obj) => g<ChatSystemBloc>().moveObject(obj,
                from: g<ChatSystemBloc>().getParentFolder(obj)),
          ),
          builder: (cntext, accepted, regected) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: ListView.builder(
                controller: widget.scrollController,
                itemCount: state.system.itemsCount,
                itemBuilder: (context, i) =>
                    _buildChatStructure([state.system.rootElementAt(i)]).first,
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildChatStructure(List<ChatSystemObjectViewModel> objects) {
    final List<Widget> widgets = [];

    for (final o in objects) {
      if (o is ChatViewModel) {
        widgets.add(
          ChatTile(
            chat: o,
            key: Key('chat-tile-${o.id}'),
          ),
        );
      } else if (o is ChatFolderViewModel) {
        widgets.add(
          FolderTile(
            folder: o,
            key: Key('folder-tile-${o.id}'),
            children:
                _buildChatStructure(g<ChatSystemBloc>().getFolderContent(o)),
          ),
        );
      }
    }

    return widgets;
  }
}

class SidePanelHeader extends StatelessWidget {
  final String title;

  const SidePanelHeader({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: MacosTheme.of(context)
              .typography
              .title1
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        MacosTooltip(
          message: 'Quick Chat (⌘ + ⇧ + N)',
          child: _HeaderButton(
            onTap: () => g<ChatContentBloc>().quickChat(),
            icon: CupertinoIcons.bolt,
          ),
        ),
        MacosTooltip(
          message: 'New Chat (⌘ + N)',
          child: _HeaderButton(
            onTap: () => g<ChatSystemBloc>().newChat(),
            icon: CupertinoIcons.chat_bubble,
          ),
        ),
        MacosTooltip(
          message: 'New Folder',
          child: _HeaderButton(
            onTap: () => g<ChatSystemBloc>().newFolder(),
            icon: CupertinoIcons.folder_badge_plus,
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;

  const _HeaderButton({required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return MacosIconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 20.0),
    );
  }
}
