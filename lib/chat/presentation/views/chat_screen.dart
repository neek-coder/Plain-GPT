import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:my_gpt_client/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';
import 'package:my_gpt_client/settings/presentation/logic/settings_sheet_cubit/settings_sheet_cubit.dart';
import 'package:my_gpt_client/chat_system/presentation/logic/chat_system_bloc/chat_system_bloc.dart';

import '/settings/presentation/models/chat_settings_view_model.dart';
import '/settings/presentation/models/global_settings_view_model.dart';
import '/chat/domain/usecases/text_generation_model/stream_text_usecase.dart';
import '/settings/domain/repositories/settings_repository_interface.dart';

import '/core/entities/chat_role.dart';
import '../../domain/entities/text_generation_api_entity.dart';
import '../view_models/chat_content_view_model.dart';
import '../logic/chat_content_bloc/chat_content_bloc.dart';

import '/injector.dart';
import 'chat_message_box.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      HardwareKeyboard.instance.addHandler(_keyboardHandler);
    });
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_keyboardHandler);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatContentBloc, ChatContentState>(
      builder: (context, state) {
        switch (state) {
          case ChatContentInitial():
            return _ChatViewContentWrapper(
              builder: (context, controller) => const Center(
                child: Text('Open a chat to start a conversation'),
              ),
              toolbar: _getToolbar(),
            );
          case ChatContentLoading():
            return _ChatViewContentWrapper(
              builder: (context, controller) => const Center(
                child: ProgressCircle(),
              ),
              toolbar: _getToolbar(),
            );
          case ChatContentLoaded():
            return _ChatViewContentWrapper(
              builder: (context, controller) =>
                  _ChatViewContent(chatContent: state.content),
              toolbar: _getToolbar(chatName: state.chat.name),
            );
          case QuickChat():
            return _ChatViewContentWrapper(
              builder: (context, controller) =>
                  _ChatViewContent(chatContent: state.content),
              toolbar: _getToolbar(chatName: 'Quick Chat'),
            );
          // case ChatContentError():
          //   return _ChatViewContentWrapper(
          //     builder: (_, __) => const Center(
          //       child: Text('An error ooccured:'),
          //     ),
          //     toolbar: _getToolbar(),
          //   );
        }
      },
    );
  }

  bool _keyboardHandler(KeyEvent event) {
    final chatSystem = g<ChatSystemBloc>();

    if (event is KeyDownEvent && HardwareKeyboard.instance.isMetaPressed) {
      if (event.logicalKey == LogicalKeyboardKey.bracketLeft) {
        MacosWindowScope.of(context).toggleSidebar();
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.comma) {
        g<SettingsSheetCubit>().show(context);
        return true;
      } else if (event.logicalKey == LogicalKeyboardKey.keyN) {
        if (HardwareKeyboard.instance.isShiftPressed) {
          g<ChatContentBloc>().quickChat();
        } else {
          chatSystem.newChat();
        }
        return true;
      }
    }
    return false;
  }

  ToolBar _getToolbar({String? chatName}) => ToolBar(
        title: chatName != null
            ? Text(
                chatName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                // style: MacosTheme.of(context).typography.title2,
              )
            : null,
        actions: [
          ToolBarIconButton(
              label: "Chats",
              icon: const MacosIcon(
                CupertinoIcons.sidebar_left,
              ),
              onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
              showLabel: false,
              tooltipMessage: 'Chats (⌘ + [)'),
          ToolBarIconButton(
              label: "Settings",
              icon: const MacosIcon(
                CupertinoIcons.settings,
              ),
              onPressed: () => g<SettingsSheetCubit>().show(context),
              showLabel: false,
              tooltipMessage: 'Settings (⌘ + ,)'),
        ],
      );
}

class _ChatViewContentWrapper extends StatelessWidget {
  final Widget Function(BuildContext context, ScrollController controller)
      builder;
  final ToolBar? toolbar;

  const _ChatViewContentWrapper({required this.builder, this.toolbar});

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: toolbar,
      children: [
        ContentArea(
          builder: (context, scrollController) =>
              builder(context, scrollController),
        ),
      ],
    );
  }
}

class _ChatViewContent extends StatefulWidget {
  final ChatContentViewModel chatContent;

  const _ChatViewContent({required this.chatContent});

  @override
  State<_ChatViewContent> createState() => _ChatViewContentState();
}

class _ChatViewContentState extends State<_ChatViewContent> {
  static const delete =
      SingleActivator(LogicalKeyboardKey.backspace, meta: true);

  final _chatScrollController = ScrollController();

  final _chatFocusNode = FocusNode();
  final _promptFieldFocusNode = FocusNode();

  StreamSubscription<TextGenerationResponseEntity>? _responseStream;

  @override
  void initState() {
    super.initState();

    _promptFieldFocusNode.addListener(() {
      if (_promptFieldFocusNode.hasFocus) {
        _chatFocusNode.unfocus();
      } else {
        _chatFocusNode.requestFocus();
      }
    });

    _scrollToBottom();
  }

  @override
  void didUpdateWidget(covariant _ChatViewContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.chatContent.hashCode == widget.chatContent.hashCode) return;

    _responseStream = null;

    if (_chatScrollController.hasClients) {
      _chatScrollController.jumpTo(0);
    }

    _promptFieldFocusNode.requestFocus();

    _scrollToBottom();
  }

  @override
  void dispose() {
    g<ChatContentBloc>().save();
    _chatScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CallbackShortcuts(
            bindings: {
              delete: () {
                final chatSystem = g<ChatSystemBloc>();

                final chat = chatSystem.getSelectedChat();

                if (chat != null) {
                  chatSystem.delete(chat);
                }
              }
            },
            child: Focus(
              focusNode: _chatFocusNode,
              child: (widget.chatContent.content.isEmpty)
                  ? const Center(
                      child: Text('Go ahead, start a conversation!'),
                    )
                  : ListView.builder(
                      controller: _chatScrollController,
                      cacheExtent: double.infinity,
                      itemCount: widget.chatContent.content.length + 1,
                      itemBuilder: (ctx, i) => (i == 0)
                          ? const SizedBox(
                              height: 8.0,
                            )
                          : ChatMessageBox(
                              message: widget.chatContent.content[i - 1],
                            ),
                    ),
            ),
          ),
        ),
        _ChatViewPromptField(
          onSubmit: _submit,
          onCancel: _cancel,
          responsePending: _responseStream != null,
          focusNode: _promptFieldFocusNode,
        ),
      ],
    );
  }

  void _addUserPromptToTheConversation(String prompt) {
    widget.chatContent.content.add(
      ChatMessageViewModel(message: prompt, role: ChatRole.user),
    );
  }

  GlobalSettingsViewModel _getGlobalSettings() {
    final settingsEntity = g<SettingsRepositoryIntf>().globalSettings;

    return (settingsEntity != null)
        ? GlobalSettingsViewModel.fromEntity(settingsEntity)
        : GlobalSettingsViewModel.defaultConfiguration();
  }

  ChatSettingsViewModel _getChatSettings() {
    ChatSettingsViewModel? settings;

    if (g<ChatSettingsBloc>().isQuickChat) {
      settings = g<ChatSettingsBloc>().currentSettings;
    } else {
      final entity = g<SettingsRepositoryIntf>().currentChatSettings;
      settings = (entity != null)
          ? ChatSettingsViewModel.fromEntity(entity)
          : const ChatSettingsViewModel.defaultConfiguration();
    }

    print(settings);

    return settings;
  }

  StreamSubscription<TextGenerationResponseEntity> _createResponseStream(
    String prompt,
    void Function(TextGenerationResponseEntity response) listener,
    void Function(dynamic e) onError,
    void Function() onDone,
  ) {
    final stream = g<StreamTextUsecase>();

    final model =
        _getGlobalSettings().modelContainer.getSelectedModel().toEntity();
    final context = _getChatSettings()
        .contextBuffer
        .apply(widget.chatContent.content)
        .map((e) => e.toEntity())
        .toList();
    final temperature = _getChatSettings().temperature;

    final request = TextGenerationRequestEntity(
      prompt: prompt,
      model: model,
      context: context,
      temperature: temperature,
    );

    return (stream(request) as Stream<TextGenerationResponseEntity>).listen(
      listener,
      onError: onError,
      onDone: onDone,
    );
  }

  void _onError(ChatMessageViewModel response, dynamic e) {
    setState(() {
      if (response.message.isNotEmpty) {
        response.message += '\n\n';
      }

      response.message += 'Request has failed.\n\nDetails: $e';

      // response.message += 'Request has failed for an unknown reason.';

      _responseStream = null;
    });
  }

  void _onDone(ChatMessageViewModel responseMessage) {
    setState(() {
      if (responseMessage.message.isEmpty) {
        responseMessage.message = '*This message is empty*';
      }

      _responseStream = null;
    });
  }

  bool _submit(String prompt) {
    if (_responseStream != null) return false;

    setState(() {
      _addUserPromptToTheConversation(prompt);

      final responseMessage =
          ChatMessageViewModel(message: '', role: ChatRole.model);

      widget.chatContent.content.add(responseMessage);

      _responseStream = _createResponseStream(
        prompt,
        (response) => setState(() {
          responseMessage.message += response.chunk;
        }),
        (e) => _onError(responseMessage, e),
        () => _onDone(responseMessage),
      );
    });

    _scrollToBottom();

    return true;
  }

  void _cancel() {
    if (_responseStream == null) return;

    setState(() {
      _responseStream!.cancel();
      _responseStream = null;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_chatScrollController.hasClients) return;

      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 550),
        curve: Curves.linearToEaseOut,
      );
    });
  }
}

class _ChatViewPromptField extends StatefulWidget {
  final FocusNode? focusNode;
  final bool responsePending;
  final bool Function(String prompt) onSubmit;
  final void Function() onCancel;

  const _ChatViewPromptField({
    required this.onSubmit,
    required this.onCancel,
    this.responsePending = false,
    this.focusNode,
  });

  @override
  State<_ChatViewPromptField> createState() => _ChatViewPromptFieldState();
}

class _ChatViewPromptFieldState extends State<_ChatViewPromptField> {
  final _promptFieldController = TextEditingController();
  late final FocusNode _promptFieldFocusNode;

  @override
  void initState() {
    super.initState();

    _promptFieldFocusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _promptFieldController.dispose();
    _promptFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitHoverColor =
        (MacosTheme.of(context).brightness == Brightness.light)
            ? CupertinoColors.tertiarySystemBackground
            : MacosColors.unemphasizedSelectedContentBackgroundColor;

    const cancelHoverColor = MacosColors.appleRed;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        children: [
          Flexible(
            child: MacosTextField(
              autofocus: true,
              focusNode: _promptFieldFocusNode,
              controller: _promptFieldController,
              padding: const EdgeInsets.all(8.0),
              minLines: 1,
              maxLines: 5,
              // decoration: kDefaultRoundedBorderDecoration,
              // focusedDecoration: kDefaultRoundedBorderDecoration,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              placeholder: 'Ask any question...',
              onSubmitted: (prompt) {
                if (prompt.isEmpty) return;

                setState(() {
                  if (widget.onSubmit(prompt)) {
                    _promptFieldController.text = '';
                    _promptFieldFocusNode.requestFocus();
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 8.0),
          MacosIconButton(
            icon: Icon(
              widget.responsePending
                  ? CupertinoIcons.stop_fill
                  : CupertinoIcons.paperplane,
              size: 16.0,
              color: widget.responsePending ? MacosColors.white : null,
            ),
            backgroundColor: widget.responsePending
                ? MacosColors.appleRed
                : MacosTheme.of(context).iconButtonTheme.hoverColor,
            hoverColor:
                widget.responsePending ? cancelHoverColor : submitHoverColor,
            boxConstraints: BoxConstraints.loose(const Size(30, 30)),
            onPressed: () {
              if (widget.responsePending) {
                widget.onCancel();
              } else {
                if (_promptFieldController.text.isEmpty) return;

                setState(() {
                  if (widget.onSubmit(_promptFieldController.text)) {
                    _promptFieldController.text = '';
                    _promptFieldFocusNode.requestFocus();
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
