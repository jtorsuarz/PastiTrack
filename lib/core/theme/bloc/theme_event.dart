part of 'theme_bloc.dart';

abstract class ThemeEvent {}

class ChangeThemeColor extends ThemeEvent {
  final int colorIndex;

  ChangeThemeColor(this.colorIndex);
}

class ToggleDarkMode extends ThemeEvent {
  final bool isDarkMode;

  ToggleDarkMode(this.isDarkMode);
}
