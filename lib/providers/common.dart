part of 'providers.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ref.watch(settingsProvider).cobaltUrl,
    validateStatus: (status) => (status ?? 0) < 500,
  ));
  ref.onDispose(dio.close);

  return dio;
});

final settingsProvider = Provider<Settings>((ref) {
  final settings = Settings.fromJson(DotEnv().getDotEnv());
  return settings;
});

final loggerProvider = Provider<Talker>((ref) {
  final talker = Talker(settings: TalkerSettings(useHistory: false));
  return talker;
});

final cobaltServiceProvider = Provider<CobaltService>((ref) {
  final cobalt = CobaltService(
    ref.watch(dioProvider),
    baseUrl: ref.watch(settingsProvider).cobaltUrl,
  );
  return cobalt;
});

final databaseProvider = Provider<Database>((ref) {
  final founderId = int.tryParse(ref.watch(settingsProvider).adminId);
  if (founderId == null) {
    ref.read(loggerProvider).error("ADMIN_ID must be an integer.");
    throw Exception("ADMIN_ID must be an integer.");
  }

  final database = Database(ref.watch(settingsProvider).storagePath, founderId);
  ref.onDispose(database.close);
  return database;
});

final botProvider = Provider<Bot<TgContext>>((ref) {
  final maybeApi = ref.watch(settingsProvider).apiUrl ?? '';
  final botApi = Uri.tryParse(maybeApi)?.toString() ?? RawAPI.defaultBase;
  final botToken = ref.watch(settingsProvider).botToken;

  final bot = Bot<TgContext>(botToken, baseURL: botApi);
  ref.onDispose(bot.stop);

  return bot;
});
