part of '../providers.dart';

final databaseProvider = Provider<Database>((ref) {
  final founderId = int.tryParse(ref.read(settingsProvider).adminId);
  if (founderId == null) {
    ref.read(loggerProvider).error("ADMIN_ID must be an integer.");
    throw Exception("ADMIN_ID must be an integer.");
  }

  final database = Database(ref.read(settingsProvider).storagePath, founderId);
  ref.onDispose(database.close);
  return database;
});
