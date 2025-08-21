import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:macos_ui/macos_ui.dart';

import '/injector.dart';
import '/settings/presentation/models/text_generation_model_view_model.dart';
import '/view/widgets/macos_activity_indicator.dart';
import '/view/widgets/macos_divider.dart';

import '/settings/presentation/logic/global_settings_bloc/global_settings_bloc.dart';

class GlobalSettingsView extends StatelessWidget {
  const GlobalSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalSettingsBloc, GlobalSettingsState>(
      builder: (context, state) {
        return switch (state) {
          GlobalSettingsInitial() => _GlobalSettingsWrapper(
              content: Container(),
            ),
          GlobalSettingsLoading() => const _GlobalSettingsWrapper(
              content: Center(
                child: MacosActivityIndicator(),
              ),
            ),
          GlobalSettingsLoaded() => _GlobalSettingsWrapper(
              content: Column(
                children: [
                  _ModelPicker(
                    model: state.settings.modelContainer.getSelectedModel(),
                  ),
                  const SizedBox(height: 8.0),
                  _VersionPicker(
                    model: state.settings.modelContainer.getSelectedModel(),
                  ),
                  const SizedBox(height: 8.0),
                  _ApiKeyField(
                    model: state.settings.modelContainer.getSelectedModel(),
                  ),
                ],
              ),
            ),
          GlobalSettingsSaving() => _GlobalSettingsWrapper(
              loading: true,
              content: Column(
                children: [
                  _ModelPicker(
                    model: state.settings.modelContainer.getSelectedModel(),
                    enabled: false,
                  ),
                  const SizedBox(height: 8.0),
                  _VersionPicker(
                    model: state.settings.modelContainer.getSelectedModel(),
                    enabled: false,
                  ),
                  const SizedBox(height: 8.0),
                  _ApiKeyField(
                    model: state.settings.modelContainer.getSelectedModel(),
                    enabled: false,
                  ),
                ],
              ),
            ),
        };
      },
    );
  }
}

class _GlobalSettingsWrapper extends StatelessWidget {
  final Widget content;
  final bool loading;
  const _GlobalSettingsWrapper({required this.content, this.loading = false});

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
                  'Global Settings',
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

class _ModelPicker extends StatelessWidget {
  final TextGenerationModelViewModel model;
  final bool enabled;
  const _ModelPicker({required this.model, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Model',
            style: MacosTheme.of(context).typography.body,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8.0),
        MacosPopupButton<TextGenerationModelInstance>(
          value: model.instance,
          onChanged: enabled
              ? (model) {
                  // Predefined context buffer
                  final bloc = g<GlobalSettingsBloc>();
                  bloc.update(
                    bloc.currentSettings..modelContainer.selectModel(model!),
                  );
                }
              : null,
          items: TextGenerationModelInstance.values
              .map(
                (e) => MacosPopupMenuItem<TextGenerationModelInstance>(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _VersionPicker extends StatelessWidget {
  final TextGenerationModelViewModel model;
  final bool enabled;
  const _VersionPicker({required this.model, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            'Version',
            style: MacosTheme.of(context).typography.body,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8.0),
        MacosPopupButton<TextGenerationModelVersion>(
          value: model.version,
          onChanged: enabled
              ? (version) {
                  // Predefined context buffer
                  final bloc = g<GlobalSettingsBloc>();
                  bloc.update(
                    bloc.currentSettings
                      ..modelContainer
                          .updateModel(model.copyWith(version: version)),
                  );
                }
              : null,
          items: model.instance.versions
              .map(
                (e) => MacosPopupMenuItem<TextGenerationModelVersion>(
                  value: e,
                  child: Text(e.name),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ApiKeyField extends StatefulWidget {
  final TextGenerationModelViewModel model;
  final bool enabled;
  const _ApiKeyField({
    required this.model,
    this.enabled = true,
  });

  @override
  State<_ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<_ApiKeyField> {
  late final TextEditingController apiKeyTextEditingController;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    apiKeyTextEditingController =
        TextEditingController(text: widget.model.apiKey);

    focusNode.addListener(() {
      if (!focusNode.hasFocus &&
          apiKeyTextEditingController.text != widget.model.apiKey) {
        _update();
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ApiKeyField oldWidget) {
    apiKeyTextEditingController.text = widget.model.apiKey;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'API Key',
          style: MacosTheme.of(context).typography.body,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: 8.0),
        Flexible(
          child: MacosTextField(
            placeholder: 'Your API key here',
            focusNode: focusNode,
            enabled: widget.enabled,
            controller: apiKeyTextEditingController,
            maxLines: 1,
            onSubmitted: _update,
          ),
        ),
      ],
    );
  }

  void _update([String? apiKey]) {
    final bloc = g<GlobalSettingsBloc>();
    bloc.update(
      bloc.currentSettings
        ..modelContainer.updateModel(
          widget.model.copyWith(
            apiKey: apiKey ?? apiKeyTextEditingController.text,
          ),
        ),
    );
  }
}
