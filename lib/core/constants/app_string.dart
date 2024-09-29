class AppString {
  static const String appTitle = 'PastiTrack';
  static const String signIn = 'Iniciar Sesión';
  static const String welcomePastiTrack = 'Bienvenido a PastiTrack';
  static const String email = 'Correo Electrónico';
  static const String password = 'Contraseña';
  static const String forgotPassword = '¿Olvidaste tu contraseña?';
  static const String signUp = 'Registrarse';
  static const String signUpSuccess = 'Registro Exitoso';
  static const String signInCompleteSuccess =
      '¡Registro completado exitosamente!';
  static const String goToSignIn = 'Ir a Iniciar Sesión';
  static const String recoveryPassword = 'Recuperar Contraseña';
  static const String recoveryPasswordEmailSend =
      'Correo de recuperación enviado';
  static const String tryAgain = 'Reintentar';

  // ! Navigation Drawer Menu Items
  static const String home = 'Inicio';
  static const String medicines = 'Medicinas';
  static const String routines = 'Rutinas';
  static const String history = 'Historial';
  static const String settings = 'Ajustes';

  // ! Error Messages
  static const String error = 'Error';
  static const String errorVerifyStatusAuth =
      'Error al verificar el estado de autenticación';
  static const String errorSignIn = 'Error al iniciar sesión';
  static const String errorSignUp = 'Error al registrar';
  static const String errorPasswordReset = 'Error al restablecer la contraseña';
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
  static String redirectAutomaticSeconds(s) =>
      'Serás redirigido automáticamente en $s segundos.';
  static String errorWithFormat(v) => 'Error :$v';
  static String errorOcurred(v) => "Ocurrió un error: $error";
}
