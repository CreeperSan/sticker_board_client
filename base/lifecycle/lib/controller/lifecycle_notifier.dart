
import 'package:lifecycle/enum/lifecycle.dart';
import 'package:lifecycle/subscriber/lifecycle_subscriber.dart';

class LifecycleNotifier {

  LifecycleNotifier._();

  static LifecycleNotifier instance = LifecycleNotifier._();



  Map<Lifecycle, Set<LifecycleSubscriber>> _data = {};

  void fire(Lifecycle lifecycle){
    _data[lifecycle]?.forEach((element) {
      element.onEvent(lifecycle);
    });
  }

  void subscribe(LifecycleSubscriber subscriber){
    final lifecycle = subscriber.lifecycle;
    if(!_data.containsKey(lifecycle)){
      _data[lifecycle] = {subscriber};
    } else {
      _data[lifecycle]?.add(subscriber);
    }

    subscriber.onSubscribe(lifecycle);
  }

  void unsubscribe(LifecycleSubscriber subscriber){
    final lifecycle = subscriber.lifecycle;
    _data[lifecycle]?.remove(subscriber);

    subscriber.onUnsubscribe(lifecycle);
  }

}
