import 'dart:async';
import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  // Location sensor
  StreamSubscription<Position>? _locationSubscription;
  Position? _currentPosition;
  bool _isLocationEnabled = false;

  // Accelerometer sensor
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  bool _isAccelerometerEnabled = false;

  // Getters
  Position? get currentPosition => _currentPosition;
  bool get isLocationEnabled => _isLocationEnabled;
  bool get isAccelerometerEnabled => _isAccelerometerEnabled;
  StreamSubscription<Position>? get locationSubscription =>
      _locationSubscription;
  StreamSubscription<AccelerometerEvent>? get accelerometerSubscription =>
      _accelerometerSubscription;

  // Location sensor methods
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<void> startLocationTracking() async {
    try {
      // Check permissions
      final hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission not granted');
      }

      // Check if location service is enabled
      final isEnabled = await isLocationServiceEnabled();
      if (!isEnabled) {
        throw Exception('Location service is disabled');
      }

      // Get current position first
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Start continuous location updates
      _locationSubscription = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Update every 10 meters
        ),
      ).listen(
        (Position position) {
          _currentPosition = position;
          _isLocationEnabled = true;
        },
        onError: (error) {
          print('Location tracking error: $error');
          _isLocationEnabled = false;
        },
      );
    } catch (e) {
      print('Error starting location tracking: $e');
      _isLocationEnabled = false;
      rethrow;
    }
  }

  Future<void> stopLocationTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _isLocationEnabled = false;
  }

  // Calculate distance between two positions
  double calculateDistance(Position position1, Position position2) {
    return Geolocator.distanceBetween(
      position1.latitude,
      position1.longitude,
      position2.latitude,
      position2.longitude,
    );
  }

  // Accelerometer sensor methods
  Future<void> startAccelerometerTracking() async {
    try {
      _accelerometerSubscription = accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _isAccelerometerEnabled = true;
          // Process accelerometer data
          _processAccelerometerData(event);
        },
        onError: (error) {
          print('Accelerometer error: $error');
          _isAccelerometerEnabled = false;
        },
      );
    } catch (e) {
      print('Error starting accelerometer tracking: $e');
      _isAccelerometerEnabled = false;
      rethrow;
    }
  }

  Future<void> stopAccelerometerTracking() async {
    await _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _isAccelerometerEnabled = false;
  }

  void _processAccelerometerData(AccelerometerEvent event) {
    // Calculate magnitude of acceleration
    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );

    // Detect significant movement (can be used for gesture detection)
    if (magnitude > 15.0) {
      // Significant movement detected
      print('Significant movement detected: $magnitude');
    }
  }

  // Gesture detection for swipe-like interactions
  bool detectSwipeGesture(List<double> accelerations, double threshold) {
    if (accelerations.length < 3) return false;

    // Simple swipe detection based on acceleration patterns
    double totalAcceleration = 0;
    for (double acc in accelerations) {
      totalAcceleration += acc.abs();
    }

    return totalAcceleration > threshold;
  }

  // Get nearby users based on location (demo function)
  List<Map<String, dynamic>> getNearbyUsers(
      List<Map<String, dynamic>> allUsers) {
    if (_currentPosition == null) return [];

    return allUsers.where((user) {
      if (user['location'] == null) return false;

      // Calculate distance (simplified for demo)
      // In real app, you'd use actual coordinates from user profiles
      final userLocation = user['location'] as String;
      if (userLocation.contains('Kathmandu')) {
        return true; // Consider users in same city as nearby
      }
      return false;
    }).toList();
  }

  // Dispose all subscriptions
  void dispose() {
    _locationSubscription?.cancel();
    _accelerometerSubscription?.cancel();
  }
}
