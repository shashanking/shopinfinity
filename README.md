# Shop Infinity

A modern e-commerce mobile application built with Flutter.

## Features

### Authentication
- Phone number-based OTP authentication
- Secure token management
- Personal details collection

### Product Management
- Browse products by categories
- Search products
- View product details with variants
- Product image gallery
- Add to cart functionality

### Shopping Cart
- Add/remove products
- Update quantities
- View cart summary
- Minimum order amount validation (₹799)
- Real-time price calculations

### Order Management
- Place orders with cash on delivery
- Order success confirmation
- View order history
- Order details with delivery status

### Address Management
- Add multiple delivery addresses
- Set primary address
- Edit/delete addresses
- Address validation

### User Profile
- View and edit profile details
- Manage addresses
- View order history

### Navigation
- Bottom navigation bar
- Smooth transitions
- Go Router integration
- Deep linking support

### UI/UX Features
- Modern Material Design 3
- Responsive layouts
- Loading animations
- Error handling with user feedback
- Pull-to-refresh
- Infinite scrolling
- Smooth animations

## Architecture

### State Management
- Riverpod for state management
- AsyncValue for handling loading/error states
- Provider-based dependency injection

### Navigation
- Go Router for declarative routing
- Deep linking support
- Navigation state management

### Network
- Dio for HTTP requests
- RESTful API integration
- Token-based authentication
- Error handling and retry logic

### Local Storage
- Secure storage for tokens
- Cached network images
- Local state persistence

### Code Organization
- Feature-first architecture
- Clean separation of concerns
- Reusable widgets and utilities
- Consistent naming conventions

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

- flutter_riverpod: State management
- go_router: Navigation
- dio: HTTP client
- flutter_secure_storage: Secure storage
- cached_network_image: Image caching
- json_annotation: JSON serialization

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
