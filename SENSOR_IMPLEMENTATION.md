# Sensor Implementation for iLike Dating App

## Overview

This document describes the implementation of two key sensors in the iLike dating app:

1. **Location Sensor** - For finding nearby matches and location-based features
2. **Accelerometer Sensor** - For gesture detection and motion-based interactions

## 🎯 Features Implemented

### 1. Location Sensor (`geolocator` package)

- **Real-time location tracking** with high accuracy
- **Permission handling** for location access
- **Distance calculation** between users
- **Nearby user detection** based on location
- **Location status indicators** in the UI

### 2. Accelerometer Sensor (`sensors_plus` package)

- **Device movement detection** for gesture recognition
- **Swipe gesture detection** for card interactions
- **Motion pattern analysis** for enhanced user experience
- **Real-time acceleration data** visualization

## 📁 File Structure

```
lib/
├── core/
│   ├── services/
│   │   └── sensor_service.dart          # Main sensor service
│   └── service_locator/
│       └── service_locator.dart         # Dependency injection
├── features/
│   ├── settings/
│   │   ├── settings_screen.dart         # Settings with sensor demo
│   │   └── sensor_demo_screen.dart      # Sensor demonstration UI
│   └── matches/
│       └── presentation/
│           └── pages/
│               └── explore_screen.dart   # Location integration
```

## 🔧 Implementation Details

### Sensor Service (`sensor_service.dart`)

The `SensorService` class provides a centralized interface for both sensors:

```dart
class SensorService {
  // Location tracking
  Future<void> startLocationTracking()
  Future<void> stopLocationTracking()
  double calculateDistance(Position position1, Position position2)

  // Accelerometer tracking
  Future<void> startAccelerometerTracking()
  Future<void> stopAccelerometerTracking()
  bool detectSwipeGesture(List<double> accelerations, double threshold)

  // Utility methods
  List<Map<String, dynamic>> getNearbyUsers(List<Map<String, dynamic>> allUsers)
}
```

### Key Features

#### Location Sensor

- **Permission Management**: Automatically requests location permissions
- **High Accuracy**: Uses `LocationAccuracy.high` for precise positioning
- **Distance Filter**: Updates every 10 meters to conserve battery
- **Error Handling**: Graceful fallback when location services are disabled
- **Real-time Updates**: Continuous location monitoring

#### Accelerometer Sensor

- **Movement Detection**: Calculates acceleration magnitude
- **Gesture Recognition**: Detects swipe-like movements
- **Pattern Analysis**: Tracks recent acceleration patterns
- **Threshold-based Detection**: Configurable sensitivity levels

## 🎨 UI Integration

### 1. Sensor Demo Screen

- **Interactive Controls**: Toggle switches for each sensor
- **Real-time Data Display**: Shows current sensor values
- **Visual Indicators**: Movement pattern visualization
- **Demo Features**: Nearby users and gesture detection

### 2. Explore Screen Integration

- **Location Status Indicator**: Shows location service status
- **Nearby Matching**: Uses location for better match suggestions
- **Permission Handling**: Graceful degradation when location is disabled

## 📱 Android Permissions

Added to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

## 🚀 Usage Examples

### Starting Location Tracking

```dart
final sensorService = SensorService();
await sensorService.startLocationTracking();
```

### Detecting Gestures

```dart
final hasGesture = sensorService.detectSwipeGesture(accelerations, 50.0);
```

### Finding Nearby Users

```dart
final nearbyUsers = sensorService.getNearbyUsers(allUsers);
```

## 🎯 Demo Features

### Location-based Features

1. **Nearby User Detection**: Find users within your area
2. **Distance Calculation**: Show distance to potential matches
3. **Location-based Filtering**: Prioritize nearby matches
4. **Proximity Alerts**: Notify when nearby users are online

### Motion-based Features

1. **Swipe Gesture Detection**: Enhanced card interactions
2. **Device Movement Recognition**: Motion-based app controls
3. **Gesture Pattern Analysis**: Learn user interaction patterns
4. **Accessibility Features**: Motion-based navigation

## 🔍 Testing

### Sensor Demo Screen

Access via: Settings → Sensor Demo

Features to test:

- ✅ Toggle location tracking on/off
- ✅ View real-time location data
- ✅ Find nearby users (demo)
- ✅ Toggle accelerometer tracking
- ✅ View acceleration data
- ✅ Detect gestures
- ✅ Visualize movement patterns

### Integration Testing

- ✅ Location status in explore screen
- ✅ Permission handling
- ✅ Error state management
- ✅ Battery optimization

## 📊 Performance Considerations

### Location Sensor

- **Battery Optimization**: 10-meter distance filter
- **Accuracy Balance**: High accuracy with reasonable battery usage
- **Background Handling**: Proper cleanup on app pause

### Accelerometer Sensor

- **Data Filtering**: Only process significant movements
- **Memory Management**: Limit stored acceleration data
- **CPU Optimization**: Efficient gesture detection algorithms

## 🔮 Future Enhancements

### Planned Features

1. **Gyroscope Integration**: For more precise gesture detection
2. **Compass Integration**: For direction-based features
3. **Proximity Sensor**: For device-to-device interactions
4. **Barometer**: For altitude-based matching
5. **Step Counter**: For activity-based matching

### Advanced Features

1. **Machine Learning**: Pattern recognition for better gesture detection
2. **Predictive Matching**: Location-based match suggestions
3. **Social Features**: Location-based events and meetups
4. **Safety Features**: Emergency location sharing

## 🛠️ Troubleshooting

### Common Issues

1. **Location Permission Denied**

   - Check app permissions in device settings
   - Ensure location services are enabled
   - Verify Android manifest permissions

2. **Accelerometer Not Working**

   - Check device compatibility
   - Verify sensor permissions
   - Test on physical device (not emulator)

3. **Battery Drain**
   - Adjust location update frequency
   - Implement proper sensor cleanup
   - Use background location sparingly

### Debug Information

- Location accuracy and status
- Accelerometer data patterns
- Permission status
- Error logs and stack traces

## 📚 Dependencies

```yaml
dependencies:
  geolocator: ^10.1.0 # Location services
  sensors_plus: ^4.0.2 # Accelerometer and other sensors
  permission_handler: ^11.0.1 # Permission management
```

## 🎉 Conclusion

The sensor implementation provides a solid foundation for location-based and motion-based features in the dating app. The modular design allows for easy extension and the comprehensive demo screen helps users understand and test the sensor capabilities.

The implementation follows Flutter best practices with proper error handling, permission management, and performance optimization.
