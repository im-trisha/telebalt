part of '../providers.dart';

final botProvider = Provider<Bot<TgContext>>((ref) {
  final maybeApi = ref.read(settingsProvider).apiUrl ?? '';
  final botApi = Uri.tryParse(maybeApi)?.toString() ?? RawAPI.defaultBase;
  final botToken = ref.read(settingsProvider).botToken;

  final bot = Bot<TgContext>.local(
    botToken,
    baseURL: botApi,
    fetcher: LongPolling(allowedUpdates: K.allowedUpdates),
  );
  ref.onDispose(bot.stop);

  return bot;
});
