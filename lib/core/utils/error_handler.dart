import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class AppErrorHandler {
  static String getMessage(Object e) {
    final errorStr = e.toString();

    // Errores de red
    if (e is SocketException ||
        errorStr.contains('SocketException') ||
        errorStr.contains('Failed host lookup')) {
      return 'Sin conexión a Internet. Por favor, verificá tu red e intentalo de nuevo.';
    }

    // Errores de Supabase
    if (e is AuthException) {
      if (e.message.contains('Email not confirmed')) {
        return 'Tenés que verificar tu correo antes de entrar.';
      }

      return e.message;
    }

    // Fallback
    return 'Ocurrió un error inesperado: $e';
  }
}

class NetworkException implements Exception {
  final String message = 'Sin conexión a Internet.';

  @override
  String toString() => message;
}
