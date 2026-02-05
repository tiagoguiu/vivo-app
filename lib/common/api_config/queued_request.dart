/// Model representing an API request that can be queued and replayed
class QueuedRequest {
  final String id;
  final String url;
  final String method; // 'GET', 'POST', 'PUT', 'DELETE', 'PATCH'
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? data;
  final Map<String, String>? headers;
  final bool isAuthenticated;
  final DateTime timestamp;
  final int retryCount;

  QueuedRequest({
    required this.id,
    required this.url,
    required this.method,
    this.queryParameters,
    this.data,
    this.headers,
    required this.isAuthenticated,
    required this.timestamp,
    this.retryCount = 0,
  });

  QueuedRequest copyWith({
    String? id,
    String? url,
    String? method,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    bool? isAuthenticated,
    DateTime? timestamp,
    int? retryCount,
  }) => QueuedRequest(
    id: id ?? this.id,
    url: url ?? this.url,
    method: method ?? this.method,
    queryParameters: queryParameters ?? this.queryParameters,
    data: data ?? this.data,
    headers: headers ?? this.headers,
    isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    timestamp: timestamp ?? this.timestamp,
    retryCount: retryCount ?? this.retryCount,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'method': method,
    'queryParameters': queryParameters,
    'data': data,
    'headers': headers,
    'isAuthenticated': isAuthenticated,
    'timestamp': timestamp.toIso8601String(),
    'retryCount': retryCount,
  };

  factory QueuedRequest.fromJson(Map<String, dynamic> json) => QueuedRequest(
    id: json['id'] as String,
    url: json['url'] as String,
    method: json['method'] as String,
    queryParameters: json['queryParameters'] != null
        ? Map<String, dynamic>.from(json['queryParameters'])
        : null,
    data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    headers: json['headers'] != null
        ? Map<String, String>.from(json['headers'])
        : null,
    isAuthenticated: json['isAuthenticated'] as bool,
    timestamp: DateTime.parse(json['timestamp'] as String),
    retryCount: json['retryCount'] as int? ?? 0,
  );
}
