part of 'theme_bloc.dart';

@immutable
abstract class ThemeEvent extends Equatable {
  ThemeEvent() : super();

  @override
  List<Object> get props => [];
}

class ThemeInit extends ThemeEvent {}

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;

  ThemeChanged({
    required this.theme,
  });

  @override
  List<Object> get props => [theme];
}
