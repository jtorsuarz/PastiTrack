import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/theme/bloc/theme_bloc.dart';
import 'package:pasti_track/core/config.dart';

/// Switch to change dark mode
class DarkModeSwitchWidget extends StatelessWidget {
  const DarkModeSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text(AppString.darkMode),
          value: state.isDarkMode,
          onChanged: (bool value) {
            context.read<ThemeBloc>().add(ToggleDarkMode(value));
          },
        );
      },
    );
  }
}
