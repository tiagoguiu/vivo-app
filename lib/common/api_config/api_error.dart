class ApiError {
  ApiError({this.message});

  final String? message;

  factory ApiError.fromJson(Map<String, dynamic> json) {
    final message = _extractMessage(json);
    return ApiError(message: message);
  }

  static String? _extractMessage(Map<String, dynamic> json) {
    // Check for "erro" wrapper first
    final erro = json['erro'];
    if (erro is Map<String, dynamic>) {
      final erroMessage = erro['message'];
      if (erroMessage is String && erroMessage.isNotEmpty) {
        return erroMessage;
      }
    }

    // Check for direct message fields
    final directMessage = json['message'] ?? json['msg'] ?? json['error'];
    if (directMessage is String && directMessage.isNotEmpty) {
      return directMessage;
    }

    // Check for errors array
    final errors = json['errors'];
    if (errors is List) {
      for (final item in errors) {
        if (item is String && item.isNotEmpty) {
          return item;
        }
        if (item is Map<String, dynamic>) {
          final msg = item['msg'] ?? item['message'] ?? item['detail'];
          if (msg is String && msg.isNotEmpty) {
            return msg;
          }
        }
      }
    }

    return null;
  }
}
