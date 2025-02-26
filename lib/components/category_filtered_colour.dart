import 'dart:ui';

import 'package:flutter/material.dart';

Color getCategoryColor(String category) {
  switch (category) {
    case 'Food':
      return Colors.green;
    case 'Transport':
      return Colors.red;
    case 'Entertainment':
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}
