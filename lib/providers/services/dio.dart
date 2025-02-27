part of '../providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ref.read(settingsProvider).cobaltUrl,
      validateStatus: (status) => (status ?? 0) < 500,
    ),
  );

  ref.onDispose(dio.close);
  return dio;
});
