import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../exports.dart';

/// Service to monitor network connectivity and manage API request queue
///
/// Listens to connectivity changes and automatically pauses/resumes
/// the API request queue based on network availability.
class NetworkConnectivityService {
  static final NetworkConnectivityService _instance = NetworkConnectivityService._internal();
  factory NetworkConnectivityService() => _instance;
  NetworkConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final ApiRequestQueue _requestQueue = ApiRequestQueue();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isOnline = true;

  /// Get current online status
  bool get isOnline => _isOnline;

  /// Initialize the service and start listening to connectivity changes
  Future<void> initialize() async {
    // Check initial connectivity
    final List<ConnectivityResult> result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // Initialize the request queue
    await _requestQueue.initialize();

    if (kDebugMode) {
      print('🌐 Network Connectivity Service initialized');
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final bool wasOnline = _isOnline;

    // Consider online if any connection type is available (except none)
    _isOnline = results.any((result) => result != ConnectivityResult.none);

    if (kDebugMode) {
      print('🌐 Connectivity changed: ${_isOnline ? "ONLINE" : "OFFLINE"}');
      print('   Connection types: ${results.map((r) => r.name).join(", ")}');
    }

    // Handle queue based on connectivity
    if (_isOnline && !wasOnline) {
      _onConnectionRestored();
    } else if (!_isOnline && wasOnline) {
      _onConnectionLost();
    }
  }

  /// Called when connection is restored
  void _onConnectionRestored() {
    if (kDebugMode) {
      print('✅ Connection restored - resuming queue (${_requestQueue.queueSize} requests)');
    }
    _requestQueue.resume();
  }

  /// Called when connection is lost
  void _onConnectionLost() {
    if (kDebugMode) {
      print('❌ Connection lost - pausing queue');
    }
    _requestQueue.pause();
  }

  /// Manually trigger queue processing (useful for testing)
  Future<void> processQueue() async {
    if (_isOnline) {
      await _requestQueue.resume();
    }
  }

  /// Dispose the service
  void dispose() {
    _connectivitySubscription?.cancel();
    if (kDebugMode) {
      print('🌐 Network Connectivity Service disposed');
    }
  }
}
