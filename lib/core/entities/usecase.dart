import 'dart:async';

abstract interface class UseCase<Type, Request> {
  FutureOr<Type> call(Request params);
}
