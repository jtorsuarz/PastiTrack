import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pasti_track/core/config.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
      : super(ThemeState(
          themeData: AppTheme(selectedColor: AppDotEnv.selectedColorInitial)
              .theme(
                  isDarkMode: AppDotEnv
                      .isDarkMode), // Inicializa con el tema predeterminado
          selectedColor: AppDotEnv.selectedColorInitial,
          isDarkMode: AppDotEnv.isDarkMode,
        )) {
    on<ChangeThemeColor>((event, emit) {
      // Cambiar el color del tema
      final newTheme = AppTheme(selectedColor: event.colorIndex)
          .theme(isDarkMode: state.isDarkMode);
      emit(state.copyWith(
        themeData: newTheme,
        selectedColor: event.colorIndex,
      ));
    });

    on<ToggleDarkMode>((event, emit) {
      // Cambiar entre modo claro y oscuro
      final newTheme = AppTheme(selectedColor: state.selectedColor)
          .theme(isDarkMode: event.isDarkMode);
      emit(state.copyWith(
        themeData: newTheme,
        isDarkMode: event.isDarkMode,
      ));
    });
  }
}
