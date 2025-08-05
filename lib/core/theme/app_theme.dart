import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_pallette.dart';

@immutable
class CustomCardTheme extends ThemeExtension<CustomCardTheme> {
  final Color? color;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final EdgeInsetsGeometry? margin;

  const CustomCardTheme({
    this.color,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.margin,
  });

  @override
  ThemeExtension<CustomCardTheme> copyWith({
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCardTheme(
      color: color ?? this.color,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      margin: margin ?? this.margin,
    );
  }

  @override
  ThemeExtension<CustomCardTheme> lerp(
    ThemeExtension<CustomCardTheme>? other,
    double t,
  ) {
    if (other is! CustomCardTheme) {
      return this;
    }
    return CustomCardTheme(
      color: Color.lerp(color, other.color, t),
      elevation: t < 0.5 ? elevation : other.elevation,
      shape: t < 0.5 ? shape : other.shape,
      clipBehavior: t < 0.5 ? clipBehavior : other.clipBehavior,
      margin: EdgeInsetsGeometry.lerp(margin, other.margin, t),
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppPallete.primaryColor,
      onPrimary: AppPallete.onPrimary,
      secondary: AppPallete.secondaryColor,
      onSecondary: AppPallete.onSecondary,
      tertiary: AppPallete.successColor, // Teal for tertiary actions
      onTertiary: AppPallete.onSuccess,
      error: AppPallete.errorColor,
      onError: AppPallete.onError,
      surface: AppPallete.surfaceLight,
      onSurface: AppPallete.onSurfaceLight,
      background: AppPallete.backgroundLight,
      onBackground: AppPallete.onSurfaceLight,
      outline: AppPallete.borderColor,
      outlineVariant: AppPallete.neutral200,
    );

    final cardTheme = CustomCardTheme(
      color: colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8.0),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: [cardTheme],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPallete.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppPallete.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppPallete.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(
          color: AppPallete.neutral500,
          fontSize: 16,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: AppPallete.neutral500,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      dividerTheme: DividerThemeData(
        color: AppPallete.dividerColor,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppPallete.neutral100,
        selectedColor: colorScheme.primary,
        labelStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppPallete.primaryColor,
      onPrimary: AppPallete.onPrimary,
      secondary: AppPallete.secondaryColor,
      onSecondary: AppPallete.onSecondary,
      error: AppPallete.errorColor,
      onError: AppPallete.onError,
      surface: AppPallete.surfaceDark,
      onSurface: AppPallete.onSurfaceDark,
    );

    final cardTheme = CustomCardTheme(
      color: colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8.0),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: [cardTheme],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurface.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
