
class NetworkResponse<T>{
  int code;
  String message;
  T? data;

  NetworkResponse({
    required this.code,
    required this.message,
    this.data,
  });

}

