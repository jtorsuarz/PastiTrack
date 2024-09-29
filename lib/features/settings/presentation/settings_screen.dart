import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/core/theme/bloc/theme_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/features/auth/presentation/auth_wrapper/bloc/auth_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = AppDotEnv.appVersion;

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  // Método para cargar la versión de la aplicación
  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppUrls.signInPath); // Redirigir al login
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.settings),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            ///  button for navigation Edit Profile Screen
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(AppString.editProfile),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.push(AppUrls.editProfilePath);
              },
            ),
            const Divider(),

            /// Option to change the theme of the app
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text(AppString.changeTheme),
                  trailing: DropdownButton<int>(
                    value: state.selectedColor,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        // Cambiar el tema enviando el evento al BLoC
                        context
                            .read<ThemeBloc>()
                            .add(ChangeThemeColor(newValue));
                      }
                    },
                    items: List.generate(
                      AppTheme.lengthColorList(),
                      (index) => DropdownMenuItem(
                        value: index,
                        child: Text('Tema ${index + 1}'),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(),

            // Option to activate/deactivate the dark mode
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return SwitchListTile(
                  title: const Text(AppString.darkMode),
                  value: state.isDarkMode,
                  onChanged: (bool value) {
                    // Change dark/light mode
                    context.read<ThemeBloc>().add(ToggleDarkMode(value));
                  },
                );
              },
            ),
            const Divider(),

            // Show application version
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(AppString.appVersion),
              subtitle: Text(_appVersion),
            ),
            const Divider(),

            // Option to log out
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(AppString.logout),
              onTap: () async {
                bool confirm = await _showSignOutConfirmation();

                if (!mounted) return;

                if (confirm) {
                  _logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _logout() {
    context.read<AuthBloc>().add(AuthLoggedOut());
    context.go(AppUrls.signInPath);
  }

  // Logout confirmation dialog
  Future<bool> _showSignOutConfirmation() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(AppString.logout),
          content: const Text(AppString.areYouSureWantToLogOut),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(AppString.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(AppString.logout),
            ),
          ],
        ),
      ) ??
      false;
}
