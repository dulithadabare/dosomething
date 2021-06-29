class ApiResponse<T> {
  ApiResponseStatus? status;
  String? message;
  T? data;

  ApiResponse({this.status, this.message, this.data});

  factory ApiResponse.loading(message) => ApiResponse( status: ApiResponseStatus.LOADING, message: message);
  factory ApiResponse.completed(message, data) => ApiResponse( status: ApiResponseStatus.COMPLETED, message: message, data: data);
  factory ApiResponse.error(message) => ApiResponse( status: ApiResponseStatus.ERROR, message: message);
}

enum ApiResponseStatus {
  LOADING, COMPLETED, ERROR
}