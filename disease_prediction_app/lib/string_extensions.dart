extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return split(' ').map((word) {
      if (word.isEmpty) return "";
      return "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
    }).join(' ');
  }

  String formatSymptom() {
    return replaceAll('_', ' ').capitalize();
  }
}
