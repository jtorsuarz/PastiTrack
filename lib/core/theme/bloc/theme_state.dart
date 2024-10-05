part of 'theme_bloc.dart';

class ThemeState {
  final ThemeData themeData;
  final int selectedColor;
  final bool isDarkMode;

  ThemeState({
    required this.themeData,
    required this.selectedColor,
    required this.isDarkMode,
  });

  // Copia del estado actual con posibles modificaciones
  ThemeState copyWith({
    ThemeData? themeData,
    int? selectedColor,
    bool? isDarkMode,
  }) {
    return ThemeState(
      themeData: themeData ?? this.themeData,
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
