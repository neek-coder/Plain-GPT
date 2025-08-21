part of 'base_view_bloc.dart';

sealed class BaseViewEvent {
  const BaseViewEvent();
}

final class BaseViewWait extends BaseViewEvent {
  const BaseViewWait();
}

final class BaseViewComplete extends BaseViewEvent {
  const BaseViewComplete();
}
