import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// 🎨 لوحة ألوان إسلامية عصرية
const Color emerald = Color(0xFF087F5B);       // أخضر زمردي (لون إسلامي تقليدي)
const Color deepGreen = Color(0xFF064E3B);     // أخضر داكن
const Color gold = Color(0xFFD4AF37);          // ذهبي (زخارف)
const Color warmWhite = Color(0xFFFAFAF5);     // أبيض دافئ
const Color lightBackground = Color(0xFFF3F6F2);
const Color darkText = Color(0xFF1F2937);
const Color correctGreen = Color(0xFF0E9F6E);
const Color wrongRed = Color(0xFFDC2626);

// ✍️ خطوط:
// Amiri للعناوين الكبيرة (طابع إسلامي أنيق)
// Cairo للنصوص (واضح جدًا للقراءة)

TextStyle cairo({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return GoogleFonts.cairo(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

TextStyle amiri({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return GoogleFonts.amiri(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}