// TODO Implement this library.import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const AppState({required this.themeMode, required this.locale});

  factory AppState.initial() {
    return const AppState(themeMode: ThemeMode.system, locale: Locale('en'));
  }

  AppState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [themeMode, locale];
}
