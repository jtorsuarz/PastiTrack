class AppString {
  static const String appTitle = 'PastiTrack';
  static const String signIn = 'Iniciar Sesión';
  static const String welcomePastiTrack = 'Bienvenido a PastiTrack';
  static const String email = 'Correo Electrónico';
  static const String password = 'Contraseña';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String signUp = 'Registrarse';
  static const String goToSignIn = 'Ir a Iniciar Sesión';
  static const String enjoyTheApp = 'Disfrutar de la app';
  static const String recoveryPassword = 'Recuperar Contraseña';
  static const String recoveryPasswordEmailSend =
      'Correo de recuperación enviado';
  static const String tryAgain = 'Reintentar';
  static const String home = 'Inicio';
  static const String medicines = 'Medicinas';
  static const String routines = 'Rutinas';
  static const String history = 'Historial';
  static const String settings = 'Ajustes';
  static const String profile = 'Perfil';
  static const String editProfile = 'Editar Perfil';
  static const String changeTheme = 'Cambiar Tema';
  static const String darkMode = 'Modo oscuro';
  static const String logout = 'Cerrar Sesión';
  static const String cancel = 'Cancelar';
  static const String areYouSureWantToLogOut =
      '¿Estás seguro de que quieres cerrar sesión?';
  static const String appVersion = 'Versión de la App';
  static const String name = 'Name';
  static const String updateProfile = 'Actualizar Perfil';
  static const String changePassword = 'Cambiar contraseña';
  static const String newPassword = 'Nueva Contraseña';
  static const String confirmPassword = 'Repita la contraseña';
  static const String change = 'Cambiar';
  static const String unauthenticated = 'No autenticado';
  static const String addMedication = 'Añadir medicación';
  static const String nameMedication = 'Nombre del medicamento';
  static const String dosage = 'Dosis';
  static const String description = 'Descripción';
  static const String descriptionOptional = 'Descripción (Opcional)';
  static const String save = 'Guardar';
  static const String medicationManagement = 'Gestión de Medicamentos';
  static const String medicaments = 'Medicamentos';
  static const String medicament = 'Medicamento';
  static const String noMedicines = 'No hay medicamentos registrados';

  // * Success messages
  static const String success = 'Éxito';
  static const String successPasswordChanged =
      'Contraseña cambiada exitosamente.';
  static const String signUpSuccess = 'Registro Exitoso';
  static const String signInCompleteSuccess =
      '¡Registro completado exitosamente!';
  static const String successProfileUpdated =
      'Perfil actualizado exitosamente.';
  static const String entryName = 'Ingrese el nombre';
  static const String entryDosage = 'Ingrese la dosis';

  // ! Error Messages
  static const String error = 'Error';
  static const String errorUnknown = 'Error desconocido';
  static const String errorVerifyStatusAuth =
      'Error al verificar el estado de autenticación';
  static const String errorSignIn = 'Error al iniciar sesión';
  static const String errorSignUp = 'Error al registrar';
  static const String errorPasswordReset = 'Error al restablecer la contraseña';
  static const String errorChangePassword = 'Error al cambiar la contraseña';
  static const String errorSignOut = 'Error al cerrar sesión';
  static const String errorPasswordMismatch = 'Las contraseñas no coinciden';
  static const String errorEmailMismatch =
      'Los correos electrónicos no coinciden';
  static const String errorEmailExists = 'El correo electrónico ya existe';
  static const String errorInvalidEmail = 'Correo electrónico inválido';
  static const String errorInvalidPassword = 'Contraseña inválida';
  static const String errorNoInternet = 'No hay conexión a internet';
  static const String errorNoData = 'No hay datos disponibles';
  static const String unexpectedErrorOcurred = 'Ocurrió un error inesperado.';
  static const String errorEmailPasswordCannotBeEmpty =
      'El correo electrónico y la contraseña no pueden estar vacíos.';
  static const String errorCommunicationServer =
      'Error al comunicarse con el servidor.';
  static const String errorUserNotFound = 'Usuario no encontrado.';
  static const String errorAuthentication = 'Error de autenticación';

  // ? Functions return a string
  static String userFromTime(v) => 'Usuario desde: $v';
  static String redirectAutomaticSeconds(s) =>
      'Serás redirigido automáticamente en $s segundos.';
  static String errorWithFormat(v) => 'Error :$v';
  static String errorOcurred(v) => 'Ocurrió un error: $error';
  static String errorWhenLoadingProfile(v) => 'Error al cargar el perfil: $v';
  static String errorWhenUpdateProfile(v) =>
      'Error al actualizar el perfil: $v';
  static String errorWhenChangePassword(v) =>
      'Error al cambiar la contraseña: $v';
  static String errorWhenChangePhotoProfile(v) =>
      'Error al actualizar la imagen: $v';
  static String optionTheme(v) => 'Tema $v';
  static String dosageWithQuantityAndUnitMesuared(v) =>
      'Dosis: $v${_unitMesuareByCountry()}';
  static String _unitMesuareByCountry() => 'LOCALE' == "ES" ? 'mg' : 'mg';
  static String medicationOrder(v) => 'Medicamento $v';
  static String errorWhenCreate(v) => 'Error al crear: $v';
  static String errorWhenDelete(v) => 'Error al eliminar: $v';
  static String errorWhenUpdate(v) => 'Error al actualizar: $v';
  static String errorWhenLoad(v) => 'Error al cargar: $v';
}
