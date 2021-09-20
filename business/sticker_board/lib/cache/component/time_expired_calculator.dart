
class TimeExpiredCalculator {
  int _lastFetchTime = 0;
  final int expiredTime;

  TimeExpiredCalculator(this.expiredTime);

  bool isExpired(){
    final currentTime = _currentTimestampMillisecond();
    return currentTime - _lastFetchTime >= expiredTime;
  }

  void updateFetchTime(){
    _lastFetchTime = _currentTimestampMillisecond();
  }

  int _currentTimestampMillisecond() => DateTime.now().millisecondsSinceEpoch;

}
