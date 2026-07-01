class AnnouncementValidator {
  static String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Title is required.";
    }

    if (value.trim().length < 3 ||
        value.trim().length > 200) {
      return "Title must be between 3 and 200 characters.";
    }

    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Content is required.";
    }

    if (value.trim().length < 10) {
      return "Content must be at least 10 characters.";
    }

    return null;
  }
}