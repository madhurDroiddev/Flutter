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


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pag_demo/core/base_bloc.dart';

abstract class BaseBlocState<T extends StatefulWidget, B extends BaseBloc, VS,
    E> extends State<T> {
  late B bloc;
  late VS viewState;
  late StreamSubscription _eventsSubscription;

  VS get initialViewState;

  B get initializeBloc;

  @override
  void initState() {
    super.initState();

    viewState = initialViewState;
    bloc = initializeBloc;
    _subscribe();
  }

  void _subscribe() {
    _eventsSubscription = (bloc.eventController.stream as Stream<E>)
        .distinct()
        .listen(listenEvents);
  }

  void listenEvents(E event);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VS>(
        stream: (bloc.viewStateStream as Stream<VS>).distinct(),
        builder: (buildContext, snapshot) {
          viewState = snapshot.data!;
          return buildViewState(viewState, context);
        });
  }

  Widget buildViewState(VS viewState, BuildContext context);
}

