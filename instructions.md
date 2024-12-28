# ShopInfinity - Grocery Shopping App

## Project Overview
ShopInfinity is a Flutter-based grocery shopping application that provides a seamless shopping experience for users. The application follows Domain-Driven Design (DDD) principles with initial focus on the presentation layer.

## Tech Stack
- **Framework**: Flutter
- **State Management**: flutter_riverpod
- **Code Generation**: 
  - freezed
  - freezed_annotation
  - json_annotation
  - json_serializable
  - build_runner
- **Navigation**: go_router
- **API Communication**: http package

## Project Structure Guidelines

### 1. Authentication Flow
- **Screens**:
  - Splash Screen
  - Welcome Screen
  - Login Screen (Phone Number)
  - OTP Verification Screen
  - Personal Details Screen
    - Name
    - Email

### 2. Shopping Flow
- **Screens**:
  - Home Screen
  - Search Screen
  - Product Details Overlay
  - Filter Overlay
  - All Products Screen
  - Categories Screen
  - Category Products Screen
  - Product Details Screen

### 3. Settings Flow
- **Screens**:
  - Settings Main Screen
  - My Orders Screen
    - Order Details Screen
  - Account Privacy Screen
  - About Us Screen
  - Saved Addresses Screen
    - Add Address Screen

### 4. Checkout Flow
- **Screens**:
  - Cart Screen
  - Add Address Screen
  - Payment Method Screen
  - Select Address Overlay
  - Order Placed Screen
  - Order Details Screen

## Development Guidelines

### 1. Project Structure
```
lib/
├── presentation/
│   ├── auth/
│   ├── shopping/
│   ├── settings/
│   └── checkout/
├── application/
├── domain/
└── infrastructure/
```

### 2. State Management
- Use Riverpod for state management
- Create separate providers for different features
- Follow the recommended Riverpod patterns for state handling

### 3. Models
- Use Freezed for immutable state models
- Generate JSON serializers using json_serializable
- Keep models in respective domain folders

### 4. Navigation
- Implement go_router for navigation
- Define routes in a centralized location
- Use typed navigation when possible

### 5. UI Guidelines
- Follow Material Design 3 guidelines
- Maintain consistent spacing and typography
- Use theme extensions for custom styles
- Implement responsive layouts

### 6. Code Generation
Run the following command after making changes to freezed models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Git Workflow
- Create feature branches from development
- Use meaningful commit messages
- Follow conventional commits pattern

## Getting Started
1. Clone the repository
2. Run `flutter pub get`
3. Run code generation
4. Start with the presentation layer implementation

## Important Notes
- Focus initially on UI implementation
- Use Figma CSS and screenshots for pixel-perfect implementation
- Maintain clean architecture principles even in presentation layer
- Document all widget implementations
- Create reusable components when possible
