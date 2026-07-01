class VolunteerActivityValidator {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Title is required";
    }

    if (value.trim().length < 3) {
      return "Title must be at least 3 characters";
    }

    if (value.trim().length > 200) {
      return "Title cannot exceed 200 characters";
    }

    return null;
  }

  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Description is required";
    }

    if (value.trim().length < 10) {
      return "Description must be at least 10 characters";
    }

    return null;
  }

  static String? validateMaxVolunteers(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Maximum volunteers is required";
    }

    final number = int.tryParse(value);

    if (number == null) {
      return "Invalid number";
    }

    if (number <= 0) {
      return "Must be greater than 0";
    }

    return null;

  }
  static String? validateLocation(int? value) {
    if (value == null) {
      return "Location is required";
    }

    return null;
  }
}