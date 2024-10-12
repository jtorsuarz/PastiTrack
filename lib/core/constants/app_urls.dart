class AppUrls {
  static const String initial = '/';
  static const String homePath = '/home';
  static const String signInPath = '/sign-in';
  static const String signUpPath = '/sign-up';
  static const String signUpSuccessPath = '/sign-up-success';
  static const String forgotPasswordPath = '/forgot-password';
  static const String medicinesPath = '/medication';
  static const String addMedicinesPath = '/medication/add';
  static const String medicineDetailsPath = '/medication/:id';
  static const String routinesPath = '/ routines';
  static const String settingsPath = '/settings';
  static const String editProfilePath = '/edit-profile';
  static const String historyPath = '/history';

  ///  fn remove first '/' from the path
  static String removeSlash(String path) => path.replaceFirst('/', '');
}
