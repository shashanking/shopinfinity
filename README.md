# Shop Infinity - Your Ultimate Shopping Companion

Shop Infinity is a modern e-commerce mobile application built with Flutter, offering a seamless shopping experience with a beautiful UI and robust features.

## Features

### 1. Product Categories
- Dynamic category loading from API
- Hierarchical category structure (Root > Sub-categories)
- Efficient caching of category images
- Real-time category updates
- Smooth category navigation

### 2. Product Management
- Browse products by category
- Dynamic product loading with pagination
- Advanced product filtering
- Product variants support
- Real-time stock updates
- Product image caching for better performance

### 3. Shopping Cart & Checkout
- Cart management with real-time updates
- Multiple delivery address support
- Order placement with confirmation
- Order history tracking
- Payment integration

### 4. User Authentication
- OTP-based authentication
- Secure token management
- User profile management
- Address management

## Technical Details

### Architecture
- Feature-based architecture for better code organization
- Clean separation of concerns (UI, Business Logic, Data)
- State management using Riverpod
- Navigation using GoRouter
- Async state handling with AsyncValue

### API Integration
- RESTful API integration with Dio
- Cached network images for better performance
- Proper error handling and retry mechanisms
- Loading state management
- Response caching and optimization

### State Management
- Riverpod for state management
- AsyncNotifierProvider for API calls
- StateNotifierProvider for complex state
- Provider family for parameterized state
- Proper state restoration

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.9
  go_router: ^12.1.3
  dio: ^5.4.0
  cached_network_image: ^3.3.0
  hive: ^2.2.3
  json_annotation: ^4.8.1
  freezed_annotation: ^2.4.1
  flutter_staggered_grid_view: ^0.7.0

dev_dependencies:
  build_runner: ^2.4.7
  freezed: ^2.4.6
  json_serializable: ^6.7.1
```

## Getting Started

1. Clone the repository
```bash
git clone https://github.com/yourusername/shopinfinity.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

## Development Guidelines

### 1. Code Organization
- Feature-based folder structure
- Separate models, providers, and screens
- Reusable widgets in shared folder
- Clear separation of concerns

### 2. State Management
- Use Riverpod for all state management
- Create separate providers for different features
- Handle loading and error states with AsyncValue
- Use StateNotifier for complex state
- Implement proper state restoration

### 3. API Integration
- Proper error handling with try-catch
- Show loading indicators during API calls
- Cache network responses appropriately
- Use CachedNetworkImage for images
- Implement retry mechanisms

### 4. UI/UX
- Follow material design guidelines
- Maintain consistent spacing and typography
- Support both light and dark themes
- Implement proper loading states
- Handle error states gracefully

### 5. Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Use proper mocking for API calls
- Maintain good test coverage

## Project Structure
```
lib/
├── core/
│   ├── models/
│   ├── providers/
│   └── services/
├── presentation/
│   ├── features/
│   │   ├── categories/
│   │   ├── products/
│   │   ├── cart/
│   │   └── profile/
│   └── shared/
│       ├── widgets/
│       └── constants/
└── main.dart
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
