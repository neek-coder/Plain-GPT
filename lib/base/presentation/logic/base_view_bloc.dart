import 'package:bloc/bloc.dart';

part 'base_view_event.dart';
part 'base_view_state.dart';

class BaseViewBloc extends Bloc<BaseViewEvent, BaseViewState> {
  BaseViewBloc() : super(const BaseViewMain(true)) {
    on<BaseViewWait>((event, emit) {
      if (state is! BaseViewMain) return;

      emit(const BaseViewBusy());
    });

    on<BaseViewComplete>((event, emit) {
      if (state is! BaseViewBusy) return;

      emit(const BaseViewMain(false));
    });
  }

  void wait() => add(const BaseViewWait());
  void complete() => add(const BaseViewComplete());
}
