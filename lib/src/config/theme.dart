part of 'config.dart';

class AppTheme{
  static ThemeData getAppTheme([bool dark = false]){
    final base = ThemeData(brightness: dark?Brightness.dark: Brightness.light);

    return base.copyWith();
  }

  static var defaultColours = <Color>[];
}