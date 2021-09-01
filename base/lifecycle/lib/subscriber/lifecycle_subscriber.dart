
import 'package:lifecycle/enum/lifecycle.dart';

class LifecycleSubscriber {
  final Lifecycle lifecycle;

  LifecycleSubscriber(this.lifecycle ,{
    this.onSubscribe,
    this.onUnsubscribe,
    this.onEvent,
  });

  void Function(Lifecycle lifecycle)? onSubscribe;

  void Function(Lifecycle lifecycle)? onUnsubscribe;

  void Function(Lifecycle lifecycle)? onEvent;

}

