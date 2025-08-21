enum TextGenerationModelInstance {
  chatGPT('Chat GPT', 'chat-gpt', [
    TextGenerationModelVersion('v4 Turbo', 'gpt-4-turbo-preview'),
    TextGenerationModelVersion('v3.5 Turbo', 'gpt-3.5-turbo'),
  ]),
  gemini('Gemini', 'gemini', [
    TextGenerationModelVersion('Pro', 'gemini-pro'),
  ]);

  final String name;
  final String code;
  final List<TextGenerationModelVersion> versions;

  const TextGenerationModelInstance(this.name, this.code, this.versions);

  static TextGenerationModelInstance? getInstance(String modelCode) {
    TextGenerationModelInstance? instance;

    for (final i in TextGenerationModelInstance.values) {
      if (i.code == modelCode) instance = i;
    }

    return instance;
  }
}

final class TextGenerationModelVersion {
  final String name;
  final String code;

  const TextGenerationModelVersion(this.name, this.code);
}

final class A<T extends TextGenerationModelInstance> {
  final T? cock = null;
}

final class TextGenerationModelEntity {
  final TextGenerationModelInstance instance;
  final TextGenerationModelVersion version;
  final String apiKey;

  const TextGenerationModelEntity({
    required this.instance,
    required this.version,
    required this.apiKey,
  });
}
