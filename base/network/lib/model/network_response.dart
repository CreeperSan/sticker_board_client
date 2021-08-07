
class NetworkResponse<T>{
  int code;
  String message;
  T? data;

  NetworkResponse({
    required this.code,
    required this.message,
    this.data,
  });

  NetworkResponse.networkError({
    this.code = -1,
    this.message = 'Network Error',
  });

  NetworkResponse.xception(this.message, {
    this.code = -2,
    // this.message = 'Network Error',
  });

  bool isSuccess() => 200 == code;

}

