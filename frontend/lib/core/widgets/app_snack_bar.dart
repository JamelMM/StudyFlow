import 'package:flutter/material.dart';

SnackBar appSuccessSnackBar(String message) {
  return _appSnackBar(
    message: message,
    backgroundColor: const Color(0xFFD1FAE5),
    foregroundColor: const Color(0xFF0F172A),
  );
}

SnackBar appErrorSnackBar(String message) {
  return _appSnackBar(
    message: message,
    backgroundColor: const Color(0xFFFEE2E2),
    foregroundColor: const Color(0xFF0F172A),
  );
}

SnackBar appDeleteSnackBar(String message) {
  return _appSnackBar(
    message: message,
    backgroundColor: const Color(0xFFFEE2E2),
    foregroundColor: const Color(0xFF0F172A),
  );
}

SnackBar appInfoSnackBar(String message) {
  return _appSnackBar(
    message: message,
    backgroundColor: const Color(0xFFDCE5FF),
    foregroundColor: const Color(0xFF14213D),
  );
}

SnackBar _appSnackBar({
  required String message,
  required Color backgroundColor,
  required Color foregroundColor,
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: backgroundColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: foregroundColor, fontWeight: FontWeight.w600),
    ),
  );
}
