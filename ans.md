# iLike Dating App - Technical Documentation

## 1. App Features & Background

### Main Features

- **Profile Management**: Complete user profiles with photos, bio, interests, and preferences
- **Matching System**: Swipe-based matching with like/dislike functionality
- **Real-time Messaging**: Chat system with typing indicators and message status
- **Location-based Matching**: GPS-enabled nearby user discovery
- **Sensor Integration**: Accelerometer for gesture detection and enhanced interactions
- **Settings & Preferences**: User customization and privacy controls

### Differentiation from Existing Apps

- **Nepali Cultural Integration**: Localized content, names, and cultural elements
- **Advanced Sensor Features**: Motion-based interactions and gesture recognition
- **Enhanced Location Services**: Precise location tracking for better matching
- **Comprehensive Demo System**: Full-featured demo with realistic data for testing
- **Modern UI/UX**: Tinder-style interface with custom animations and interactions

### Target Audience

- **Primary**: Young professionals in Nepal (ages 20-35)
- **Secondary**: International users interested in Nepali culture
- **Focus**: Urban areas like Kathmandu, Pokhara, Lalitpur with location-based features

## 2. Technical Architecture

### Design Pattern

**BLoC (Business Logic Component) Pattern**

- Separation of business logic from UI
- Reactive state management
- Event-driven architecture
- Clean separation of concerns

### Architectural Pattern

**Clean Architecture with Feature-based Organization**

```
lib/
├── core/                    # Shared utilities and services
│   ├── network/            # API services and networking
│   ├── services/           # Sensor services, etc.
│   └── service_locator/    # Dependency injection
├── features/               # Feature-based modules
│   ├── auth/              # Authentication
│   ├── profile/           # User profiles
│   ├── matches/           # Matching system
│   ├── chat/              # Messaging
│   └── settings/          # App settings
└── shared/                # Shared widgets and utilities
```

### Architectural Layers

1. **Presentation Layer**: UI components and BLoC widgets
2. **Business Logic Layer**: Use cases and BLoC logic
3. **Data Layer**: Repositories and data sources
4. **Domain Layer**: Entities and repository interfaces

## 3. State Management

### Primary Solution: **flutter_bloc**

- **AuthBloc**: Handles authentication state (login, logout, user session)
- **ProfileBloc**: Manages user profile data and updates
- **MatchBloc**: Controls matching functionality and potential matches
- **ChatBloc**: Manages chat conversations and messages
- **OnboardingBloc**: Handles user onboarding flow

### State Management Benefits

- **Predictable State Changes**: Event-driven state updates
- **Testability**: Easy unit testing with bloc_test
- **Reactive UI**: Automatic UI updates based on state changes
- **Separation of Concerns**: Clear separation between UI and business logic

## 4. APIs & Sensors

### 3rd Party APIs

- **Dio**: HTTP client for REST API communication
- **Socket.io**: Real-time messaging and notifications
- **Image Picker**: Photo selection and upload
- **Audio Players**: Sound effects and notifications
- **Lottie**: Animated UI elements

### Sensor Integration

**Two Primary Sensors Implemented:**

#### 1. Location Sensor (geolocator)

- **Real-time GPS tracking** with high accuracy
- **Permission handling** for location access
- **Distance calculation** between users
- **Nearby user detection** based on location
- **Location status indicators** in UI

#### 2. Accelerometer Sensor (sensors_plus)

- **Device movement detection** for gesture recognition
- **Swipe gesture detection** for card interactions
- **Motion pattern analysis** for enhanced UX
- **Real-time acceleration data** visualization

### Sensor Features

- **Location-based Matching**: Find users within geographic proximity
- **Gesture Recognition**: Enhanced swipe interactions
- **Motion Controls**: Device movement for app interactions
- **Proximity Alerts**: Notify when nearby users are online

## 5. Data & Security

### Data Types Stored

- **User Profiles**: Personal info, photos, bio, interests, preferences
- **Authentication Data**: Tokens, user sessions, login credentials
- **Match Data**: Likes, dislikes, matches, conversation history
- **Chat Messages**: Real-time messages, timestamps, read status
- **Location Data**: GPS coordinates, location history
- **App Settings**: User preferences, privacy settings

### Data Storage Strategy

- **Local Storage**: Hive database for offline access
- **Remote Storage**: MongoDB backend with REST APIs
- **Caching**: SharedPreferences for quick access to user data
- **Real-time Sync**: Socket.io for live updates

### Security Measures

- **Token-based Authentication**: JWT tokens for API security
- **Permission Handling**: Granular location and sensor permissions
- **Data Encryption**: Secure storage of sensitive information
- **Input Validation**: Server-side and client-side validation
- **HTTPS Communication**: Secure API endpoints

## 6. Cloud Computing & Big Data

### Current Cloud Services

- **MongoDB Atlas**: Database hosting and management
- **Node.js Backend**: RESTful API services
- **Socket.io Server**: Real-time communication
- **Image Storage**: Cloud-based photo storage

### Scaling Strategy

#### Short-term (Current Implementation)

- **Vertical Scaling**: Upgrade server resources
- **Database Optimization**: Indexing and query optimization
- **CDN Integration**: Fast content delivery
- **Load Balancing**: Distribute traffic across servers

#### Long-term (Future Plans)

- **Microservices Architecture**: Break down monolithic backend
- **Containerization**: Docker and Kubernetes deployment
- **Auto-scaling**: Cloud-based resource management
- **Big Data Analytics**: User behavior analysis and insights

### Big Data Implementation Plans

#### Data Collection

- **User Behavior Analytics**: Swipe patterns, messaging frequency
- **Location Analytics**: Geographic matching patterns
- **Performance Metrics**: App usage, engagement rates
- **Sensor Data**: Motion patterns and gesture preferences

#### Analytics & Insights

- **Matching Algorithm Optimization**: ML-based compatibility scoring
- **User Segmentation**: Demographic and behavioral analysis
- **Predictive Analytics**: Match success prediction
- **Real-time Dashboards**: Live app performance monitoring

#### Infrastructure Scaling

- **AWS/Azure Integration**: Cloud-native deployment
- **Database Sharding**: Horizontal scaling for large datasets
- **Caching Layers**: Redis for high-performance data access
- **API Gateway**: Centralized request management

### Technical Stack Summary

#### Frontend (Flutter)

- **Framework**: Flutter 3.x with Dart
- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **Local Storage**: Hive + SharedPreferences
- **Networking**: Dio + Socket.io

#### Backend (Node.js)

- **Runtime**: Node.js with Express
- **Database**: MongoDB with Mongoose
- **Real-time**: Socket.io
- **Authentication**: JWT tokens
- **File Storage**: Cloud storage integration

#### DevOps & Infrastructure

- **Version Control**: Git with GitHub
- **CI/CD**: Automated testing and deployment
- **Monitoring**: Performance and error tracking
- **Security**: HTTPS, input validation, rate limiting

### Performance Optimization

- **Image Optimization**: Compressed photos and lazy loading
- **Network Caching**: Efficient API response caching
- **Memory Management**: Proper disposal of resources
- **Battery Optimization**: Sensor usage optimization
- **Offline Support**: Local data caching and sync

This comprehensive architecture provides a solid foundation for a scalable, secure, and feature-rich dating application with modern mobile development best practices.
