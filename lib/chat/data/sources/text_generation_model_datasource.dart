import 'dart:async';

import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:my_gpt_client/core/entities/text_generation_model_entity.dart';

import '/chat/data/models/chat_content_data_model.dart';
import '/chat/data/models/text_generation_api_data_models.dart';
import '/core/entities/chat_role.dart';

import 'text_generation_model_datasource_interface.dart';

abstract interface class ModelInterface {
  Future<void> init();
  Stream<TextGenerationResponseDataModel> generateText(
      TextGenerationRequestDataModel request);
}

final class TextGenerationModelDatasource
    implements TextGenerationModelDatasourceInterface {
  const TextGenerationModelDatasource();

  @override
  Future<void> init() async {
    // o.OpenAI.apiKey = "-";
    // (await o.OpenAI.instance.model.).forEach((element) {
    //   print(element.id);
    // });
  }

  @override
  Stream<TextGenerationResponseDataModel> generateText(
      TextGenerationRequestDataModel request) {
    return switch (request.model.instance) {
      TextGenerationModelInstance.chatGPT => ChatModel(
          ChatOpenAI(
            apiKey: request.model.apiKey,
            defaultOptions: ChatOpenAIOptions(
                model: request.model.version.code,
                temperature: request.temperature * 2),
          ),
        ).generateText(request),
      TextGenerationModelInstance.gemini => ChatModel(
          ChatGoogleGenerativeAI(
            apiKey: request.model.apiKey,
            defaultOptions: ChatGoogleGenerativeAIOptions(
              model: request.model.version.code,
              temperature: request.temperature,
            ),
          ),
        ).generateText(request),
    };
  }
}

final class ChatModel implements ModelInterface {
  final BaseChatModel llm;

  const ChatModel(this.llm);

  @override
  Stream<TextGenerationResponseDataModel> generateText(
      TextGenerationRequestDataModel request) {
    final promptTemplate = ChatPromptTemplate.fromPromptMessages([
      const MessagesPlaceholder(variableName: 'context'),
      ChatMessagePromptTemplate.human('{message}'),
    ]);

    final chain = Runnable.fromMap({
          'message': Runnable.passthrough(),
          'context': Runnable.fromFunction(
            (_, __) {
              final list = (request.context != null)
                  ? request.context!.map((e) => _messageFromModel(e)).toList()
                  : [];

              if (llm is ChatGoogleGenerativeAI) {
                // Gemini ahh moment - you can't pass a conversation that starts with an ai message

                if (list.firstOrNull is AIChatMessage) {
                  list.removeAt(0);
                }
              }

              return list;
            },
          ),
        }) |
        promptTemplate |
        llm;

    return chain.stream(request.prompt).map((e) {
      final result = e as ChatResult;

      return TextGenerationResponseDataModel(
        chunk: result.outputAsString,
      );
    });
  }

  @override
  Future<void> init() async {}

  ChatMessage _messageFromModel(ChatMessageDataModel model) {
    return switch (model.role) {
      ChatRole.user =>
        ChatMessage.human(ChatMessageContentText(text: model.message)),
      ChatRole.model => ChatMessage.ai(model.message),
      ChatRole.system => ChatMessage.system(model.message),
    };
  }
}
