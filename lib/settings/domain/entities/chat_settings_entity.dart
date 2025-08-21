import 'dart:math' show max;

import 'package:equatable/equatable.dart';

sealed class ContextBuffer extends Equatable {
  List<T> apply<T>(List<T> content);

  const ContextBuffer();
}

sealed class FixedContextBuffer extends ContextBuffer {
  final int size;

  const FixedContextBuffer(this.size) : assert(size >= 0);

  @override
  List<T> apply<T>(List<T> content) {
    final l = content.length;

    return content.getRange(max(l - size, 0), l).toList();
  }

  @override
  List<Object?> get props => [size];

  @override
  bool? get stringify => true;
}

final class EmptyContextBuffer extends FixedContextBuffer {
  static const staticSize = 0;
  const EmptyContextBuffer() : super(staticSize);
}

final class SmallContextBuffer extends FixedContextBuffer {
  static const staticSize = 5;
  const SmallContextBuffer() : super(staticSize);
}

final class MediumContextBuffer extends FixedContextBuffer {
  static const staticSize = 10;

  const MediumContextBuffer() : super(staticSize);
}

final class LargeContextBuffer extends FixedContextBuffer {
  static const staticSize = 15;

  const LargeContextBuffer() : super(staticSize);
}

final class CustomContextBuffer extends FixedContextBuffer {
  static const maxSize = 1000;
  const CustomContextBuffer(super.size);
}

final class UnlimitedContextBuffer implements ContextBuffer {
  const UnlimitedContextBuffer() : super();

  @override
  List<T> apply<T>(List<T> content) => content;

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class ChatSettingsEntity {
  final ContextBuffer contextBuffer;
  final double temperature;

  const ChatSettingsEntity({
    required this.contextBuffer,
    required this.temperature,
  });
}
