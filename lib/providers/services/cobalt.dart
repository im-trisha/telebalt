part of '../providers.dart';

final cobaltServiceProvider = Provider<CobaltService>((ref) {
  final cobalt = CobaltService(
    ref.read(dioProvider),
    baseUrl: ref.read(settingsProvider).cobaltUrl,
  );
  return cobalt;
});
