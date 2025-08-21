part of 'base_view_bloc.dart';

sealed class BaseViewState {
  const BaseViewState();
}

final class BaseViewMain extends BaseViewState {
  final bool init;

  const BaseViewMain(this.init);
}

final class BaseViewBusy extends BaseViewState {
  const BaseViewBusy();
}
