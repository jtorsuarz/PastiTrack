import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pasti_track/core/config.dart';
import 'package:pasti_track/features/profile/data/models/user_model.dart';
import 'package:pasti_track/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:pasti_track/features/profile/presentation/bloc/profile_event.dart';
import 'package:pasti_track/features/profile/presentation/bloc/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            _showSnackBar(state.message);
          }
          if (state is ProfilePasswordChanged) {
            _showSnackBar('Contraseña modificada correctamente.');
          }
          if (state is ProfileUpdated) {
            _showSnackBar('Perfil actualizado correctamente.');
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            nameController.text = profile.name;
            return _buildProfileContent(context, profile);
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Error desconocido.'));
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileModel profile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildProfileImage(profile),
          const SizedBox(height: 16),
          Text(profile.name, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(profile.email, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text('Usuario desde ${profile.createdAt}'),
          const SizedBox(height: 16),
          _buildTextField(nameController, 'Nombre'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _updateProfile(context),
            child: const Text('Actualizar Perfil'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => _showChangePasswordDialog(context),
            child: const Text('Cambiar Contraseña'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(ProfileModel profile) {
    return GestureDetector(
      onTap: () => _selectImage(),
      child: CircleAvatar(
        radius: 75,
        backgroundImage: profile.photoUrl != null
            ? FileImage(File(profile.photoUrl!))
            : AssetImage(AppImages.userDefault) as ImageProvider,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  void _updateProfile(BuildContext context) {
    context.read<ProfileBloc>().add(UpdateProfileEvent(
          name: nameController.text,
        ));
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context
          .read<ProfileBloc>()
          .add(UpdateProfileImageEvent(imagePath: image.path));
    }
  }

  void _showChangePasswordDialog(BuildContext context) {
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cambiar Contraseña'),
          content: _buildTextField(newPasswordController, 'Nueva Contraseña'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                context.read<ProfileBloc>().add(ChangePasswordEvent(
                      newPassword: newPasswordController.text,
                    ));
                Navigator.of(context).pop();
              },
              child: const Text('Cambiar'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
