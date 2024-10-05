import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF49149F);

const List<Color> colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor <= colorThemes.length - 1,
            'Colors must be between 0 and ${colorThemes.length}');

  // Definimos los temas claro y oscuro
  ThemeData theme({bool isDarkMode = false}) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: colorThemes[selectedColor],
      brightness: isDarkMode
          ? Brightness.dark
          : Brightness.light, // Soporte para dark mode

      // Configuración específica para modo claro
      appBarTheme: AppBarTheme(
        backgroundColor: isDarkMode
            ? Colors.grey[900]
            : colorThemes[selectedColor], // Color oscuro para dark mode
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.white),
        elevation: 0, // Sin sombra para un look más limpio
      ),

      // Configuración para BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: colorThemes[selectedColor],
        unselectedItemColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

      // Estilo para FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorThemes[selectedColor],
        foregroundColor: Colors.white,
      ),

      // Estilo para ElevatedButton
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorThemes[selectedColor],
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Configuración para campos de texto en InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDarkMode
            ? Colors.grey[800]
            : Colors.grey[200], // Ajuste de fondo para dark mode
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorThemes[selectedColor]),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorThemes[selectedColor]),
        ),
        labelStyle: TextStyle(color: colorThemes[selectedColor]),
      ),

      // Textos
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colorThemes[selectedColor],
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.white : colorThemes[selectedColor],
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.white60 : Colors.black54,
        ),
      ),
    );
  }

  static int lengthColorList() => colorThemes.length;
}
