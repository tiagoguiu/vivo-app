import 'api_error.dart';

class ApiResponse<T> {
  ///DATA EQUALS NULL MEANS THAT RESPONSE HAS ERROR, CAN SHOE MESSAGE OR JUST SHOW SNACKBAR
  final T? data;
  final int? statusCode;
  final ApiError? errorData;

  ApiResponse({this.data, this.statusCode, this.errorData});
}
