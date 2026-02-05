import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../exports.dart';

/// Manages a queue of API requests for offline-first functionality
///
/// Requests are kept in memory and processed when connectivity is available.
class ApiRequestQueue {
  static final ApiRequestQueue _instance = ApiRequestQueue._internal();
  factory ApiRequestQueue() => _instance;
  ApiRequestQueue._internal();

  final List<QueuedRequest> _queue = [];
  bool _isProcessing = false;
  bool _isPaused = false;
  final int _maxRetries = 3;

  /// Initialize the queue
  Future<void> initialize() async {
    // Queue is kept in memory only
    if (kDebugMode) {
      print('📦 API Request Queue initialized (memory only)');
    }
  }

  /// Add a request to the queue
  Future<void> enqueueRequest(QueuedRequest request) async {
    _queue.add(request);
    if (kDebugMode) {
      print('📋 Request enqueued: ${request.method} ${request.url}');
    }

    // Try to process immediately if not paused
    if (!_isPaused && !_isProcessing) {
      unawaited(_processQueue());
    }
  }

  /// Process all requests in the queue
  Future<void> _processQueue() async {
    if (_queue.isEmpty || _isPaused || _isProcessing) {
      return;
    }

    _isProcessing = true;

    while (_queue.isNotEmpty && !_isPaused) {
      final request = _queue.first;

      try {
        if (kDebugMode) {
          print(
            '🔄 Processing queued request: ${request.method} ${request.url}',
          );
        }

        // Execute the request using ApiService
        await _executeRequest(request);

        // Success - remove from queue
        _queue.removeAt(0);

        if (kDebugMode) {
          print('✅ Request completed: ${request.method} ${request.url}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Request failed: ${request.method} ${request.url} - $e');
        }

        // Check retry count
        if (request.retryCount >= _maxRetries) {
          if (kDebugMode) {
            print('⚠️ Max retries reached, removing request');
          }
          _queue.removeAt(0);
        } else {
          // Increment retry count and move to end of queue
          _queue.removeAt(0);
          _queue.add(request.copyWith(retryCount: request.retryCount + 1));

          // Wait a bit before retrying
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }

    _isProcessing = false;
  }

  /// Execute a single queued request
  Future<void> _executeRequest(QueuedRequest request) async {
    final method = _parseHttpMethod(request.method);

    await ApiService.request(
      url: request.url,
      method: method,
      isAuthenticated: request.isAuthenticated,
      queryParameters: request.queryParameters,
      data: request.data,
      headers: request.headers,
      fromJson: (data) => data, // Generic handler
    );
  }

  /// Parse string method to HttpMethod enum
  HttpMethod _parseHttpMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.get;
      case 'POST':
        return HttpMethod.post;
      case 'PUT':
        return HttpMethod.put;
      case 'DELETE':
        return HttpMethod.delete;
      case 'PATCH':
        return HttpMethod.patch;
      default:
        return HttpMethod.get;
    }
  }

  /// Pause queue processing
  void pause() {
    _isPaused = true;
    if (kDebugMode) {
      print('⏸️ Queue processing paused');
    }
  }

  /// Resume queue processing
  Future<void> resume() async {
    _isPaused = false;
    if (kDebugMode) {
      print('▶️ Queue processing resumed');
    }

    if (!_isProcessing && _queue.isNotEmpty) {
      unawaited(_processQueue());
    }
  }

  /// Clear all queued requests
  Future<void> clear() async {
    _queue.clear();
    if (kDebugMode) {
      print('🗑️ Queue cleared');
    }
  }

  /// Get current queue size
  int get queueSize => _queue.length;

  /// Check if queue is empty
  bool get isEmpty => _queue.isEmpty;
}
