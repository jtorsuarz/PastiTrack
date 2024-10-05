import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/theme/bloc/theme_bloc.dart';

class ThemeDropdownWidget extends StatelessWidget {
  /// Option to change the theme of the app
  const ThemeDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.palette),
          title: const Text(AppString.changeTheme),
          trailing: DropdownButton<int>(
            value: state.selectedColor,
            onChanged: (int? newValue) {
              if (newValue != null) {
                context.read<ThemeBloc>().add(ChangeThemeColor(newValue));
              }
            },
            items: List.generate(
              AppTheme.lengthColorList(),
              (index) => DropdownMenuItem(
                value: index,
                child: Text(AppString.optionTheme(index + 1)),
              ),
            ),
          ),
        );
      },
    );
  }
}
