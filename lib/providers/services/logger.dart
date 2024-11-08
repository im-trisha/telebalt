part of '../providers.dart';

final loggerProvider = Provider<Talker>((ref) {
  final talker = Talker(settings: TalkerSettings(useHistory: false));
  return talker;
});
