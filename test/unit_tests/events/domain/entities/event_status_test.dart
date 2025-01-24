import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Asumiendo que ya tienes la función getStatusColor
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
      return Colors.grey;
  }
}

void main() {
  test('return color blue for status "pending"', () {
    final result = getStatusColor('pending');
    expect(result, Colors.blue);
  });

  test('return color green for status "registered"', () {
    final result = getStatusColor('registered');
    expect(result, Colors.green);
  });

  test('return color purple for status "completed"', () {
    final result = getStatusColor('completed');
    expect(result, Colors.purple);
  });

  test('return color red for status "canceled"', () {
    final result = getStatusColor('canceled');
    expect(result, Colors.red);
  });

  test('return color grey for status "unknown"', () {
    final result = getStatusColor('unknown');
    expect(result, Colors.grey);
  });
}
