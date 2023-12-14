import 'dart:async';

import 'base_repo.dart';

abstract class BaseBloc<VS, E> {
  VS viewState;
  late Stream<VS> viewStateStream;
  late StreamSink<VS> viewStateSink;
  late StreamSubscription<VS> viewStateSubscription;
  late StreamController<VS> viewStateController;
  late StreamController<E> eventController;

  dispose();

  BaseBloc(this.viewState) {
    viewStateController = StreamController.broadcast();
    viewStateStream = viewStateController.stream;
    viewStateSink = viewStateController.sink;
    dispatchViewState(viewState);
    viewStateSubscription = viewStateStream.listen((event) {});
  }

  dispatchViewState(VS viewState) {
    this.viewState = viewState;
    viewStateSink.add(viewState);
  }

  dispatchEvent(E event) {
    eventController.sink.add(event);
  }
}
