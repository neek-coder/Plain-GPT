import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:macos_ui/macos_ui.dart';

import '/settings/presentation/logic/chat_settings_bloc/chat_settings_bloc.dart';
import '/settings/presentation/models/chat_settings_view_model.dart';
import '/view/widgets/macos_divider.dart';
import '/view/widgets/macos_activity_indicator.dart';
import '/injector.dart';

class ChatSettingsView extends StatelessWidget {
  const ChatSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatSettingsBloc, ChatSettingsState>(
      builder: (context, state) {
        return switch (state) {
          ChatSettingsInitial() => _ChatSettingsWrapper(
              content: Center(
                child: Text(
                  'Open a chat and configure it',
                  style: MacosTheme.of(context).typography.body,
                ),
              ),
            ),
          ChatSettingsLoading() => const _ChatSettingsWrapper(
              content: Center(
                child: CupertinoTheme(
                  data: CupertinoThemeData(brightness: Brightness.dark),
                  child: MacosActivityIndicator(),
                ),
              ),
            ),
          ChatSettingsLoaded() => _ChatSettingsWrapper(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ContextBufferSelector(
                    contextBuffer: state.settings.contextBuffer,
                  ),
                  const SizedBox(height: 8.0),
                  _TemperatureSelector(
                    value: state.settings.temperature,
                  ),
                ],
              ),
            ),
          ChatSettingsSaving() => _ChatSettingsWrapper(
              loading: true,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ContextBufferSelector(
                    contextBuffer: state.settings.contextBuffer,
                    enabled: false,
                  ),
                  const SizedBox(height: 8.0),
                  _TemperatureSelector(
                    value: state.settings.temperature,
                    enabled: false,
                  ),
                ],
              ),
            ),
          QuickChatSettings() => _ChatSettingsWrapper(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ContextBufferSelector(
                    contextBuffer: state.settings.contextBuffer,
                  ),
                  const SizedBox(height: 8.0),
                  _TemperatureSelector(
                    value: state.settings.temperature,
                  ),
                ],
              ),
            ),
        };
      },
    );
  }
}

class _ChatSettingsWrapper extends StatelessWidget {
  final Widget content;
  final bool loading;
  const _ChatSettingsWrapper({required this.content, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerLeft,
            children: [
              Center(
                child: Text(
                  'Chat Settings',
                  style: MacosTheme.of(context).typography.headline,
                ),
              ),
              if (loading) const MacosActivityIndicator(radius: 5),
            ],
          ),
          const SizedBox(
            height: 20.0,
            child: Center(child: MacosDivider()),
          ),
          content,
        ],
      ),
    );
  }
}

class _ContextBufferSelector extends StatefulWidget {
  final ContextBuffer contextBuffer;
  final bool enabled;
  const _ContextBufferSelector(
      {required this.contextBuffer, this.enabled = true});

  @override
  State<_ContextBufferSelector> createState() => _ContextBufferSelectorState();
}

class _ContextBufferSelectorState extends State<_ContextBufferSelector> {
  final TextEditingController _customBufferSizeTEC =
      TextEditingController(text: '50');
  bool _isCustomContextBuffer = false;

  @override
  Widget build(BuildContext context) {
    _isCustomContextBuffer = widget.contextBuffer is CustomContextBuffer;

    ContextBuffer? currentBuffer = widget.contextBuffer;
    if (currentBuffer is CustomContextBuffer) {
      _customBufferSizeTEC.text = currentBuffer.size.toString();
      currentBuffer = null;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'Context Size',
                style: MacosTheme.of(context).typography.body,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8.0),
            MacosPopupButton<ContextBuffer>(
              value: currentBuffer,
              onChanged: widget.enabled
                  ? (contextBuffer) {
                      if (contextBuffer != null) {
                        // Predefined context buffer
                        final bloc = g<ChatSettingsBloc>();
                        setState(() {
                          bloc.update(
                            bloc.currentSettings.copyWith(
                              contextBuffer: contextBuffer,
                            ),
                          );
                        });
                      } else {
                        // Custom context buffer
                        final bloc = g<ChatSettingsBloc>();

                        setState(() {
                          bloc.update(
                            bloc.currentSettings.copyWith(
                              contextBuffer: const CustomContextBuffer(50),
                            ),
                          );
                        });
                      }
                    }
                  : null,
              items: const [
                MacosPopupMenuItem(
                  value: EmptyContextBuffer(),
                  child: Text('Empty'),
                ),
                MacosPopupMenuItem(
                  value: SmallContextBuffer(),
                  child: Text('Small'),
                ),
                MacosPopupMenuItem(
                  value: MediumContextBuffer(),
                  child: Text('Medium'),
                ),
                MacosPopupMenuItem(
                  value: LargeContextBuffer(),
                  child: Text('Large'),
                ),
                MacosPopupMenuItem(
                  value: UnlimitedContextBuffer(),
                  child: Text('Unlimited'),
                ),
                MacosPopupMenuItem(
                  value: null,
                  child: Text('Custom'),
                ),
              ],
            )
          ],
        ),
        if (_isCustomContextBuffer) ...[
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Spacer(),
              Flexible(
                child: MacosTextField(
                  enabled: widget.enabled,
                  controller: _customBufferSizeTEC,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  maxLength: 4,
                  keyboardType: const TextInputType.numberWithOptions(),
                  onSubmitted: (size) {
                    final valiatedSize =
                        int.parse(size).clamp(0, CustomContextBuffer.maxSize);

                    _customBufferSizeTEC.text = valiatedSize.toString();

                    final bloc = g<ChatSettingsBloc>();
                    bloc.update(
                      bloc.currentSettings.copyWith(
                        contextBuffer: CustomContextBuffer(valiatedSize),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TemperatureSelector extends StatefulWidget {
  final double value;
  final bool enabled;
  const _TemperatureSelector({
    required this.value,
    this.enabled = true,
  });

  @override
  State<_TemperatureSelector> createState() => _TemperatureSelectorState();
}

class _TemperatureSelectorState extends State<_TemperatureSelector> {
  final settings = g<ChatSettingsBloc>();

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(children: [
          Text(
            'Temperature',
            style: MacosTheme.of(context).typography.body,
            overflow: TextOverflow.ellipsis,
          ),
          MacosSlider(
            value: widget.value,
            discrete: true,
            splits: 9,
            onChanged: (v) {
              if (!widget.enabled) return;

              setState(() {
                settings.update(settings.currentSettings.copyWith(
                  temperature: v,
                ));
              });
            },
          ),
        ]),
        TableRow(children: [
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Predictable',
                style: MacosTheme.of(context).typography.caption1,
              ),
              Text(
                'Creative',
                style: MacosTheme.of(context).typography.caption1,
              ),
            ],
          ),
        ]),
      ],
    );
  }
}
