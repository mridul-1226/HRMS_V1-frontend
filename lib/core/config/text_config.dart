
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrms/core/config/color_cofig.dart';

class AppTypography {
  static TextStyle headline1({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 92,
    fontWeight: fontWeight ?? FontWeight.w300,
    letterSpacing: (-1.5),
    color: color,
    height: height,
  );

  static TextStyle headline2({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 58,
    fontWeight: fontWeight ?? FontWeight.w300,
    letterSpacing: (-0.5),
    color: color,
    height: height,
  );

  static TextStyle headline3({
    Color? color,
    FontWeight? fontWeight,
    double height = 62 / 46,
  }) => GoogleFonts.poppins(
    fontSize: 46,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 0,
    color: color,
    height: height,
  );

  static TextStyle headline4({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: fontWeight ?? FontWeight.w600,
    letterSpacing: 0.25,
    color: color,
    height: (height ?? 1.5),
  );

  static TextStyle headline5({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 0,
    color: color,
    height: height,
  );

  static TextStyle headline6({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: fontWeight ?? FontWeight.w600,
    letterSpacing: 0.15,
    color: color,
    height: (height ?? 1.5),
  );

  static TextStyle body1({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 0.5,
    color: color,
    height: height,
  );

  static TextStyle body2({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 0.25,
    color: color,
    height: (height ?? 1.43),
  );

  static TextStyle button({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: fontWeight ?? FontWeight.w700,
    letterSpacing: 0.25,
    color: color ?? AppColors.primary,
    height: (height ?? (20 / 14)),
  );

  static TextStyle caption({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 0.4,
    color: color,
    height: height ?? 1.33,
  );

  static TextStyle overline({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 10,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 1.5,
    color: color,
    height: (height ?? 1.43),
  );

  static TextStyle small({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 8,
    fontWeight: fontWeight ?? FontWeight.w400,
    letterSpacing: 0.4,
    color: color,
    height: (height ?? 1.5),
  );

  static TextStyle bodyRegular18({
    Color? color,
    FontWeight? fontWeight,
    double? height,
  }) => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: fontWeight ?? FontWeight.w400,
    color: color,
    height: (height ?? 1.33),
  );
}
