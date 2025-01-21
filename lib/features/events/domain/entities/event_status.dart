import 'package:flutter/material.dart';

enum EventStatus {
  pending,
  registered,
  completed,
  passed,
  canceled,
}

// Función que devuelve el color basado en el status
Color getStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.blue;
    case 'registered':
      return Colors.green;
    case 'completed':
      return Colors.purple;
    case 'canceled':
      return Colors.red;
    default:
      return Colors.grey; // Color por defecto si no coincide
  }
}
