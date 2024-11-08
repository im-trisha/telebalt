part of '../providers.dart';

final settingsProvider = Provider<Settings>((ref) {
  final settings = Settings.fromJson(DotEnv().getDotEnv());
  return settings;
});
