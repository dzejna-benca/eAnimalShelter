class AppValidators {
  static String? firstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "First name is required.";
    }

    if (value.length > 50) {
      return "First name can contain a maximum of 50 characters.";
    }

    return null;
  }

  static String? lastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Last name is required.";
    }

    if (value.length > 50) {
      return "Last name can contain a maximum of 50 characters.";
    }

    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email address is required.";
    }

    final regex = RegExp(
      r'^[^@]+@[^@]+\.[^@]+$',
    );

    if (!regex.hasMatch(value.trim())) {
      return "Enter a valid email address (example: user@example.com).";
    }

    return null;
  }

  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required.";
    }

    if (value.length < 3) {
      return "Username must contain at least 3 characters.";
    }

    if (value.length > 30) {
      return "Username can contain a maximum of 30 characters.";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required.";
    }

    if (value.length < 8) {
      return "Password must contain at least 8 characters.";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter.";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter.";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number.";
    }

    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(value.trim())) {
      return "Enter a valid phone number (8-15 digits, optional '+' at the beginning).";
    }

    return null;
  }

  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Address is required.";
    }

    if (value.length > 200) {
      return "Address can contain a maximum of 200 characters.";
    }

    return null;
  }

  static String? role(int? value) {
    if (value == null) {
      return "Please select a role.";
    }

    return null;
  }
  static String? animalName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Animal name is required.";
    }

    if (value.trim().length > 100) {
      return "Animal name can contain up to 100 characters.";
    }

    return null;
  }
  static String? animalDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Description is required.";
    }

    if (value.trim().length > 2000) {
      return "Description can contain up to 2000 characters.";
    }

    return null;
  }
  static String? healthStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Health status is required.";
    }

    if (value.trim().length > 500) {
      return "Health status can contain up to 500 characters.";
    }

    return null;
  }
  static String? personality(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Personality description is required.";
    }

    if (value.trim().length > 2000) {
      return "Personality description can contain up to 2000 characters.";
    }

    return null;
  }
  static String? medicalNotes(String? value) {
    if (value != null && value.length > 2000) {
      return "Medical notes can contain up to 2000 characters.";
    }

    return null;
  }
  static String? notificationTitle(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Title is required.";
  }

  if (value.trim().length < 3) {
    return "Title must be at least 3 characters.";
  }

  if (value.trim().length > 200) {
    return "Title can contain up to 200 characters.";
  }

  return null;
  }

  static String? notificationMessage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Message is required.";
    }

    if (value.trim().length < 5) {
      return "Message must be at least 5 characters.";
    }

    if (value.trim().length > 2000) {
      return "Message can contain up to 2000 characters.";
    }

    return null;
  }

  static String? notificationRecipient(
    String recipientType,
    dynamic selectedUser,
    dynamic selectedRole,
  ) {
    if (recipientType == "user" && selectedUser == null) {
      return "Please select a user.";
    }

    if (recipientType != "user" && selectedRole == null) {
      return "Please select a role.";
    }

    return null;
  }
}