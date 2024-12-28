import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalDetailsState {
  final String name;
  final String email;
  final String? nameError;
  final String? emailError;
  final bool isValid;

  PersonalDetailsState({
    this.name = '',
    this.email = '',
    this.nameError,
    this.emailError,
    this.isValid = false,
  });

  PersonalDetailsState copyWith({
    String? name,
    String? email,
    String? nameError,
    String? emailError,
    bool? isValid,
  }) {
    return PersonalDetailsState(
      name: name ?? this.name,
      email: email ?? this.email,
      nameError: nameError,  
      emailError: emailError,  
      isValid: isValid ?? this.isValid,
    );
  }
}

class PersonalDetailsNotifier extends StateNotifier<PersonalDetailsState> {
  PersonalDetailsNotifier() : super(PersonalDetailsState());

  void updateName(String name) {
    String? error;
    if (name.isEmpty) {
      error = 'Name is required';
    } else if (name.length < 2) {
      error = 'Name must be at least 2 characters';
    }

    state = state.copyWith(
      name: name,
      nameError: error,  
      isValid: _isFormValid(name: name),
    );
  }

  void updateEmail(String email) {
    String? error;
    if (email.isEmpty) {
      error = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      error = 'Please enter a valid email';
    }

    state = state.copyWith(
      email: email,
      emailError: error,  
      isValid: _isFormValid(email: email),
    );
  }

  bool _isFormValid({String? name, String? email}) {
    final currentName = name ?? state.name;
    final currentEmail = email ?? state.email;

    bool isNameValid = currentName.length >= 2;
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(currentEmail);

    return isNameValid && isEmailValid;
  }
}

final personalDetailsProvider =
    StateNotifierProvider<PersonalDetailsNotifier, PersonalDetailsState>((ref) {
  return PersonalDetailsNotifier();
});
