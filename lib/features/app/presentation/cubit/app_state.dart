import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(Locale('en')) Locale locale,
  }) = _AppState;

  const AppState._();

}
