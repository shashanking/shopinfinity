# Shop Infinity

Shop Infinity is a modern e-commerce mobile application built with Flutter, offering a seamless shopping experience for groceries and daily essentials.

## Features

### Authentication & User Management
- OTP-based mobile authentication
- User profile management
- Secure token-based session management

### Product Management
- Browse products by categories and subcategories
- View exclusive and best-selling products
- Infinite scroll product listings (up to 200 products per view)
- Product search functionality
- Product filtering by categories
- Dynamic product variants with pricing
- Product image gallery with carousel view

### Shopping Experience
- Real-time cart management
- Cart item quantity updates
- Order tracking and history
- Multiple delivery address management
- Secure checkout process

### UI/UX Features
- Material Design 3 implementation
- Responsive layouts for various screen sizes
- Custom bottom sheets for product details
- Pull-to-refresh functionality
- Loading state indicators
- Error handling with user-friendly messages
- Cart badge with real-time updates
- Image placeholders for products without images

### Technical Features
- State management using Riverpod
- Navigation using GoRouter
- RESTful API integration with Dio
- Secure storage for sensitive data
- Offline support capabilities
- Cached image loading
- Debounced search functionality
- Pagination support
- Real-time data updates

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- iOS development setup (for iOS builds)

### Installation
1. Clone the repository
```bash
git clone [repository-url]
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Configuration
- Update the API base URL in `lib/core/network/api_config.dart`
- Configure environment-specific variables if needed

## Architecture

The app follows a clean architecture pattern with the following structure:

```
lib/
├── core/
│   ├── models/
│   ├── network/
│   ├── providers/
│   ├── services/
│   ├── theme/
│   └── utils/
└── presentation/
    ├── features/
    │   ├── authentication/
    │   ├── cart/
    │   ├── categories/
    │   ├── orders/
    │   ├── product/
    │   ├── profile/
    │   ├── settings/
    │   └── shop/
    └── shared/
        └── widgets/
```

## Latest Updates

- Improved category navigation with proper subcategory handling
- Enhanced product filtering and display
- Optimized API calls for better performance
- Added infinite scroll support for product listings
- Implemented proper error handling and loading states
- Added support for products without images
- Fixed category product listing issues

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details
