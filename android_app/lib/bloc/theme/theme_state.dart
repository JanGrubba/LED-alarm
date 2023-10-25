part of 'theme_bloc.dart';

@immutable
abstract class ThemeState extends Equatable {
  final ThemeData themeData;
  final String name;

  ThemeState({ThemeData? themeData, String? name})
      : themeData = themeData ?? appThemeData[AppTheme.Light]!,
        this.name = name ?? AppTheme.Light.name;

  @override
  List<Object?> get props => [themeData, name];
}

@immutable
class ThemeInitial extends ThemeState {
  ThemeInitial() : super();
}

@immutable
class ThemeChangeState extends ThemeState {
  ThemeChangeState({required ThemeData themeData, required String name}) : super(themeData: themeData, name: name);

}
