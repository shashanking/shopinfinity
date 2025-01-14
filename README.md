# Shop Infinity

A modern e-commerce mobile application built with Flutter.

## Features

### Authentication
- Phone number-based OTP authentication
- Secure token management
- Personal details collection

### Product Management
- Browse products by categories and subcategories
- Search products with real-time suggestions
- View product details with variants
- Product image gallery with zoom support
- Add to cart functionality
- Exclusive and best-selling products sections

### Shopping Cart
- Add/remove products
- Update quantities
- View cart summary
- Minimum order amount validation (₹799)
- Real-time price calculations
- Smooth checkout process

### Order Management
- Place orders with cash on delivery
- Order success confirmation
- View order history with details
- Track order status
- Order cancellation
- View delivery address and order items

### Category Navigation
- Browse by main categories
- Dynamic subcategories
- Category-specific product listings
- Quick access to popular categories
- Category-wise product filtering

### Address Management
- Add multiple delivery addresses
- Set primary address
- Edit/delete addresses
- Address validation
- Location-based services

### User Profile
- View and edit profile details
- Manage addresses
- View order history
- Account settings
- Privacy preferences

### Navigation
- Bottom navigation bar
- Smooth transitions
- Go Router integration
- Deep linking support
- Category-specific routing

### UI/UX Features
- Modern Material Design 3
- Responsive layouts
- Loading animations
- Error handling with user feedback
- Pull-to-refresh
- Infinite scrolling
- Smooth animations
- Cached image loading
- Skeleton loading states
- Custom error pages

## Architecture

### State Management
- Riverpod for state management
- AsyncValue for handling loading/error states
- Provider-based dependency injection
- State persistence

### Navigation
- Go Router for declarative routing
- Deep linking support
- Navigation state management
- Route guards

### Network
- Dio for HTTP requests
- RESTful API integration
- Token-based authentication
- Error handling and retry logic
- Request caching
- Offline support

### Local Storage
- Secure storage for tokens
- Cached network images
- Local state persistence
- User preferences storage

### Code Organization
- Feature-first architecture
- Clean separation of concerns
- Reusable widgets and utilities
- Consistent naming conventions
- SOLID principles
- Dependency injection

## Getting Started

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- flutter_riverpod: ^2.4.9
- go_router: ^13.0.0
- dio: ^5.4.0
- cached_network_image: ^3.3.0
- flutter_secure_storage: ^9.0.0
- json_annotation: ^4.8.1
- freezed_annotation: ^2.4.1

## Development Tools

- Flutter: 3.16.5
- Dart: 3.2.3
- VS Code / Android Studio
- Flutter DevTools
- Git for version control

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
