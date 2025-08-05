import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ilike/core/services/sensor_service.dart';
import 'package:geolocator/geolocator.dart';

class SensorDemoScreen extends StatefulWidget {
  const SensorDemoScreen({super.key});

  @override
  State<SensorDemoScreen> createState() => _SensorDemoScreenState();
}

class _SensorDemoScreenState extends State<SensorDemoScreen> {
  final SensorService _sensorService = SensorService();
  bool _isLocationTracking = false;
  bool _isAccelerometerTracking = false;
  Position? _currentPosition;
  String _accelerometerData = 'No data';
  List<double> _recentAccelerations = [];

  @override
  void initState() {
    super.initState();
    _initializeSensors();
  }

  Future<void> _initializeSensors() async {
    // Check location permission and service
    final hasPermission = await _sensorService.requestLocationPermission();
    final isLocationEnabled = await _sensorService.isLocationServiceEnabled();

    if (mounted) {
      setState(() {
        if (hasPermission && isLocationEnabled) {
          _startLocationTracking();
        }
      });
    }
  }

  Future<void> _startLocationTracking() async {
    try {
      await _sensorService.startLocationTracking();
      setState(() {
        _isLocationTracking = true;
        _currentPosition = _sensorService.currentPosition;
      });

      // Listen for position updates
      _sensorService.locationSubscription?.onData((position) {
        if (mounted) {
          setState(() {
            _currentPosition = position;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location error: $e')),
        );
      }
    }
  }

  Future<void> _startAccelerometerTracking() async {
    try {
      await _sensorService.startAccelerometerTracking();
      setState(() {
        _isAccelerometerTracking = true;
      });

      // Listen for accelerometer updates
      _sensorService.accelerometerSubscription?.onData((event) {
        if (mounted) {
          setState(() {
            final magnitude = _calculateMagnitude(event.x, event.y, event.z);
            _recentAccelerations.add(magnitude);

            // Keep only last 10 readings
            if (_recentAccelerations.length > 10) {
              _recentAccelerations.removeAt(0);
            }

            _accelerometerData = 'X: ${event.x.toStringAsFixed(2)}\n'
                'Y: ${event.y.toStringAsFixed(2)}\n'
                'Z: ${event.z.toStringAsFixed(2)}\n'
                'Magnitude: ${magnitude.toStringAsFixed(2)}';
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Accelerometer error: $e')),
        );
      }
    }
  }

  double _calculateMagnitude(double x, double y, double z) {
    return sqrt(x * x + y * y + z * z);
  }

  Future<void> _stopLocationTracking() async {
    await _sensorService.stopLocationTracking();
    setState(() {
      _isLocationTracking = false;
    });
  }

  Future<void> _stopAccelerometerTracking() async {
    await _sensorService.stopAccelerometerTracking();
    setState(() {
      _isAccelerometerTracking = false;
    });
  }

  @override
  void dispose() {
    _sensorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Demo'),
        backgroundColor: Colors.pink[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Sensor Section
            _buildSensorCard(
              title: '📍 Location Sensor',
              subtitle: 'Track your current location for nearby matches',
              isActive: _isLocationTracking,
              onToggle: _isLocationTracking
                  ? _stopLocationTracking
                  : _startLocationTracking,
              child: _buildLocationContent(),
            ),

            const SizedBox(height: 20),

            // Accelerometer Sensor Section
            _buildSensorCard(
              title: '📱 Accelerometer Sensor',
              subtitle: 'Detect device movement for gesture interactions',
              isActive: _isAccelerometerTracking,
              onToggle: _isAccelerometerTracking
                  ? _stopAccelerometerTracking
                  : _startAccelerometerTracking,
              child: _buildAccelerometerContent(),
            ),

            const SizedBox(height: 20),

            // Demo Features Section
            _buildDemoFeaturesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard({
    required String title,
    required String subtitle,
    required bool isActive,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: isActive,
                  onChanged: (value) => onToggle(),
                  activeColor: Colors.pink,
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildLocationContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_currentPosition != null) ...[
          _buildInfoRow(
              'Latitude', _currentPosition!.latitude.toStringAsFixed(6)),
          _buildInfoRow(
              'Longitude', _currentPosition!.longitude.toStringAsFixed(6)),
          _buildInfoRow(
              'Accuracy', '${_currentPosition!.accuracy.toStringAsFixed(1)}m'),
          _buildInfoRow(
              'Altitude', '${_currentPosition!.altitude.toStringAsFixed(1)}m'),
          _buildInfoRow(
              'Speed', '${_currentPosition!.speed.toStringAsFixed(1)}m/s'),
        ] else ...[
          const Text(
            'Location data will appear here when tracking is enabled',
            style: TextStyle(color: Colors.grey),
          ),
        ],
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _currentPosition != null ? () => _showNearbyUsers() : null,
          icon: const Icon(Icons.people),
          label: const Text('Find Nearby Users'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[100],
            foregroundColor: Colors.pink[900],
          ),
        ),
      ],
    );
  }

  Widget _buildAccelerometerContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _accelerometerData,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        const SizedBox(height: 12),
        if (_recentAccelerations.isNotEmpty) ...[
          const Text(
            'Recent Movement Pattern:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recentAccelerations.length,
              itemBuilder: (context, index) {
                final acceleration = _recentAccelerations[index];
                final intensity = (acceleration / 20.0).clamp(0.0, 1.0);
                return Container(
                  width: 20,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(intensity),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _isAccelerometerTracking ? () => _detectGesture() : null,
          icon: const Icon(Icons.gesture),
          label: const Text('Detect Gesture'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[100],
            foregroundColor: Colors.pink[900],
          ),
        ),
      ],
    );
  }

  Widget _buildDemoFeaturesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎯 Demo Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              '📍 Location-based matching',
              'Find users within your area',
              Icons.location_on,
            ),
            _buildFeatureItem(
              '📱 Gesture detection',
              'Swipe gestures for card interactions',
              Icons.touch_app,
            ),
            _buildFeatureItem(
              '🎮 Motion controls',
              'Device movement for app interactions',
              Icons.smartphone,
            ),
            _buildFeatureItem(
              '🔍 Proximity alerts',
              'Get notified when nearby users are online',
              Icons.notifications,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.pink[400], size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  void _showNearbyUsers() {
    // Demo nearby users based on location
    final demoUsers = [
      {'name': 'Priya Thapa', 'distance': '0.5 km', 'location': 'Thamel'},
      {'name': 'Rajesh Gurung', 'distance': '1.2 km', 'location': 'Baneshwor'},
      {'name': 'Sita Tamang', 'distance': '2.1 km', 'location': 'Patan'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nearby Users'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: demoUsers
              .map((user) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink[100],
                      child: Text(user['name']![0]),
                    ),
                    title: Text(user['name']!),
                    subtitle:
                        Text('${user['distance']} away in ${user['location']}'),
                  ))
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _detectGesture() {
    if (_recentAccelerations.isEmpty) return;

    final avgAcceleration = _recentAccelerations.reduce((a, b) => a + b) /
        _recentAccelerations.length;
    final hasGesture =
        _sensorService.detectSwipeGesture(_recentAccelerations, 50.0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gesture Detection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Average acceleration: ${avgAcceleration.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              hasGesture
                  ? '✅ Swipe gesture detected!'
                  : '❌ No significant gesture',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: hasGesture ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
