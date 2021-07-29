
import 'package:lifecycle/enum/lifecycle.dart';

abstract class LifecycleSubscriber {
  final Lifecycle lifecycle;

  LifecycleSubscriber(this.lifecycle);

  void onSubscribe(Lifecycle lifecycle);

  void onUnsubscribe(Lifecycle lifecycle);

  void onEvent(Lifecycle lifecycle);

}

