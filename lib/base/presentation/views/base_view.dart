import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '/chat_system/presentation/views/chat_system_view.dart';
import '/chat/presentation/views/chat_screen.dart';

import '/base/presentation/logic/base_view_bloc.dart';
import '/view/widgets/macos_activity_sheet.dart';

class BaseView extends StatelessWidget {
  static const double _minSideBarWidth = 200;

  static const double _padding = 8.0;
  static const double _spacing = 8.0;

  const BaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _BaseViewContent();
  }
}

class _BaseViewContent extends StatelessWidget {
  const _BaseViewContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BaseViewBloc, BaseViewState>(
      listener: (context, state) {
        switch (state) {
          case BaseViewBusy():
            showMacosActivitySheet(context);
          case BaseViewMain():
            if (!state.init) Navigator.of(context).pop();
        }
      },
      child: MacosWindow(
        sidebar: Sidebar(
          top: const Padding(
            padding: EdgeInsets.only(
              left: BaseView._padding,
              right: BaseView._padding,
              bottom: BaseView._spacing,
            ),
            child: SidePanelHeader(title: 'Chats'),
          ),
          builder: (context, controller) {
            return ChatSystemView(
              scrollController: controller,
            );
          },
          minWidth: BaseView._minSideBarWidth,
        ),
        child: const ChatView(),
      ),
    );
  }
}
