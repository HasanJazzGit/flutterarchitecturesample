import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DashboardState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;

  const DashboardState({required this.themeMode, required this.locale});

  factory DashboardState.initial() {
    return const DashboardState(
      themeMode: ThemeMode.system,
      locale: Locale('en'),
    );
  }

  DashboardState copyWith({ThemeMode? themeMode, Locale? locale}) {
    return DashboardState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [themeMode, locale];
}
