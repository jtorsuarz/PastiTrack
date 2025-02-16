import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pasti_track/core/config.dart';
import 'package:go_router/go_router.dart';
import 'package:pasti_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pasti_track/features/settings/presentation/widgets/dark_mode_switch_widget.dart';
import 'package:pasti_track/features/settings/presentation/widgets/settings_tile_widget.dart';
import 'package:pasti_track/features/settings/presentation/widgets/theme_dropdown_widget.dart';

// ignore: must_be_immutable
class SettingsScreen extends StatefulWidget {
  bool showAppBar;
  SettingsScreen({super.key, this.showAppBar = true});

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

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showAppBar = widget.showAppBar;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppUrls.signInPath);
        }
      },
      child: Scaffold(
        appBar: showAppBar
            ? AppBar(
                title: const Text(AppString.settings),
              )
            : null,
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            SettingsTileWidget(
              icon: Icons.person,
              title: AppString.editProfile,
              onTap: () => context.push(AppUrls.editProfilePath),
            ),
            const Divider(),
            const ThemeDropdownWidget(),
            const Divider(),
            const DarkModeSwitchWidget(),
            const Divider(),
            SettingsTileWidget(
              icon: Icons.info_outline,
              title: AppString.appVersion,
              subtitle: _appVersion,
            ),
            const Divider(),
            SettingsTileWidget(
              icon: Icons.logout,
              title: AppString.logout,
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

  void _logout() {
    context.read<AuthBloc>().add(AuthLoggedOut());
    context.go(AppUrls.signInPath);
  }

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
