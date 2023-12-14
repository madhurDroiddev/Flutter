abstract class BaseBloc<VS>{
  late VS viewState;
  late Stream<VS> viewStateStream;
  late StreamSink<VS> viewStateSink;
  late StreamSubscription<VS> viewStateSubscription;
  late StreamController<VS> viewStateController;

  dispose();

  VS get initialViewState;

  BaseBloc(){
    viewState = initialViewState;
    viewStateController = StreamController.broadcast();
    viewStateStream = viewStateController.stream;
    viewStateSink = viewStateController.sink;
    viewStateSubscription = viewStateStream.listen((event) {});
  }
  
  dispatchViewState(VS viewState) {
    viewStateSink.add(viewState);
  }
}
